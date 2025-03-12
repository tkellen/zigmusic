const std = @import("std");
const steps = @import("steps.zig");

const allocator = std.heap.page_allocator;

pub const Pitch = enum(u8) {
    C,
    D,
    E,
    F,
    G,
    A,
    B,

    pub fn diatonicStep(self: Pitch, stepCount: i8) Pitch {
        return @enumFromInt(@as(u8, @intCast(@mod(@as(i8, @intCast(@intFromEnum(self))) + stepCount, 7))));
    }

    pub fn position(self: Pitch) i8 {
        return switch (self) {
            .C => 0,
            .D => 2,
            .E => 4,
            .F => 5,
            .G => 7,
            .A => 9,
            .B => 11,
        };
    }

    pub fn name(self: Pitch) []const u8 {
        return @tagName(self);
    }
};

pub const Accidental = enum {
    Natural,
    Sharp,
    Flat,
    DoubleSharp,
    DoubleFlat,

    pub fn offset(self: Accidental) i8 {
        return switch (self) {
            .Natural => 0,
            .Sharp => 1,
            .Flat => -1,
            .DoubleSharp => 2,
            .DoubleFlat => -2,
        };
    }

    pub fn name(self: Accidental) []const u8 {
        return switch (self) {
            .Natural => "",
            .Sharp => "♯",
            .Flat => "♭",
            .DoubleSharp => "𝄪",
            .DoubleFlat => "𝄫",
        };
    }
};

pub const Note = struct {
    pitch: Pitch,
    accidental: Accidental,

    // Computes the chromatic position of the note within the octave (0-11).
    // This is done by adding the pitch's natural chromatic position and the
    // accidental offset, then ensuring any numbers over 11 wrap around.
    pub fn chromaticPosition(self: Note) u8 {
        return @intCast(@mod(self.pitch.position() + self.accidental.offset(), 12));
    }

    // Computes the diatonic step movement of the note based on the given step type.
    // This determines how the pitch moves without considering accidentals.
    pub fn diatonicStep(self: Note, movement: steps.Step) Pitch {
        // Handle cases where a half-step movement does not change the natural note.
        if (movement == .Half) {
            // Calculate the new chromatic position after a half-step.
            const newChromaticPos = @as(i8, @intCast(@mod(self.chromaticPosition() + 1, 12)));

            // Get the expected **diatonic pitch** if moving up by one diatonic step.
            const nextDiatonic = self.pitch.diatonicStep(1);

            // Special Case: **E♯ and F are enharmonic equivalents** (both share chromatic position 5).
            // If moving from E♯, ensure that it correctly resolves to F♯ rather than misapplying accidentals.
            if (self.pitch == .E and nextDiatonic == .F) {
                return .F;
            }

            // If the difference between the chromatic position and diatonic position
            // is zero, it means the half step is large enough to step to the next pitch.
            if (@mod(newChromaticPos - nextDiatonic.position(), 12) == 0) {
                return nextDiatonic;
            } else {
                return self.pitch; // Stay on the same pitch, accidentals will handle chromatic shifts.
            }
        }

        // All other movements are large enough to have a fixed diatonic step.
        return self.pitch.diatonicStep(switch (movement) {
            .Whole, .Second, .Augmented_Second => 1,
            .Third => 2,
            .Fourth => 3,
            .Fifth => 4,
            .Sixth => 5,
            .Seventh => 6,
            .Octave => 7,
            else => unreachable, // Help Zig know that .Half has been handled.
        });
    }

    // This determines how the note moves by exact semitones, then applies the correct accidentals.
    pub fn chromaticStep(self: Note, movement: steps.Step) Note {
        const newChromaticPosition: i8 = @mod(@as(i8, @intCast(self.chromaticPosition())) + movement.chromatic(), 12);
        // Compute the new diatonic pitch without accidentals.
        const newPitch = self.diatonicStep(movement);
        // Use the new chromatic and diatonic positions to make the correct note.
        return Note.fromOffset(newPitch, newChromaticPosition);
    }

    pub fn fromOffset(pitch: Pitch, pos: i8) Note {
        const diatonicPosition = pitch.position();
        const accidentalOffset = @mod(pos - diatonicPosition, 12);
        return Note{
            .pitch = pitch,
            .accidental = switch (accidentalOffset) {
                0 => Accidental.Natural,
                1 => Accidental.Sharp,
                -1, 11 => Accidental.Flat,
                2 => Accidental.DoubleSharp,
                -2, 10 => Accidental.DoubleFlat,
                else => Accidental.Natural, // shouldn't happen?
            },
        };
    }

    pub fn name(self: Note) []const u8 {
        return std.fmt.allocPrint(std.heap.page_allocator, "{s}{s}", .{
            self.pitch.name(), self.accidental.name(),
        }) catch return "<Error>";
    }
};
