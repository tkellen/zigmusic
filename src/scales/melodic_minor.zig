const std = @import("std");
const core = @import("core");
const Letter = core.Letter;
const Accidental = core.Accidental;
const Note = core.Note;
const Step = core.Step;
const Printer = core.Printer;

pub const MelodicMinor = enum(u8) {
    Root = 0,
    DorianB2 = 1,
    LydianAugmented = 2,
    LydianDominant = 3,
    MixolydianB6 = 4,
    HalfDiminished = 5,
    Altered = 6,

    pub const steps = [7]core.Step{
        .Whole,
        .Half,
        .Whole,
        .Whole,
        .Whole,
        .Whole,
        .Half,
    };

    pub fn name(self: MelodicMinor) []const u8 {
        return @tagName(self);
    }

    pub fn parse(input: []const u8) ?MelodicMinor {
        return std.meta.stringToEnum(MelodicMinor, input);
    }

    pub fn rotateSteps(self: MelodicMinor) [7]core.Step {
        var rotated: [7]core.Step = undefined;
        inline for (0..7) |i| {
            rotated[i] = steps[(@intFromEnum(self) + i) % steps.len];
        }
        return rotated;
    }

    pub fn scale(self: MelodicMinor, root: core.Note) [8]core.Note {
        var result: [8]core.Note = undefined;
        result[0] = root;
        var note = root;
        for (self.rotateSteps(), 1..) |step, index| {
            note = Note.spell(
                note.natural.next(),
                step.chromaticPositionFrom(note),
            );
            result[index] = note;
        }
        return result;
    }
};

