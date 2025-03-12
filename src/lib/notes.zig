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

    pub fn next(self: Pitch) Pitch {
        return @enumFromInt(((@intFromEnum(self) + 1) % 7));
    }

    pub fn position(self: Pitch) u8 {
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

    pub fn chromaticPosition(self: Note) u8 {
        const pos: i8 = @as(i8, @intCast(self.pitch.position())) + self.accidental.offset();
        return @as(u8, @intCast(@mod(pos, 12))); // Use @mod instead of %
    }

    pub fn stepBy(self: Note, movement: steps.Step) Note {
        // Compute the new chromatic position by adding the movement value to the current chromatic position
        // and taking the result modulo 12 to ensure it wraps around within the 12-tone chromatic scale.
        const newChromaticPosition: u8 = @as(u8, @intCast(@mod(@as(i8, @intCast(self.chromaticPosition())) + @as(i8, @intCast(movement.value())), 12)));

        // Determine the next diatonic pitch by moving up in the natural (diatonic) scale.
        // This helps preserve the correct letter name of the note in a musical context.
        // TODO: This will fail for large steps and needs refactoring.
        const nextDiatonic = self.pitch.next();

        // Get the chromatic position of the next diatonic note to compare it with the new chromatic position.
        const nextDiatonicPosition: u8 = nextDiatonic.position();

        // Compute the difference (offset) between the new chromatic position and the expected diatonic position.
        // This value determines whether an accidental needs to be applied (e.g., sharp, flat).
        const diff: i8 = @mod(@as(i8, @intCast(newChromaticPosition)) - @as(i8, @intCast(nextDiatonicPosition)), 12);

        // Determine the appropriate accidental based on the difference.
        return Note{
            .pitch = nextDiatonic,
            .accidental = switch (diff) {
                0 => .Natural, // No accidental needed, pitch matches exactly
                1 => .Sharp, // One semitone above, needs a sharp.
                2 => .DoubleSharp, // Two semitones above, needs a double sharp.
                10 => .DoubleFlat, // Two semitones below, needs a double flat (equivalent to -2 mod 12).
                11 => .Flat, // One semitone below, needs a flat (equivalent to -1 mod 12).
                else => .Natural, // Default case, assumes natural note (shouldn't happen)
            },
        };
    }

    pub fn name(self: Note) []const u8 {
        return std.fmt.allocPrint(std.heap.page_allocator, "{s}{s}", .{
            @tagName(self.pitch), self.accidental.name(),
        }) catch return "<Error>";
    }
};
