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

pub const Note = struct {
    name: Alphabet,
    accidental: Accidental,

    pub fn new(name: Alphabet, accidental: Accidental) Note {
        return Note{ .name = name, .accidental = accidental };
    }

    pub fn next(self: Note) Note {
        return Note{ .name = self.name.next(), .accidental = self.accidental };
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

    pub fn newFromStep(self: Note, step: u8) Note {
        const expected = self.name.position();
        var accidental: Accidental = .Natural;
        if (step == expected) {
            accidental = .Natural;
        } else if (step == (expected + 1) % 12) {
            accidental = .Sharp;
        } else if (step == (expected + 11) % 12) {
            accidental = .Flat;
        } else if (step == (expected + 2) % 12) {
            accidental = .DoubleSharp;
        } else if (step == (expected + 10) % 12) {
            accidental = .DoubleFlat;
        }
        return Note{ .name = self.name, .accidental = accidental };
    }
};

pub const Scale = struct {
    root: Note,
    steps: []const u8,

    pub fn new(root: Note, steps: []const u8) Scale {
        return Scale{ .root = root, .steps = steps };
    }

    pub fn compute(self: Scale, notes: []Note) []Note {
        var position: usize = 0;
        notes[position] = self.root;
        position += 1;
        var note = self.root;
        var stepPosition = note.position();

        for (self.steps) |step| {
            stepPosition = (stepPosition + step) % 12;
            note = note.next().newFromStep(stepPosition);
            notes[position] = note;
            position += 1;
        }
        return notes[0..position];
    }
};

pub const SharedMode = enum {
    Chromatic,
    WholeTone,

    pub fn steps(self: SharedMode) []const u8 {
        return switch (self) {
            .Chromatic => &[_]u8{ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
            .WholeTone => &[_]u8{ 2, 2, 2, 2, 2, 2 },
        };
    }
};

pub const MajorMode = enum {
    Ionian, // Standard major scale.
    Lydian, // Raised 4th degree, dreamy sound.
    Mixolydian, // Lowered 7th degree, dominant feel.
    Pentatonic, // Five notes, widely used in rock, blues, and folk.
    Blues, // Pentatonic variation with a "blue note", widely used in blues and jazz.
    Chromatic, // Twelve notes, no tonal center.
    WholeTone, // Six whole steps, ambiguous, dreamy.
    Harmonic, // Augmented second interval, widly used in classical and Middle Eastern music.

    pub fn steps(self: MajorMode) []const u8 {
        return switch (self) {
            .Ionian => &[_]u8{ 2, 2, 1, 2, 2, 2, 1 },
            .Lydian => &[_]u8{ 2, 2, 2, 1, 2, 2, 1 },
            .Mixolydian => &[_]u8{ 2, 2, 1, 2, 2, 1, 2 },
            .Pentatonic => &[_]u8{ 2, 2, 3, 2, 3 },
            .Blues => &[_]u8{ 2, 1, 1, 3, 2, 3 },
            .Chromatic => SharedMode.Chromatic.steps(),
            .WholeTone => SharedMode.WholeTone.steps(),
            .Harmonic => &[_]u8{ 2, 1, 2, 2, 1, 3, 1 },
        };
    }

    pub fn toString(self: MajorMode) []const u8 {
        return @tagName(self);
    }
};

pub const MinorMode = enum {
    Aeolian, // Standard minor scale.
    Dorian, // Raised 6th degree, used in jazz and modal music.
    Phrygian, // Lowered 2nd degree, Spanish or Eastern sound.
    Locrian, // Lowered 2nd and 5th, dissonant, used in jazz and modern metal.
    Pentatonic, // Omits 2nd and 6th degrees. Widely used in blues, rock, and folk music.
    Blues, // Pentatonic variation with a "blue note", widely used in blues and jazz.
    Chromatic, // Twelve notes, no tonal center.
    WholeTone, // Six whole steps, ambiguous, dreamy.
    Harmonic, // Raised 7th degree, classical, or "Middle Eastern" character
    Melodic, // Raised 6th and 7th when ascending, often reverts to natural minor (Aeolian) when descending. Jazz and classical music.

    pub fn steps(self: MinorMode) []const u8 {
        return switch (self) {
            .Aeolian => &[_]u8{ 2, 1, 2, 2, 1, 2, 2 },
            .Dorian => &[_]u8{ 2, 1, 2, 2, 2, 1, 2 },
            .Phrygian => &[_]u8{ 1, 2, 2, 2, 1, 2, 2 },
            .Locrian => &[_]u8{ 1, 2, 2, 1, 2, 2, 2 },
            .Pentatonic => &[_]u8{ 3, 2, 2, 3, 2 },
            .Blues => &[_]u8{ 3, 2, 1, 1, 3, 2 },
            .Chromatic => SharedMode.Chromatic.steps(),
            .WholeTone => SharedMode.WholeTone.steps(),
            .Harmonic => &[_]u8{ 2, 1, 2, 2, 1, 3, 1 },
            .Melodic => &[_]u8{ 2, 1, 2, 2, 2, 2, 1 },
        };
    }

    pub fn toString(self: MinorMode) []const u8 {
        return @tagName(self);
    }
};

pub fn main() !void {
    var buffer: [16]Note = undefined;
    const key = Note.new(Alphabet.E, Accidental.Flat);
    const mode = MajorMode.Ionian;
    const scale = Scale.new(key, mode.steps());
    std.debug.print("Major {s}{s} {s}: ", .{ key.name.toString(), key.accidental.toString(), mode.toString() });
    for (scale.compute(&buffer)) |note| {
        std.debug.print("{s}{s} ", .{ note.name.toString(), note.accidental.toString() });
    }
    std.debug.print("\n", .{});
}