// test data from: https://everythingmusic.com/learn/music-theory/scales
test "MelodicMinor - Root" {
    const generator = MelodicMinor.Root;
    for ([_]struct { root: []const u8, expected: []const u8 }{
        .{ .root = "C♭", .expected = "C♭ D♭ E𝄫 F♭ G♭ A♭ B♭ C♭" },
        .{ .root = "C", .expected = "C D E♭ F G A B C" },
        .{ .root = "C♯", .expected = "C♯ D♯ E F♯ G♯ A♯ B♯ C♯" },
        .{ .root = "D", .expected = "D E F G A B C♯ D" },
        .{ .root = "D♯", .expected = "D♯ E♯ F♯ G♯ A♯ B♯ C𝄪 D♯" },
        .{ .root = "E♭", .expected = "E♭ F G♭ A♭ B♭ C D E♭" },
        .{ .root = "E", .expected = "E F♯ G A B C♯ D♯ E" },
        .{ .root = "E♯", .expected = "E♯ F𝄪 G♯ A♯ B♯ C𝄪 D𝄪 E♯" },
        .{ .root = "F♭", .expected = "F♭ G♭ A𝄫 B𝄫 C♭ D♭ E♭ F♭" },
        .{ .root = "F", .expected = "F G A♭ B♭ C D E F" },
        .{ .root = "F♯", .expected = "F♯ G♯ A B C♯ D♯ E♯ F♯" },
        .{ .root = "G", .expected = "G A B♭ C D E F♯ G" },
        .{ .root = "G♯", .expected = "G♯ A♯ B C♯ D♯ E♯ F𝄪 G♯" },
        .{ .root = "A", .expected = "A B C D E F♯ G♯ A" },
        .{ .root = "A♯", .expected = "A♯ B♯ C♯ D♯ E♯ F𝄪 G𝄪 A♯" },
        .{ .root = "B", .expected = "B C♯ D E F♯ G♯ A♯ B" },
        .{ .root = "B♭", .expected = "B♭ C D♭ E♭ F G A B♭" },
    }) |case| {
        const root = try Note.parse(case.root);
        const scale = generator.scale(root);
        var printer = Printer(8).init(scale);
        //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ .generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "MelodicMinor - DorianB2" {
    const generator = MelodicMinor.DorianB2;
    for ([_]struct { root: []const u8, expected: []const u8 }{
        .{ .root = "C♭", .expected = "C♭ D𝄫 E𝄫 F♭ G♭ A♭ B𝄫 C♭" },
        .{ .root = "C", .expected = "C D♭ E♭ F G A B♭ C" },
        .{ .root = "C♯", .expected = "C♯ D E F♯ G♯ A♯ B C♯" },
        .{ .root = "D", .expected = "D E♭ F G A B C D" },
        .{ .root = "D♯", .expected = "D♯ E F♯ G♯ A♯ B♯ C♯ D♯" },
        .{ .root = "E♭", .expected = "E♭ F♭ G♭ A♭ B♭ C D♭ E♭" },
        .{ .root = "E", .expected = "E F G A B C♯ D E" },
        .{ .root = "E♯", .expected = "E♯ F♯ G♯ A♯ B♯ C𝄪 D♯ E♯" },
        .{ .root = "F♭", .expected = "F♭ G𝄫 A𝄫 B𝄫 C♭ D♭ E𝄫 F♭" },
        .{ .root = "F", .expected = "F G♭ A♭ B♭ C D E♭ F" },
        .{ .root = "F♯", .expected = "F♯ G A B C♯ D♯ E F♯" },
        .{ .root = "G", .expected = "G A♭ B♭ C D E F G" },
        .{ .root = "G♯", .expected = "G♯ A B C♯ D♯ E♯ F♯ G♯" },
        .{ .root = "A", .expected = "A B♭ C D E F♯ G A" },
        .{ .root = "A♯", .expected = "A♯ B C♯ D♯ E♯ F𝄪 G♯ A♯" },
        .{ .root = "B", .expected = "B C D E F♯ G♯ A B" },
        .{ .root = "B♭", .expected = "B♭ C♭ D♭ E♭ F G A♭ B♭" },
    }) |case| {
        const root = try Note.parse(case.root);
        const scale = generator.scale(root);
        var printer = Printer(8).init(scale);
        //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ .generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "MelodicMinor - LydianAugmented" {
    const generator = MelodicMinor.LydianAugmented;
    for ([_]struct { root: []const u8, expected: []const u8 }{
        .{ .root = "C♭", .expected = "C♭ D♭ E♭ F G A♭ B♭ C♭" },
        .{ .root = "C", .expected = "C D E F♯ G♯ A B C" },
        .{ .root = "C♯", .expected = "C♯ D♯ E♯ F𝄪 G𝄪 A♯ B♯ C♯" },
        .{ .root = "D", .expected = "D E F♯ G♯ A♯ B C♯ D" },
        .{ .root = "D♯", .expected = "D♯ E♯ F𝄪 G𝄪 A𝄪 B♯ C𝄪 D♯" },
        .{ .root = "E♭", .expected = "E♭ F G A B C D E♭" },
        .{ .root = "E", .expected = "E F♯ G♯ A♯ B♯ C♯ D♯ E" },
        .{ .root = "E♯", .expected = "E♯ F𝄪 G𝄪 A𝄪 B𝄪 C𝄪 D𝄪 E♯" },
        .{ .root = "F♭", .expected = "F♭ G♭ A♭ B♭ C D♭ E♭ F♭" },
        .{ .root = "F", .expected = "F G A B C♯ D E F" },
        .{ .root = "F♯", .expected = "F♯ G♯ A♯ B♯ C𝄪 D♯ E♯ F♯" },
        .{ .root = "G", .expected = "G A B C♯ D♯ E F♯ G" },
        .{ .root = "G♯", .expected = "G♯ A♯ B♯ C𝄪 D𝄪 E♯ F𝄪 G♯" },
        .{ .root = "A", .expected = "A B C♯ D♯ E♯ F♯ G♯ A" },
        .{ .root = "A♯", .expected = "A♯ B♯ C𝄪 D𝄪 E𝄪 F𝄪 G𝄪 A♯" },
        .{ .root = "B", .expected = "B C♯ D♯ E♯ F𝄪 G♯ A♯ B" },
        .{ .root = "B♭", .expected = "B♭ C D E F♯ G A B♭" },
    }) |case| {
        const root = try Note.parse(case.root);
        const scale = generator.scale(root);
        var printer = Printer(8).init(scale);
        //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ .generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "MelodicMinor - LydianDominant" {
    const generator = MelodicMinor.LydianDominant;
    for ([_]struct { root: []const u8, expected: []const u8 }{
        .{ .root = "C♭", .expected = "C♭ D♭ E♭ F G♭ A♭ B𝄫 C♭" },
        .{ .root = "C", .expected = "C D E F♯ G A B♭ C" },
        .{ .root = "C♯", .expected = "C♯ D♯ E♯ F𝄪 G♯ A♯ B C♯" },
        .{ .root = "D", .expected = "D E F♯ G♯ A B C D" },
        .{ .root = "D♯", .expected = "D♯ E♯ F𝄪 G𝄪 A♯ B♯ C♯ D♯" },
        .{ .root = "E♭", .expected = "E♭ F G A B♭ C D♭ E♭" },
        .{ .root = "E", .expected = "E F♯ G♯ A♯ B C♯ D E" },
        .{ .root = "E♯", .expected = "E♯ F𝄪 G𝄪 A𝄪 B♯ C𝄪 D♯ E♯" },
        .{ .root = "F♭", .expected = "F♭ G♭ A♭ B♭ C♭ D♭ E𝄫 F♭" },
        .{ .root = "F", .expected = "F G A B C D E♭ F" },
        .{ .root = "F♯", .expected = "F♯ G♯ A♯ B♯ C♯ D♯ E F♯" },
        .{ .root = "G", .expected = "G A B C♯ D E F G" },
        .{ .root = "G♯", .expected = "G♯ A♯ B♯ C𝄪 D♯ E♯ F♯ G♯" },
        .{ .root = "A", .expected = "A B C♯ D♯ E F♯ G A" },
        .{ .root = "A♯", .expected = "A♯ B♯ C𝄪 D𝄪 E♯ F𝄪 G♯ A♯" },
        .{ .root = "B", .expected = "B C♯ D♯ E♯ F♯ G♯ A B" },
        .{ .root = "B♭", .expected = "B♭ C D E F G A♭ B♭" },
    }) |case| {
        const root = try Note.parse(case.root);
        const scale = generator.scale(root);
        var printer = Printer(8).init(scale);
        //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ .generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "MelodicMinor - MixolydianB6" {
    const generator = MelodicMinor.MixolydianB6;
    for ([_]struct { root: []const u8, expected: []const u8 }{
        .{ .root = "C♭", .expected = "C♭ D♭ E♭ F♭ G♭ A𝄫 B𝄫 C♭" },
        .{ .root = "C", .expected = "C D E F G A♭ B♭ C" },
        .{ .root = "C♯", .expected = "C♯ D♯ E♯ F♯ G♯ A B C♯" },
        .{ .root = "D", .expected = "D E F♯ G A B♭ C D" },
        .{ .root = "D♯", .expected = "D♯ E♯ F𝄪 G♯ A♯ B C♯ D♯" },
        .{ .root = "E♭", .expected = "E♭ F G A♭ B♭ C♭ D♭ E♭" },
        .{ .root = "E", .expected = "E F♯ G♯ A B C D E" },
        .{ .root = "E♯", .expected = "E♯ F𝄪 G𝄪 A♯ B♯ C♯ D♯ E♯" },
        .{ .root = "F♭", .expected = "F♭ G♭ A♭ B𝄫 C♭ D𝄫 E𝄫 F♭" },
        .{ .root = "F", .expected = "F G A B♭ C D♭ E♭ F" },
        .{ .root = "F♯", .expected = "F♯ G♯ A♯ B C♯ D E F♯" },
        .{ .root = "G", .expected = "G A B C D E♭ F G" },
        .{ .root = "G♯", .expected = "G♯ A♯ B♯ C♯ D♯ E F♯ G♯" },
        .{ .root = "A", .expected = "A B C♯ D E F G A" },
        .{ .root = "A♯", .expected = "A♯ B♯ C𝄪 D♯ E♯ F♯ G♯ A♯" },
        .{ .root = "B", .expected = "B C♯ D♯ E F♯ G A B" },
        .{ .root = "B♭", .expected = "B♭ C D E♭ F G♭ A♭ B♭" },
    }) |case| {
        const root = try Note.parse(case.root);
        const scale = generator.scale(root);
        var printer = Printer(8).init(scale);
        //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ .generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "MelodicMinor - HalfDiminished" {
    const generator = MelodicMinor.HalfDiminished;
    for ([_]struct { root: []const u8, expected: []const u8 }{
        .{ .root = "C♭", .expected = "C♭ D♭ E𝄫 F♭ G𝄫 A𝄫 B𝄫 C♭" },
        .{ .root = "C", .expected = "C D E♭ F G♭ A♭ B♭ C" },
        .{ .root = "C♯", .expected = "C♯ D♯ E F♯ G A B C♯" },
        .{ .root = "D", .expected = "D E F G A♭ B♭ C D" },
        .{ .root = "D♯", .expected = "D♯ E♯ F♯ G♯ A B C♯ D♯" },
        .{ .root = "E♭", .expected = "E♭ F G♭ A♭ B𝄫 C♭ D♭ E♭" },
        .{ .root = "E", .expected = "E F♯ G A B♭ C D E" },
        .{ .root = "E♯", .expected = "E♯ F𝄪 G♯ A♯ B C♯ D♯ E♯" },
        .{ .root = "F♭", .expected = "F♭ G♭ A𝄫 B𝄫 C𝄫 D𝄫 E𝄫 F♭" },
        .{ .root = "F", .expected = "F G A♭ B♭ C♭ D♭ E♭ F" },
        .{ .root = "F♯", .expected = "F♯ G♯ A B C D E F♯" },
        .{ .root = "G", .expected = "G A B♭ C D♭ E♭ F G" },
        .{ .root = "G♯", .expected = "G♯ A♯ B C♯ D E F♯ G♯" },
        .{ .root = "A", .expected = "A B C D E♭ F G A" },
        .{ .root = "A♯", .expected = "A♯ B♯ C♯ D♯ E F♯ G♯ A♯" },
        .{ .root = "B", .expected = "B C♯ D E F G A B" },
        .{ .root = "B♭", .expected = "B♭ C D♭ E♭ F♭ G♭ A♭ B♭" },
    }) |case| {
        const root = try Note.parse(case.root);
        const scale = generator.scale(root);
        var printer = Printer(8).init(scale);
        //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ .generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "Melodic Minor - Altered" {
    const generator = MelodicMinor.Altered;
    for ([_]struct { root: []const u8, expected: []const u8 }{
        .{ .root = "C♭", .expected = "C♭ D𝄫 E𝄫 F𝄫 G𝄫 A𝄫 B𝄫 C♭" },
        .{ .root = "C", .expected = "C D♭ E♭ F♭ G♭ A♭ B♭ C" },
        .{ .root = "C♯", .expected = "C♯ D E F G A B C♯" },
        .{ .root = "D", .expected = "D E♭ F G♭ A♭ B♭ C D" },
        .{ .root = "D♯", .expected = "D♯ E F♯ G A B C♯ D♯" },
        .{ .root = "E♭", .expected = "E♭ F♭ G♭ A𝄫 B𝄫 C♭ D♭ E♭" },
        .{ .root = "E", .expected = "E F G A♭ B♭ C D E" },
        .{ .root = "E♯", .expected = "E♯ F♯ G♯ A B C♯ D♯ E♯" },
        //.{ .root = "F♭", .expected = "" },
        .{ .root = "F", .expected = "F G♭ A♭ B𝄫 C♭ D♭ E♭ F" },
        .{ .root = "F♯", .expected = "F♯ G A B♭ C D E F♯" },
        .{ .root = "G", .expected = "G A♭ B♭ C♭ D♭ E♭ F G" },
        .{ .root = "G♯", .expected = "G♯ A B C D E F♯ G♯" },
        .{ .root = "A", .expected = "A B♭ C D♭ E♭ F G A" },
        .{ .root = "A♯", .expected = "A♯ B C♯ D E F♯ G♯ A♯" },
        .{ .root = "B", .expected = "B C D E♭ F G A B" },
        .{ .root = "B♭", .expected = "B♭ C♭ D♭ E𝄫 F♭ G♭ A♭ B♭" },
    }) |case| {
        const root = try Note.parse(case.root);
        const scale = generator.scale(root);
        var printer = Printer(8).init(scale);
        //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ .generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}
