const std = @import("std");
const testing = std.testing;

const music = @import("./index.zig");
const Letter = music.notes.Letter;
const Accidental = music.notes.Accidental;
const Note = music.notes.Note;

test "note.chromaticPosition" {
    for ([_]struct { Letter, Accidental, i8 }{
        .{ Letter.C, Accidental.Natural, 0 },
        .{ Letter.C, Accidental.Sharp, 1 },
        .{ Letter.C, Accidental.Flat, 11 },
        .{ Letter.C, Accidental.DoubleSharp, 2 },
        .{ Letter.C, Accidental.DoubleFlat, 10 },

        .{ Letter.D, Accidental.Natural, 2 },
        .{ Letter.D, Accidental.Sharp, 3 },
        .{ Letter.D, Accidental.Flat, 1 },
        .{ Letter.D, Accidental.DoubleSharp, 4 },
        .{ Letter.D, Accidental.DoubleFlat, 0 },

        .{ Letter.E, Accidental.Natural, 4 },
        .{ Letter.E, Accidental.Sharp, 5 },
        .{ Letter.E, Accidental.Flat, 3 },
        .{ Letter.E, Accidental.DoubleSharp, 6 },
        .{ Letter.E, Accidental.DoubleFlat, 2 },

        .{ Letter.F, Accidental.Natural, 5 },
        .{ Letter.F, Accidental.Sharp, 6 },
        .{ Letter.F, Accidental.Flat, 4 },
        .{ Letter.F, Accidental.DoubleSharp, 7 },
        .{ Letter.F, Accidental.DoubleFlat, 3 },

        .{ Letter.G, Accidental.Natural, 7 },
        .{ Letter.G, Accidental.Sharp, 8 },
        .{ Letter.G, Accidental.Flat, 6 },
        .{ Letter.G, Accidental.DoubleSharp, 9 },
        .{ Letter.G, Accidental.DoubleFlat, 5 },

        .{ Letter.A, Accidental.Natural, 9 },
        .{ Letter.A, Accidental.Sharp, 10 },
        .{ Letter.A, Accidental.Flat, 8 },
        .{ Letter.A, Accidental.DoubleSharp, 11 },
        .{ Letter.A, Accidental.DoubleFlat, 7 },

        .{ Letter.B, Accidental.Natural, 11 },
        .{ Letter.B, Accidental.Sharp, 0 },
        .{ Letter.B, Accidental.Flat, 10 },
        .{ Letter.B, Accidental.DoubleSharp, 1 },
        .{ Letter.B, Accidental.DoubleFlat, 9 },
    }) |case| {
        const note = Note{
            .natural = case[0],
            .accidental = case[1],
        };
        try testing.expectEqual(case[2], note.chromaticPosition());
    }
}
