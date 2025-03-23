const std = @import("std");
const testing = std.testing;

const music = @import("./index.zig");
const Letter = music.note.Letter;
const Accidental = music.note.Accidental;
const Note = music.note.Note;
const Printer = music.printer.Printer;

test "Letter.fifthsFromC" {
    try std.testing.expectEqual(@as(i8, 0), Letter.C.fifthsFromC());
    try std.testing.expectEqual(@as(i8, 1), Letter.G.fifthsFromC());
    try std.testing.expectEqual(@as(i8, 2), Letter.D.fifthsFromC());
    try std.testing.expectEqual(@as(i8, 3), Letter.A.fifthsFromC());
    try std.testing.expectEqual(@as(i8, 4), Letter.E.fifthsFromC());
    try std.testing.expectEqual(@as(i8, 5), Letter.B.fifthsFromC());
    try std.testing.expectEqual(@as(i8, -1), Letter.F.fifthsFromC());
}

test "Accidental.parse" {
    const cases = [_]struct {
        input: []const u8,
        expected: ?Accidental,
    }{
        .{ .input = "♭", .expected = .Flat },
        .{ .input = "b", .expected = .Flat },
        .{ .input = "♭♭", .expected = .DoubleFlat },
        .{ .input = "bb", .expected = .DoubleFlat },
        .{ .input = "𝄫", .expected = .DoubleFlat },
        .{ .input = "♯", .expected = .Sharp },
        .{ .input = "#", .expected = .Sharp },
        .{ .input = "♯♯", .expected = .DoubleSharp },
        .{ .input = "##", .expected = .DoubleSharp },
        .{ .input = "𝄪", .expected = .DoubleSharp },
        .{ .input = "x", .expected = .DoubleSharp },
        .{ .input = "♮", .expected = .Natural },
        .{ .input = "", .expected = .Natural },
        .{ .input = "♯𝄫", .expected = null },
        .{ .input = "y", .expected = null },
    };
    for (cases) |case| {
        const result = Accidental.parse(case.input);
        try std.testing.expectEqual(result, case.expected);
    }
}

test "Note.fifthsFromC" {
    const cases = [_]struct {
        note: []const u8,
        expected: i8,
    }{
        // C
        .{ .note = "C𝄫", .expected = -2 },
        .{ .note = "C♭", .expected = -1 },
        .{ .note = "C", .expected = 0 },
        .{ .note = "C♯", .expected = 1 },
        .{ .note = "C𝄪", .expected = 2 },

        // D
        .{ .note = "D𝄫", .expected = 0 },
        .{ .note = "D♭", .expected = 1 },
        .{ .note = "D", .expected = 2 },
        .{ .note = "D♯", .expected = 3 },
        .{ .note = "D𝄪", .expected = 4 },

        // E
        .{ .note = "E𝄫", .expected = 2 },
        .{ .note = "E♭", .expected = 3 },
        .{ .note = "E", .expected = 4 },
        .{ .note = "E♯", .expected = 5 },
        .{ .note = "E𝄪", .expected = 6 },

        // F
        .{ .note = "F𝄫", .expected = -3 },
        .{ .note = "F♭", .expected = -2 },
        .{ .note = "F", .expected = -1 },
        .{ .note = "F♯", .expected = 0 },
        .{ .note = "F𝄪", .expected = 1 },

        // G
        .{ .note = "G𝄫", .expected = -1 },
        .{ .note = "G♭", .expected = 0 },
        .{ .note = "G", .expected = 1 },
        .{ .note = "G♯", .expected = 2 },
        .{ .note = "G𝄪", .expected = 3 },

        // A
        .{ .note = "A𝄫", .expected = 1 },
        .{ .note = "A♭", .expected = 2 },
        .{ .note = "A", .expected = 3 },
        .{ .note = "A♯", .expected = 4 },
        .{ .note = "A𝄪", .expected = 5 },

        // B
        .{ .note = "B𝄫", .expected = 3 },
        .{ .note = "B♭", .expected = 4 },
        .{ .note = "B", .expected = 5 },
        .{ .note = "B♯", .expected = 6 },
        .{ .note = "B𝄪", .expected = 7 },
    };

    for (cases) |case| {
        const note = try Note.parse(case.note);
        try std.testing.expectEqual(case.expected, note.fifthsFromC());
    }
}

test "Note.enharmonics" {
    for ([_]struct {
        note: []const u8,
        expected: []const u8,
    }{
        .{ .note = "A", .expected = "G𝄪 A B𝄫" },
        .{ .note = "A♭", .expected = "G♯ A♭" },
        .{ .note = "A♯", .expected = "C𝄫 A♯ B♭" },
        .{ .note = "A𝄪", .expected = "C♭ A𝄪 B" },
        .{ .note = "A𝄫", .expected = "F𝄪 G A𝄫" },
        .{ .note = "B", .expected = "C♭ A𝄪 B" },
        .{ .note = "B♭", .expected = "C𝄫 A♯ B♭" },
        .{ .note = "B♯", .expected = "C D𝄫 B♯" },
        .{ .note = "B𝄪", .expected = "C♯ D♭ B𝄪" },
        .{ .note = "B𝄫", .expected = "G𝄪 A B𝄫" },
        .{ .note = "C", .expected = "C D𝄫 B♯" },
        .{ .note = "C♭", .expected = "C♭ A𝄪 B" },
        .{ .note = "C♯", .expected = "C♯ D♭ B𝄪" },
        .{ .note = "C𝄪", .expected = "C𝄪 D E𝄫" },
        .{ .note = "C𝄫", .expected = "C𝄫 A♯ B♭" },
        .{ .note = "D", .expected = "C𝄪 D E𝄫" },
        .{ .note = "D♭", .expected = "C♯ D♭ B𝄪" },
        .{ .note = "D♯", .expected = "D♯ E♭ F𝄫" },
        .{ .note = "D𝄪", .expected = "D𝄪 E F♭" },
        .{ .note = "D𝄫", .expected = "C D𝄫 B♯" },
        .{ .note = "E", .expected = "D𝄪 E F♭" },
        .{ .note = "E♭", .expected = "D♯ E♭ F𝄫" },
        .{ .note = "E♯", .expected = "E♯ F G𝄫" },
        .{ .note = "E𝄪", .expected = "E𝄪 F♯ G♭" },
        .{ .note = "E𝄫", .expected = "C𝄪 D E𝄫" },
        .{ .note = "F", .expected = "E♯ F G𝄫" },
        .{ .note = "F♭", .expected = "D𝄪 E F♭" },
        .{ .note = "F♯", .expected = "E𝄪 F♯ G♭" },
        .{ .note = "F𝄪", .expected = "F𝄪 G A𝄫" },
        .{ .note = "F𝄫", .expected = "D♯ E♭ F𝄫" },
        .{ .note = "G", .expected = "F𝄪 G A𝄫" },
        .{ .note = "G♭", .expected = "E𝄪 F♯ G♭" },
        .{ .note = "G♯", .expected = "G♯ A♭" },
        .{ .note = "G𝄪", .expected = "G𝄪 A B𝄫" },
        .{ .note = "G𝄫", .expected = "E♯ F G𝄫" },
    }) |case| {
        const note = try Note.parse(case.note);
        const equivalents = try note.enharmonics(std.testing.allocator);
        defer std.testing.allocator.free(equivalents);
        var printer = try Printer.init(std.testing.allocator, equivalents);
        defer printer.deinit(std.testing.allocator);
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "Note.chromaticPosition" {
    for ([_]struct { Letter, Accidental, u8 }{
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
