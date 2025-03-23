const std = @import("std");
const music = @import("./index.zig");

const Note = music.note.Note;
const Mode = music.scale.Mode;
const Chromatic = music.scale.Chromatic;
const WholeTone = music.scale.WholeTone;
const Step = music.scale.Step;
const Printer = music.printer.Printer;

// test data from: https://everythingmusic.com/learn/music-theory/scales
test "Ionian (Major)" {
    for ([_]struct {
        root: []const u8,
        expected: []const u8,
    }{
        .{ .root = "C♭", .expected = "C♭ D♭ E♭ F♭ G♭ A♭ B♭ C♭" },
        .{ .root = "C", .expected = "C D E F G A B C" },
        .{ .root = "C♯", .expected = "C♯ D♯ E♯ F♯ G♯ A♯ B♯ C♯" },
        .{ .root = "D♭", .expected = "D♭ E♭ F G♭ A♭ B♭ C D♭" },
        .{ .root = "D", .expected = "D E F♯ G A B C♯ D" },
        .{ .root = "D♯", .expected = "D♯ E♯ F𝄪 G♯ A♯ B♯ C𝄪 D♯" },
        .{ .root = "E♭", .expected = "E♭ F G A♭ B♭ C D E♭" },
        .{ .root = "E", .expected = "E F♯ G♯ A B C♯ D♯ E" },
        .{ .root = "E♯", .expected = "E♯ F𝄪 G𝄪 A♯ B♯ C𝄪 D𝄪 E♯" },
        .{ .root = "F♭", .expected = "F♭ G♭ A♭ B𝄫 C♭ D♭ E♭ F♭" },
        .{ .root = "F", .expected = "F G A B♭ C D E F" },
        .{ .root = "F♯", .expected = "F♯ G♯ A♯ B C♯ D♯ E♯ F♯" },
        .{ .root = "G♭", .expected = "G♭ A♭ B♭ C♭ D♭ E♭ F G♭" },
        .{ .root = "G", .expected = "G A B C D E F♯ G" },
        .{ .root = "G♯", .expected = "G♯ A♯ B♯ C♯ D♯ E♯ F𝄪 G♯" },
        .{ .root = "A♭", .expected = "A♭ B♭ C D♭ E♭ F G A♭" },
        .{ .root = "A", .expected = "A B C♯ D E F♯ G♯ A" },
        .{ .root = "A♯", .expected = "A♯ B♯ C𝄪 D♯ E♯ F𝄪 G𝄪 A♯" },
        .{ .root = "B♭", .expected = "B♭ C D E♭ F G A B♭" },
        .{ .root = "B", .expected = "B C♯ D♯ E F♯ G♯ A♯ B" },
        .{ .root = "B♯", .expected = "B♯ C𝄪 D𝄪 E♯ F𝄪 G𝄪 A𝄪 B♯" },
    }) |case| {
        const notes = Mode.Ionian.scale(try Note.parse(case.root));
        var printer = try Printer.init(std.testing.allocator, &notes);
        defer printer.deinit(std.testing.allocator);
        //std.debug.print("{s}{s} | got: {s} expected: {s}\n", .{ root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "Dorian" {
    for ([_]struct {
        root: []const u8,
        expected: []const u8,
    }{
        .{ .root = "C♭", .expected = "C♭ D♭ E𝄫 F♭ G♭ A♭ B𝄫 C♭" },
        .{ .root = "C", .expected = "C D E♭ F G A B♭ C" },
        .{ .root = "C♯", .expected = "C♯ D♯ E F♯ G♯ A♯ B C♯" },
        .{ .root = "D♭", .expected = "D♭ E♭ F♭ G♭ A♭ B♭ C♭ D♭" },
        .{ .root = "D", .expected = "D E F G A B C D" },
        .{ .root = "D♯", .expected = "D♯ E♯ F♯ G♯ A♯ B♯ C♯ D♯" },
        .{ .root = "E♭", .expected = "E♭ F G♭ A♭ B♭ C D♭ E♭" },
        .{ .root = "E", .expected = "E F♯ G A B C♯ D E" },
        .{ .root = "E♯", .expected = "E♯ F𝄪 G♯ A♯ B♯ C𝄪 D♯ E♯" },
        .{ .root = "F♭", .expected = "F♭ G♭ A𝄫 B𝄫 C♭ D♭ E𝄫 F♭" },
        .{ .root = "F", .expected = "F G A♭ B♭ C D E♭ F" },
        .{ .root = "G♭", .expected = "G♭ A♭ B𝄫 C♭ D♭ E♭ F♭ G♭" },
        .{ .root = "G", .expected = "G A B♭ C D E F G" },
        .{ .root = "G♯", .expected = "G♯ A♯ B C♯ D♯ E♯ F♯ G♯" },
        .{ .root = "A♭", .expected = "A♭ B♭ C♭ D♭ E♭ F G♭ A♭" },
        .{ .root = "A", .expected = "A B C D E F♯ G A" },
        .{ .root = "A♯", .expected = "A♯ B♯ C♯ D♯ E♯ F𝄪 G♯ A♯" },
        .{ .root = "B♭", .expected = "B♭ C D♭ E♭ F G A♭ B♭" },
        .{ .root = "B", .expected = "B C♯ D E F♯ G♯ A B" },
        .{ .root = "B♯", .expected = "B♯ C𝄪 D♯ E♯ F𝄪 G𝄪 A♯ B♯" },
    }) |case| {
        const notes = Mode.Dorian.scale(try Note.parse(case.root));
        var printer = try Printer.init(std.testing.allocator, &notes);
        defer printer.deinit(std.testing.allocator);
        //std.debug.print("{s}{s} | got: {s} expected: {s}\n", .{ root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "Phrygian" {
    for ([_]struct {
        root: []const u8,
        expected: []const u8,
    }{
        .{ .root = "C♭", .expected = "C♭ D𝄫 E𝄫 F♭ G♭ A𝄫 B𝄫 C♭" },
        .{ .root = "C", .expected = "C D♭ E♭ F G A♭ B♭ C" },
        .{ .root = "C♯", .expected = "C♯ D E F♯ G♯ A B C♯" },
        .{ .root = "D♭", .expected = "D♭ E𝄫 F♭ G♭ A♭ B𝄫 C♭ D♭" },
        .{ .root = "D", .expected = "D E♭ F G A B♭ C D" },
        .{ .root = "D♯", .expected = "D♯ E F♯ G♯ A♯ B C♯ D♯" },
        .{ .root = "E♭", .expected = "E♭ F♭ G♭ A♭ B♭ C♭ D♭ E♭" },
        .{ .root = "E", .expected = "E F G A B C D E" },
        .{ .root = "E♯", .expected = "E♯ F♯ G♯ A♯ B♯ C♯ D♯ E♯" },
        .{ .root = "F♭", .expected = "F♭ G𝄫 A𝄫 B𝄫 C♭ D𝄫 E𝄫 F♭" },
        .{ .root = "F", .expected = "F G♭ A♭ B♭ C D♭ E♭ F" },
        .{ .root = "G♭", .expected = "G♭ A𝄫 B𝄫 C♭ D♭ E𝄫 F♭ G♭" },
        .{ .root = "G", .expected = "G A♭ B♭ C D E♭ F G" },
        .{ .root = "G♯", .expected = "G♯ A B C♯ D♯ E F♯ G♯" },
        .{ .root = "A♭", .expected = "A♭ B𝄫 C♭ D♭ E♭ F♭ G♭ A♭" },
        .{ .root = "A", .expected = "A B♭ C D E F G A" },
        .{ .root = "A♯", .expected = "A♯ B C♯ D♯ E♯ F♯ G♯ A♯" },
        .{ .root = "B♭", .expected = "B♭ C♭ D♭ E♭ F G♭ A♭ B♭" },
        .{ .root = "B", .expected = "B C D E F♯ G A B" },
        .{ .root = "B♯", .expected = "B♯ C♯ D♯ E♯ F𝄪 G♯ A♯ B♯" },
    }) |case| {
        const notes = Mode.Phrygian.scale(try Note.parse(case.root));
        var printer = try Printer.init(std.testing.allocator, &notes);
        defer printer.deinit(std.testing.allocator);
        //std.debug.print("{s}{s} | got: {s} expected: {s}\n", .{ root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "Lydian" {
    for ([_]struct {
        root: []const u8,
        expected: []const u8,
    }{
        .{ .root = "C♭", .expected = "C♭ D♭ E♭ F G♭ A♭ B♭ C♭" },
        .{ .root = "C", .expected = "C D E F♯ G A B C" },
        .{ .root = "C♯", .expected = "C♯ D♯ E♯ F𝄪 G♯ A♯ B♯ C♯" },
        .{ .root = "D♭", .expected = "D♭ E♭ F G A♭ B♭ C D♭" },
        .{ .root = "D", .expected = "D E F♯ G♯ A B C♯ D" },
        .{ .root = "D♯", .expected = "D♯ E♯ F𝄪 G𝄪 A♯ B♯ C𝄪 D♯" },
        .{ .root = "E♭", .expected = "E♭ F G A B♭ C D E♭" },
        .{ .root = "E", .expected = "E F♯ G♯ A♯ B C♯ D♯ E" },
        .{ .root = "E♯", .expected = "E♯ F𝄪 G𝄪 A𝄪 B♯ C𝄪 D𝄪 E♯" },
        .{ .root = "F♭", .expected = "F♭ G♭ A♭ B♭ C♭ D♭ E♭ F♭" },
        .{ .root = "F", .expected = "F G A B C D E F" },
        .{ .root = "G♭", .expected = "G♭ A♭ B♭ C D♭ E♭ F G♭" },
        .{ .root = "G", .expected = "G A B C♯ D E F♯ G" },
        .{ .root = "G♯", .expected = "G♯ A♯ B♯ C𝄪 D♯ E♯ F𝄪 G♯" },
        .{ .root = "A♭", .expected = "A♭ B♭ C D E♭ F G A♭" },
        .{ .root = "A", .expected = "A B C♯ D♯ E F♯ G♯ A" },
        .{ .root = "A♯", .expected = "A♯ B♯ C𝄪 D𝄪 E♯ F𝄪 G𝄪 A♯" },
        .{ .root = "B♭", .expected = "B♭ C D E F G A B♭" },
        .{ .root = "B", .expected = "B C♯ D♯ E♯ F♯ G♯ A♯ B" },
    }) |case| {
        const notes = Mode.Lydian.scale(try Note.parse(case.root));
        var printer = try Printer.init(std.testing.allocator, &notes);
        defer printer.deinit(std.testing.allocator);
        //std.debug.print("{s}{s} | got: {s} expected: {s}\n", .{ root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "Mixolydian" {
    for ([_]struct {
        root: []const u8,
        expected: []const u8,
    }{
        .{ .root = "C♭", .expected = "C♭ D♭ E♭ F♭ G♭ A♭ B𝄫 C♭" },
        .{ .root = "C", .expected = "C D E F G A B♭ C" },
        .{ .root = "C♯", .expected = "C♯ D♯ E♯ F♯ G♯ A♯ B C♯" },
        .{ .root = "D♭", .expected = "D♭ E♭ F G♭ A♭ B♭ C♭ D♭" },
        .{ .root = "D", .expected = "D E F♯ G A B C D" },
        .{ .root = "D♯", .expected = "D♯ E♯ F𝄪 G♯ A♯ B♯ C♯ D♯" },
        .{ .root = "E♭", .expected = "E♭ F G A♭ B♭ C D♭ E♭" },
        .{ .root = "E", .expected = "E F♯ G♯ A B C♯ D E" },
        .{ .root = "E♯", .expected = "E♯ F𝄪 G𝄪 A♯ B♯ C𝄪 D♯ E♯" },
        .{ .root = "F♭", .expected = "F♭ G♭ A♭ B𝄫 C♭ D♭ E𝄫 F♭" },
        .{ .root = "F", .expected = "F G A B♭ C D E♭ F" },
        .{ .root = "G♭", .expected = "G♭ A♭ B♭ C♭ D♭ E♭ F♭ G♭" },
        .{ .root = "G", .expected = "G A B C D E F G" },
        .{ .root = "G♯", .expected = "G♯ A♯ B♯ C♯ D♯ E♯ F♯ G♯" },
        .{ .root = "A♭", .expected = "A♭ B♭ C D♭ E♭ F G♭ A♭" },
        .{ .root = "A", .expected = "A B C♯ D E F♯ G A" },
        .{ .root = "A♯", .expected = "A♯ B♯ C𝄪 D♯ E♯ F𝄪 G♯ A♯" },
        .{ .root = "B♭", .expected = "B♭ C D E♭ F G A♭ B♭" },
        .{ .root = "B", .expected = "B C♯ D♯ E F♯ G♯ A B" },
    }) |case| {
        const notes = Mode.Mixolydian.scale(try Note.parse(case.root));
        var printer = try Printer.init(std.testing.allocator, &notes);
        defer printer.deinit(std.testing.allocator);
        //std.debug.print("{s}{s} | got: {s} expected: {s}\n", .{ root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "Aeolian (Minor)" {
    for ([_]struct {
        root: []const u8,
        expected: []const u8,
    }{
        .{ .root = "C♭", .expected = "C♭ D♭ E𝄫 F♭ G♭ A𝄫 B𝄫 C♭" },
        .{ .root = "C", .expected = "C D E♭ F G A♭ B♭ C" },
        .{ .root = "C♯", .expected = "C♯ D♯ E F♯ G♯ A B C♯" },
        .{ .root = "D♭", .expected = "D♭ E♭ F♭ G♭ A♭ B𝄫 C♭ D♭" },
        .{ .root = "D", .expected = "D E F G A B♭ C D" },
        .{ .root = "D♯", .expected = "D♯ E♯ F♯ G♯ A♯ B C♯ D♯" },
        .{ .root = "E♭", .expected = "E♭ F G♭ A♭ B♭ C♭ D♭ E♭" },
        .{ .root = "E", .expected = "E F♯ G A B C D E" },
        .{ .root = "E♯", .expected = "E♯ F𝄪 G♯ A♯ B♯ C♯ D♯ E♯" },
        .{ .root = "F♭", .expected = "F♭ G♭ A𝄫 B𝄫 C♭ D𝄫 E𝄫 F♭" },
        .{ .root = "F", .expected = "F G A♭ B♭ C D♭ E♭ F" },
        .{ .root = "G♭", .expected = "G♭ A♭ B𝄫 C♭ D♭ E𝄫 F♭ G♭" },
        .{ .root = "G", .expected = "G A B♭ C D E♭ F G" },
        .{ .root = "G♯", .expected = "G♯ A♯ B C♯ D♯ E F♯ G♯" },
        .{ .root = "A♭", .expected = "A♭ B♭ C♭ D♭ E♭ F♭ G♭ A♭" },
        .{ .root = "A", .expected = "A B C D E F G A" },
        .{ .root = "A♯", .expected = "A♯ B♯ C♯ D♯ E♯ F♯ G♯ A♯" },
        .{ .root = "B♭", .expected = "B♭ C D♭ E♭ F G♭ A♭ B♭" },
        .{ .root = "B", .expected = "B C♯ D E F♯ G A B" },
        .{ .root = "B♯", .expected = "B♯ C𝄪 D♯ E♯ F𝄪 G♯ A♯ B♯" },
    }) |case| {
        const notes = Mode.Aeolian.scale(try Note.parse(case.root));
        var printer = try Printer.init(std.testing.allocator, &notes);
        defer printer.deinit(std.testing.allocator);
        //std.debug.print("{s}{s} | got: {s} expected: {s}\n", .{ root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "Locrian" {
    for ([_]struct {
        root: []const u8,
        expected: []const u8,
    }{
        .{ .root = "C♭", .expected = "C♭ D𝄫 E𝄫 F♭ G𝄫 A𝄫 B𝄫 C♭" },
        .{ .root = "C", .expected = "C D♭ E♭ F G♭ A♭ B♭ C" },
        .{ .root = "C♯", .expected = "C♯ D E F♯ G A B C♯" },
        .{ .root = "D♭", .expected = "D♭ E𝄫 F♭ G♭ A𝄫 B𝄫 C♭ D♭" },
        .{ .root = "D", .expected = "D E♭ F G A♭ B♭ C D" },
        .{ .root = "D♯", .expected = "D♯ E F♯ G♯ A B C♯ D♯" },
        .{ .root = "E♭", .expected = "E♭ F♭ G♭ A♭ B𝄫 C♭ D♭ E♭" },
        .{ .root = "E", .expected = "E F G A B♭ C D E" },
        .{ .root = "E♯", .expected = "E♯ F♯ G♯ A♯ B C♯ D♯ E♯" },
        .{ .root = "F♭", .expected = "F♭ G𝄫 A𝄫 B𝄫 C𝄫 D𝄫 E𝄫 F♭" },
        .{ .root = "F", .expected = "F G♭ A♭ B♭ C♭ D♭ E♭ F" },
        .{ .root = "G♭", .expected = "G♭ A𝄫 B𝄫 C♭ D𝄫 E𝄫 F♭ G♭" },
        .{ .root = "G", .expected = "G A♭ B♭ C D♭ E♭ F G" },
        .{ .root = "G♯", .expected = "G♯ A B C♯ D E F♯ G♯" },
        .{ .root = "A♭", .expected = "A♭ B𝄫 C♭ D♭ E𝄫 F♭ G♭ A♭" },
        .{ .root = "A", .expected = "A B♭ C D E♭ F G A" },
        .{ .root = "A♯", .expected = "A♯ B C♯ D♯ E F♯ G♯ A♯" },
        .{ .root = "B♭", .expected = "B♭ C♭ D♭ E♭ F♭ G♭ A♭ B♭" },
        .{ .root = "B", .expected = "B C D E F G A B" },
    }) |case| {
        const notes = Mode.Locrian.scale(try Note.parse(case.root));
        var printer = try Printer.init(std.testing.allocator, &notes);
        defer printer.deinit(std.testing.allocator);
        //std.debug.print("{s}{s} | got: {s} expected: {s}\n", .{ root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "Harmonic Major" {
    for ([_]struct {
        root: []const u8,
        expected: []const u8,
    }{
        .{ .root = "C♭", .expected = "C♭ D♭ E♭ F♭ G♭ A𝄫 B♭ C♭" },
        .{ .root = "C", .expected = "C D E F G A♭ B C" },
        .{ .root = "C♯", .expected = "C♯ D♯ E♯ F♯ G♯ A B♯ C♯" },
        .{ .root = "D♭", .expected = "D♭ E♭ F G♭ A♭ B𝄫 C D♭" },
        .{ .root = "D", .expected = "D E F♯ G A B♭ C♯ D" },
        .{ .root = "E♭", .expected = "E♭ F G A♭ B♭ C♭ D E♭" },
        .{ .root = "E", .expected = "E F♯ G♯ A B C D♯ E" },
        .{ .root = "E♯", .expected = "E♯ F𝄪 G𝄪 A♯ B♯ C♯ D𝄪 E♯" },
        .{ .root = "F♭", .expected = "F♭ G♭ A♭ B𝄫 C♭ D𝄫 E♭ F♭" },
        .{ .root = "F", .expected = "F G A B♭ C D♭ E F" },
        .{ .root = "F♯", .expected = "F♯ G♯ A♯ B C♯ D E♯ F♯" },
        .{ .root = "G♭", .expected = "G♭ A♭ B♭ C♭ D♭ E𝄫 F G♭" },
        .{ .root = "G", .expected = "G A B C D E♭ F♯ G" },
        .{ .root = "A♭", .expected = "A♭ B♭ C D♭ E♭ F♭ G A♭" },
        .{ .root = "A", .expected = "A B C♯ D E F G♯ A" },
        .{ .root = "B♭", .expected = "B♭ C D E♭ F G♭ A B♭" },
        .{ .root = "B", .expected = "B C♯ D♯ E F♯ G A♯ B" },
    }) |case| {
        const notes = Mode.HarmonicMajor.scale(try Note.parse(case.root));
        var printer = try Printer.init(std.testing.allocator, &notes);
        defer printer.deinit(std.testing.allocator);
        //std.debug.print("{s}{s} | got: {s} expected: {s}\n", .{ root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "Harmonic Minor" {
    for ([_]struct {
        root: []const u8,
        expected: []const u8,
    }{
        .{ .root = "C♭", .expected = "C♭ D♭ E𝄫 F♭ G♭ A𝄫 B♭ C♭" },
        .{ .root = "C", .expected = "C D E♭ F G A♭ B C" },
        .{ .root = "C♯", .expected = "C♯ D♯ E F♯ G♯ A B♯ C♯" },
        .{ .root = "D", .expected = "D E F G A B♭ C♯ D" },
        .{ .root = "D♯", .expected = "D♯ E♯ F♯ G♯ A♯ B C𝄪 D♯" },
        .{ .root = "E♭", .expected = "E♭ F G♭ A♭ B♭ C♭ D E♭" },
        .{ .root = "E", .expected = "E F♯ G A B C D♯ E" },
        .{ .root = "E♯", .expected = "E♯ F𝄪 G♯ A♯ B♯ C♯ D𝄪 E♯" },
        .{ .root = "F♭", .expected = "F♭ G♭ A𝄫 B𝄫 C♭ D𝄫 E♭ F♭" },
        .{ .root = "F", .expected = "F G A♭ B♭ C D♭ E F" },
        .{ .root = "F♯", .expected = "F♯ G♯ A B C♯ D E♯ F♯" },
        .{ .root = "G", .expected = "G A B♭ C D E♭ F♯ G" },
        .{ .root = "G♯", .expected = "G♯ A♯ B C♯ D♯ E F𝄪 G♯" },
        .{ .root = "A", .expected = "A B C D E F G♯ A" },
        .{ .root = "A♯", .expected = "A♯ B♯ C♯ D♯ E♯ F♯ G𝄪 A♯" },
        .{ .root = "B", .expected = "B C♯ D E F♯ G A♯ B" },
        .{ .root = "B♭", .expected = "B♭ C D♭ E♭ F G♭ A B♭" },
    }) |case| {
        const notes = Mode.HarmonicMinor.scale(try Note.parse(case.root));
        var printer = try Printer.init(std.testing.allocator, &notes);
        defer printer.deinit(std.testing.allocator);
        //std.debug.print("{s}{s} | got: {s} expected: {s}\n", .{ root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "Chromatic" {
    for ([_]struct {
        root: []const u8,
        expected: []const u8,
    }{
        .{ .root = "C♭", .expected = "C♭ C D♭ D E♭ E F G♭ G A♭ A B♭ C♭" },
        .{ .root = "C", .expected = "C C♯ D D♯ E F F♯ G G♯ A A♯ B C" },
        .{ .root = "C♯", .expected = "C♯ D D♯ E F F♯ G G♯ A A♯ B C C♯" },
        .{ .root = "D♭", .expected = "D♭ D E♭ E F G♭ G A♭ A B♭ B C D♭" },
        .{ .root = "D", .expected = "D D♯ E F F♯ G G♯ A A♯ B C C♯ D" },
        .{ .root = "D♯", .expected = "D♯ E F F♯ G G♯ A A♯ B C C♯ D D♯" },
        .{ .root = "E♭", .expected = "E♭ E F G♭ G A♭ A B♭ B C D♭ D E♭" },
        .{ .root = "E", .expected = "E F F♯ G G♯ A A♯ B C C♯ D D♯ E" },
        .{ .root = "E♯", .expected = "E♯ F♯ G G♯ A A♯ B C C♯ D D♯ E E♯" },
        .{ .root = "F♭", .expected = "F♭ F G♭ G A♭ A B♭ B C D♭ D E♭ F♭" },
        .{ .root = "F", .expected = "F F♯ G G♯ A A♯ B C C♯ D D♯ E F" },
        .{ .root = "F♯", .expected = "F♯ G G♯ A A♯ B C C♯ D D♯ E F F♯" },
        .{ .root = "G♭", .expected = "G♭ G A♭ A B♭ B C D♭ D E♭ E F G♭" },
        .{ .root = "G", .expected = "G G♯ A A♯ B C C♯ D D♯ E F F♯ G" },
        .{ .root = "G♯", .expected = "G♯ A A♯ B C C♯ D D♯ E F F♯ G G♯" },
        .{ .root = "A♭", .expected = "A♭ A B♭ B C D♭ D E♭ E F G♭ G A♭" },
        .{ .root = "A", .expected = "A A♯ B C C♯ D D♯ E F F♯ G G♯ A" },
        .{ .root = "A♯", .expected = "A♯ B C C♯ D D♯ E F F♯ G G♯ A A♯" },
        .{ .root = "B♭", .expected = "B♭ B C D♭ D E♭ E F G♭ G A♭ A B♭" },
        .{ .root = "B", .expected = "B C C♯ D D♯ E F F♯ G G♯ A A♯ B" },
        .{ .root = "B♯", .expected = "B♯ C♯ D D♯ E F F♯ G G♯ A A♯ B B♯" },
    }) |case| {
        const root = try Note.parse(case.root);
        const notes = try Chromatic.scale(root);
        var printer = try Printer.init(std.testing.allocator, &notes);
        defer printer.deinit(std.testing.allocator);
        //std.debug.print("{s}{s} | got: {s} expected: {s}\n", .{ root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "mode.intervals" {
    for ([_]struct { Mode, [7]Step }{
        // Major Scale Modes
        .{ Mode.Ionian, [_]Step{ .Whole, .Whole, .Half, .Whole, .Whole, .Whole, .Half } },
        .{ Mode.Dorian, [_]Step{ .Whole, .Half, .Whole, .Whole, .Whole, .Half, .Whole } },
        .{ Mode.Phrygian, [_]Step{ .Half, .Whole, .Whole, .Whole, .Half, .Whole, .Whole } },
        .{ Mode.Lydian, [_]Step{ .Whole, .Whole, .Whole, .Half, .Whole, .Whole, .Half } },
        .{ Mode.Mixolydian, [_]Step{ .Whole, .Whole, .Half, .Whole, .Whole, .Half, .Whole } },
        .{ Mode.Aeolian, [_]Step{ .Whole, .Half, .Whole, .Whole, .Half, .Whole, .Whole } },
        .{ Mode.Locrian, [_]Step{ .Half, .Whole, .Whole, .Half, .Whole, .Whole, .Whole } },
        // Harmonic Major Modes
        .{ Mode.HarmonicMajor, [_]Step{ .Whole, .Whole, .Half, .Whole, .Half, .AugmentedSecond, .Half } },
        //.{ Mode.DorianB5, [_]Step{ .Whole, .Half, .Whole, .Half, .AugmentedSecond, .Half, .Whole } },
        //.{ Mode.PhrygianB4, [_]Step{ .Half, .Whole, .Half, .AugmentedSecond, .Half, .Whole, .Whole } },
        //.{ Mode.LydianB3, [_]Step{ .Whole, .Half, .AugmentedSecond, .Half, .Whole, .Whole, .Half } },
        //.{ Mode.MixolydianB9, [_]Step{ .Half, .AugmentedSecond, .Half, .Whole, .Whole, .Half, .Whole } },
        //.{ Mode.Lydian_Augmented_Sharp2, [_]Step{ .AugmentedSecond, .Half, .Whole, .Whole, .Half, .Whole, .Half } },
        //.{ Mode.LocrianBB7, [_]Step{ .Half, .Whole, .Whole, .Half, .Whole, .Half, .AugmentedSecond } },
        // Harmonic Minor Modes
        .{ Mode.HarmonicMinor, [_]Step{ .Whole, .Half, .Whole, .Whole, .Half, .AugmentedSecond, .Half } },
        //.{ Mode.LocrianNatural6, [_]Step{ .Half, .Whole, .Whole, .Half, .AugmentedSecond, .Half, .Whole } },
        //.{ Mode.IonianAugmented, [_]Step{ .Whole, .Whole, .Half, .AugmentedSecond, .Half, .Whole, .Half } },
        //.{ Mode.DorianSharp4, [_]Step{ .Whole, .Half, .AugmentedSecond, .Half, .Whole, .Half, .Whole } },
        //.{ Mode.PhrygianDominant, [_]Step{ .Half, .AugmentedSecond, .Half, .Whole, .Half, .Whole, .Whole } },
        //.{ Mode.LydianSharp2, [_]Step{ .AugmentedSecond, .Half, .Whole, .Half, .Whole, .Whole, .Half } },
        //.{ Mode.SuperLocrian, [_]Step{ .Half, .Whole, .Half, .Whole, .Whole, .Half, .AugmentedSecond } },
    }) |case| {
        try std.testing.expectEqual(case[1], case[0].intervals());
    }
}
