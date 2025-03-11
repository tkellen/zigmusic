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
        var notePosition = note.position();

        for (self.steps) |step| {
            notePosition = (notePosition + step) % 12;
            note = note.next().newFromStep(notePosition);
            notes[position] = note;
            position += 1;
        }
        return notes[0..position];
    }
};

pub const Mode = enum {
    IonianMajor, // Standard major scale.
    LydianMajor, // Raised 4th degree, dreamy sound.
    MixolydianMajor, // Lowered 7th degree, dominant feel.
    PentatonicMajor, // Five notes, widely used in rock, blues, and folk.
    BluesMajor, // Pentatonic variation with a "blue note", widely used in blues and jazz.
    HarmonicMajor, // Augmented second interval, widly used in classical and Middle Eastern music.
    AeolianMinor, // Standard minor scale.
    DorianMinor, // Raised 6th degree, used in jazz and modal music.
    PhrygianMinor, // Lowered 2nd degree, Spanish or Eastern sound.
    LocrianMinor, // Lowered 2nd and 5th, dissonant, used in jazz and modern metal.
    PentatonicMinor, // Omits 2nd and 6th degrees. Widely used in blues, rock, and folk music.
    BluesMinor, // Pentatonic variation with a "blue note", widely used in blues and jazz.
    HarmonicMinor, // Raised 7th degree, classical, or "Middle Eastern" character
    MelodicMinor, // Raised 6th and 7th when ascending, often reverts to natural minor (Aeolian) when descending. Jazz and classical music.
    Chromatic,
    WholeTone,

    pub fn steps(self: Mode) []const u8 {
        return switch (self) {
            .IonianMajor => &[_]u8{ 2, 2, 1, 2, 2, 2, 1 },
            .LydianMajor => &[_]u8{ 2, 2, 2, 1, 2, 2, 1 },
            .MixolydianMajor => &[_]u8{ 2, 2, 1, 2, 2, 1, 2 },
            .PentatonicMajor => &[_]u8{ 2, 2, 3, 2, 3 },
            .BluesMajor => &[_]u8{ 2, 1, 1, 3, 2, 3 },
            .HarmonicMajor => &[_]u8{ 2, 1, 2, 2, 1, 3, 1 },
            .AeolianMinor => &[_]u8{ 2, 1, 2, 2, 1, 2, 2 },
            .DorianMinor => &[_]u8{ 2, 1, 2, 2, 2, 1, 2 },
            .PhrygianMinor => &[_]u8{ 1, 2, 2, 2, 1, 2, 2 },
            .LocrianMinor => &[_]u8{ 1, 2, 2, 1, 2, 2, 2 },
            .PentatonicMinor => &[_]u8{ 3, 2, 2, 3, 2 },
            .BluesMinor => &[_]u8{ 3, 2, 1, 1, 3, 2 },
            .HarmonicMinor => &[_]u8{ 2, 1, 2, 2, 1, 3, 1 },
            .MelodicMinor => &[_]u8{ 2, 1, 2, 2, 2, 2, 1 },
            .Chromatic => &[_]u8{ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
            .WholeTone => &[_]u8{ 2, 2, 2, 2, 2, 2 },
        };
    }

    pub fn toString(self: Mode) []const u8 {
        return @tagName(self);
    }
};

pub fn main() !void {
    var buffer: [16]Note = undefined;
    const key = Note.new(Alphabet.E, Accidental.Flat);
    const mode = Mode.IonianMajor;
    const scale = Scale.new(key, mode.steps());
    std.debug.print("Major {s}{s} {s}: ", .{ key.name.toString(), key.accidental.toString(), mode.toString() });
    for (scale.compute(&buffer)) |note| {
        std.debug.print("{s}{s} ", .{ note.name.toString(), note.accidental.toString() });
    }
    std.debug.print("\n", .{});
}
