// All of this assumes western music theory where there are 12 notes.

const std = @import("std");

pub const Alphabet = enum(u8) {
    C,
    D,
    E,
    F,
    G,
    A,
    B,

    pub fn next(self: Alphabet) Alphabet {
        return @enumFromInt(((@intFromEnum(self) + 1) % 7));
    }

    pub fn position(self: Alphabet) u8 {
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

    pub fn toString(self: Alphabet) []const u8 {
        return @tagName(self);
    }
};

pub const Accidental = enum {
    Natural,
    Sharp,
    Flat,
    DoubleSharp,
    DoubleFlat,

    pub fn toString(self: Accidental) []const u8 {
        return switch (self) {
            .Natural => "",
            .Sharp => "♯",
            .Flat => "♭",
            .DoubleSharp => "𝄪",
            .DoubleFlat => "𝄫",
        };
    }
};

pub const Step = enum(u8) {
    Half,
    Whole,
    Second,
    Augmented_Second,
    Third,
    Fourth,
    Fifth,
    Sixth,
    Seventh,
    Octave,

    pub fn value(self: Step) u8 {
        return switch (self) {
            .Half => 1,
            .Whole => 2,
            .Second => 2,
            .Augmented_Second => 3,
            .Third => 3,
            .Fourth => 5,
            .Fifth => 7,
            .Sixth => 9,
            .Seventh => 11,
            .Octave => 12,
        };
    }
};

pub const Note = struct {
    name: Alphabet,
    accidental: Accidental,

    pub fn new(name: Alphabet, accidental: Accidental) Note {
        return Note{ .name = name, .accidental = accidental };
    }

    pub fn position(self: Note) u8 {
        return switch (self.accidental) {
            .Natural => self.name.position(),
            .Sharp => (self.name.position() + 1) % 12,
            .Flat => (self.name.position() + 11) % 12,
            .DoubleSharp => (self.name.position() + 2) % 12,
            .DoubleFlat => (self.name.position() + 10) % 12,
        };
    }

    pub fn stepTo(self: Note, step: Step) Note {
        const targetPosition: i8 = @intCast((self.position() + step.value()) % 12);
        const nextNatural = self.name.next();
        const nextNaturalPosition: i8 = @intCast(nextNatural.position());
        const diff: i8 = @mod(targetPosition - nextNaturalPosition + 12, 12);
        return Note{
            .name = nextNatural,
            .accidental = switch (diff) {
                0 => .Natural,
                1 => .Sharp,
                2 => .DoubleSharp,
                10 => .DoubleFlat,
                11 => .Flat,
                else => .Natural,
            },
        };
    }
};

pub const Mode = enum {
    Ionian_Major, // Standard major scale.
    Aeolian_Minor, // Standard minor scale.
    Lydian_Major, // Raised 4th degree, dreamy sound.
    Mixolydian_Major, // Lowered 7th degree, dominant feel.
    Pentatonic_Major, // Five notes, widely used in rock, blues, and folk.
    Blues_Major, // Pentatonic variation with a "blue note", widely used in blues and jazz.
    Harmonic_Major, // Augmented second interval, widly used in classical and Middle Eastern music.
    Dorian_Minor, // Raised 6th degree, used in jazz and modal music.
    Phrygian_Minor, // Lowered 2nd degree, Spanish or Eastern sound.
    Locrian_Minor, // Lowered 2nd and 5th, dissonant, used in jazz and modern metal.
    Pentatonic_Minor, // Omits 2nd and 6th degrees. Widely used in blues, rock, and folk music.
    Blues_Minor, // Pentatonic variation with a "blue note", widely used in blues and jazz.
    Harmonic_Minor, // Raised 7th degree, classical, or "Middle Eastern" character
    Melodic_Minor, // Raised 6th and 7th when ascending, often reverts to natural _minor (Aeolian) when descending. Jazz and classical music.
    Chromatic,
    WholeTone,

    pub fn intervals(self: Mode) []const Step {
        return switch (self) {
            .Ionian_Major => &[_]Step{ .Whole, .Whole, .Half, .Whole, .Whole, .Whole, .Half },
            .Lydian_Major => &[_]Step{ .Whole, .Whole, .Whole, .Half, .Whole, .Whole, .Half },
            .Mixolydian_Major => &[_]Step{ .Whole, .Whole, .Half, .Whole, .Whole, .Half, .Whole },
            .Pentatonic_Major => &[_]Step{ .Whole, .Whole, .Third, .Whole, .Third },
            .Blues_Major => &[_]Step{ .Whole, .Half, .Half, .Third, .Whole, .Third },
            .Harmonic_Major => &[_]Step{ .Whole, .Half, .Whole, .Whole, .Half, .Third, .Half },
            .Aeolian_Minor => &[_]Step{ .Whole, .Half, .Whole, .Whole, .Half, .Whole, .Whole },
            .Dorian_Minor => &[_]Step{ .Whole, .Half, .Whole, .Whole, .Whole, .Half, .Whole },
            .Phrygian_Minor => &[_]Step{ .Half, .Whole, .Whole, .Whole, .Half, .Whole, .Whole },
            .Locrian_Minor => &[_]Step{ .Half, .Whole, .Whole, .Half, .Whole, .Whole, .Whole },
            .Pentatonic_Minor => &[_]Step{ .Third, .Whole, .Whole, .Third, .Whole },
            .Blues_Minor => &[_]Step{ .Third, .Whole, .Half, .Half, .Third, .Whole },
            .Harmonic_Minor => &[_]Step{ .Whole, .Half, .Whole, .Whole, .Half, .Augmented_Second, .Half },
            .Melodic_Minor => &[_]Step{ .Whole, .Half, .Whole, .Whole, .Whole, .Whole, .Half },
            .Chromatic => &[_]Step{ .Half, .Half, .Half, .Half, .Half, .Half, .Half, .Half, .Half, .Half, .Half, .Half },
            .WholeTone => &[_]Step{ .Whole, .Whole, .Whole, .Whole, .Whole, .Whole },
        };
    }

    pub fn scale(self: Mode, root: Note, notes: []Note) []Note {
        var position: usize = 0;
        notes[position] = root;
        position += 1;

        var note = root;
        for (self.intervals()) |step| {
            note = note.stepTo(step);
            notes[position] = note;
            position += 1;
        }

        return notes[0..position];
    }

    pub fn toString(self: Mode) []const u8 {
        return @tagName(self);
    }
};

pub const Chord = struct {
    key: Note,
    mode: Mode,

    pub fn build(self: Chord, startPosition: u8, notes: []Note) [3]Note {
        const scale = self.mode.scale(self.key, notes);
        return .{
            scale[startPosition % scale.len],
            scale[(startPosition + 2) % (scale.len - 1)], // Wrap within the first 7 notes
            scale[(startPosition + 4) % (scale.len - 1)],
        };
    }
};

pub fn main() !void {
    var buffer: [16]Note = undefined;
    const key = Note.new(Alphabet.F, Accidental.Sharp);
    const mode = Mode.Harmonic_Minor;
    const scale = mode.scale(key, &buffer);
    std.debug.print("{s}{s} {s}: ", .{ key.name.toString(), key.accidental.toString(), mode.toString() });
    for (scale) |note| {
        std.debug.print("{s}{s} ", .{ note.name.toString(), note.accidental.toString() });
    }
    std.debug.print("\n", .{});
    const chord = Chord{ .mode = mode, .key = key };
    const chordNotes = chord.build(1, &buffer);
    for (chordNotes) |note| {
        std.debug.print("{s}{s} ", .{ note.name.toString(), note.accidental.toString() });
    }
    std.debug.print("\n", .{});
}
