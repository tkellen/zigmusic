const std = @import("std");
const core = @import("core");
const Letter = core.Letter;
const Accidental = core.Accidental;
const Note = core.Note;
const Step = core.Step;
const Printer = core.Printer;

pub const HarmonicMajor = enum(u8) {
    IonianB6 = 0,
    DorianB5 = 1,
    PhrygianB4 = 2,
    LydianB3 = 3,
    MixolydianB2 = 4,
    LydianAugmented2 = 5,
    LocrianDiminished7 = 6,

    pub const steps = [7]core.Step{
        .Whole,
        .Whole,
        .Half,
        .Whole,
        .Half,
        .AugmentedSecond,
        .Half,
    };

    pub fn name(self: HarmonicMajor) []const u8 {
        return @tagName(self);
    }

    pub fn parse(input: []const u8) ?HarmonicMajor {
        return std.meta.stringToEnum(HarmonicMajor, input);
    }

    pub fn rotateSteps(self: HarmonicMajor) [7]core.Step {
        var rotated: [7]core.Step = undefined;
        inline for (0..7) |i| {
            rotated[i] = steps[(@intFromEnum(self) + i) % steps.len];
        }
        return rotated;
    }

    pub fn scale(self: HarmonicMajor, root: core.Note) [8]core.Note {
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
test "Harmonic Major - IonianB6" {
    const generator = HarmonicMajor.IonianB6;
    for ([_]struct { root: []const u8, expected: []const u8 }{
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
        const root = try Note.parse(case.root);
        const scale = generator.scale(root);
        var printer = Printer(8).init(scale);
        //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ .generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "Harmonic Major - DorianB5" {
    const generator = HarmonicMajor.DorianB5;
    for ([_]struct { root: []const u8, expected: []const u8 }{
        .{ .root = "C♭", .expected = "C♭ D♭ E𝄫 F♭ G𝄫 A♭ B𝄫 C♭" },
        .{ .root = "C", .expected = "C D E♭ F G♭ A B♭ C" },
        .{ .root = "C♯", .expected = "C♯ D♯ E F♯ G A♯ B C♯" },
        .{ .root = "D", .expected = "D E F G A♭ B C D" },
        .{ .root = "D♯", .expected = "D♯ E♯ F♯ G♯ A B♯ C♯ D♯" },
        .{ .root = "E♭", .expected = "E♭ F G♭ A♭ B𝄫 C D♭ E♭" },
        .{ .root = "E", .expected = "E F♯ G A B♭ C♯ D E" },
        .{ .root = "E♯", .expected = "E♯ F𝄪 G♯ A♯ B C𝄪 D♯ E♯" },
        .{ .root = "F♭", .expected = "F♭ G♭ A𝄫 B𝄫 C𝄫 D♭ E𝄫 F♭" },
        .{ .root = "F", .expected = "F G A♭ B♭ C♭ D E♭ F" },
        .{ .root = "F♯", .expected = "F♯ G♯ A B C D♯ E F♯" },
        .{ .root = "G", .expected = "G A B♭ C D♭ E F G" },
        .{ .root = "G♯", .expected = "G♯ A♯ B C♯ D E♯ F♯ G♯" },
        .{ .root = "A", .expected = "A B C D E♭ F♯ G A" },
        .{ .root = "A♯", .expected = "A♯ B♯ C♯ D♯ E F𝄪 G♯ A♯" },
        .{ .root = "B", .expected = "B C♯ D E F G♯ A B" },
        .{ .root = "B♭", .expected = "B♭ C D♭ E♭ F♭ G A♭ B♭" },
    }) |case| {
        const root = try Note.parse(case.root);
        const scale = generator.scale(root);
        var printer = Printer(8).init(scale);
        //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ .generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "Harmonic Major - PhrygianB4" {
    const generator = HarmonicMajor.PhrygianB4;
    for ([_]struct { root: []const u8, expected: []const u8 }{
        .{ .root = "C♭", .expected = "C♭ D𝄫 E𝄫 F𝄫 G♭ A𝄫 B𝄫 C♭" },
        .{ .root = "C", .expected = "C D♭ E♭ F♭ G A♭ B♭ C" },
        .{ .root = "C♯", .expected = "C♯ D E F G♯ A B C♯" },
        .{ .root = "D", .expected = "D E♭ F G♭ A B♭ C D" },
        .{ .root = "D♯", .expected = "D♯ E F♯ G A♯ B C♯ D♯" },
        .{ .root = "E♭", .expected = "E♭ F♭ G♭ A𝄫 B♭ C♭ D♭ E♭" },
        .{ .root = "E", .expected = "E F G A♭ B C D E" },
        .{ .root = "E♯", .expected = "E♯ F♯ G♯ A B♯ C♯ D♯ E♯" },
        //.{ .root = "F♭", .expected = "" },
        .{ .root = "F", .expected = "F G♭ A♭ B𝄫 C D♭ E♭ F" },
        .{ .root = "F♯", .expected = "F♯ G A B♭ C♯ D E F♯" },
        .{ .root = "G", .expected = "G A♭ B♭ C♭ D E♭ F G" },
        .{ .root = "G♯", .expected = "G♯ A B C D♯ E F♯ G♯" },
        .{ .root = "A", .expected = "A B♭ C D♭ E F G A" },
        .{ .root = "A♯", .expected = "A♯ B C♯ D E♯ F♯ G♯ A♯" },
        .{ .root = "B", .expected = "B C D E♭ F♯ G A B" },
        .{ .root = "B♭", .expected = "B♭ C♭ D♭ E𝄫 F G♭ A♭ B♭" },
    }) |case| {
        const root = try Note.parse(case.root);
        const scale = generator.scale(root);
        var printer = Printer(8).init(scale);
        //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ .generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "Harmonic Major - LydianB3" {
    const generator = HarmonicMajor.LydianB3;
    for ([_]struct { root: []const u8, expected: []const u8 }{
        .{ .root = "C♭", .expected = "C♭ D♭ E𝄫 F G♭ A♭ B♭ C♭" },
        .{ .root = "C", .expected = "C D E♭ F♯ G A B C" },
        .{ .root = "C♯", .expected = "C♯ D♯ E F𝄪 G♯ A♯ B♯ C♯" },
        .{ .root = "D", .expected = "D E F G♯ A B C♯ D" },
        .{ .root = "D♯", .expected = "D♯ E♯ F♯ G𝄪 A♯ B♯ C𝄪 D♯" },
        .{ .root = "E♭", .expected = "E♭ F G♭ A B♭ C D E♭" },
        .{ .root = "E", .expected = "E F♯ G A♯ B C♯ D♯ E" },
        .{ .root = "E♯", .expected = "E♯ F𝄪 G♯ A𝄪 B♯ C𝄪 D𝄪 E♯" },
        .{ .root = "F♭", .expected = "F♭ G♭ A𝄫 B♭ C♭ D♭ E♭ F♭" },
        .{ .root = "F", .expected = "F G A♭ B C D E F" },
        .{ .root = "F♯", .expected = "F♯ G♯ A B♯ C♯ D♯ E♯ F♯" },
        .{ .root = "G", .expected = "G A B♭ C♯ D E F♯ G" },
        .{ .root = "G♯", .expected = "G♯ A♯ B C𝄪 D♯ E♯ F𝄪 G♯" },
        .{ .root = "A", .expected = "A B C D♯ E F♯ G♯ A" },
        .{ .root = "A♯", .expected = "A♯ B♯ C♯ D𝄪 E♯ F𝄪 G𝄪 A♯" },
        .{ .root = "B", .expected = "B C♯ D E♯ F♯ G♯ A♯ B" },
        .{ .root = "B♭", .expected = "B♭ C D♭ E F G A B♭" },
    }) |case| {
        const root = try Note.parse(case.root);
        const scale = generator.scale(root);
        var printer = Printer(8).init(scale);
        //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ .generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "Harmonic Major - MixolydianB2" {
    const generator = HarmonicMajor.MixolydianB2;
    for ([_]struct { root: []const u8, expected: []const u8 }{
        .{ .root = "C♭", .expected = "C♭ D𝄫 E♭ F♭ G♭ A♭ B𝄫 C♭" },
        .{ .root = "C", .expected = "C D♭ E F G A B♭ C" },
        .{ .root = "C♯", .expected = "C♯ D E♯ F♯ G♯ A♯ B C♯" },
        .{ .root = "D", .expected = "D E♭ F♯ G A B C D" },
        .{ .root = "D♯", .expected = "D♯ E F𝄪 G♯ A♯ B♯ C♯ D♯" },
        .{ .root = "E♭", .expected = "E♭ F♭ G A♭ B♭ C D♭ E♭" },
        .{ .root = "E", .expected = "E F G♯ A B C♯ D E" },
        .{ .root = "E♯", .expected = "E♯ F♯ G𝄪 A♯ B♯ C𝄪 D♯ E♯" },
        .{ .root = "F♭", .expected = "F♭ G𝄫 A♭ B𝄫 C♭ D♭ E𝄫 F♭" },
        .{ .root = "F", .expected = "F G♭ A B♭ C D E♭ F" },
        .{ .root = "F♯", .expected = "F♯ G A♯ B C♯ D♯ E F♯" },
        .{ .root = "G", .expected = "G A♭ B C D E F G" },
        .{ .root = "G♯", .expected = "G♯ A B♯ C♯ D♯ E♯ F♯ G♯" },
        .{ .root = "A", .expected = "A B♭ C♯ D E F♯ G A" },
        .{ .root = "A♯", .expected = "A♯ B C𝄪 D♯ E♯ F𝄪 G♯ A♯" },
        .{ .root = "B", .expected = "B C D♯ E F♯ G♯ A B" },
        .{ .root = "B♭", .expected = "B♭ C♭ D E♭ F G A♭ B♭" },
    }) |case| {
        const root = try Note.parse(case.root);
        const scale = generator.scale(root);
        var printer = Printer(8).init(scale);
        //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ .generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "Harmonic Major - LydianAugmented2" {
    const generator = HarmonicMajor.LydianAugmented2;
    for ([_]struct { root: []const u8, expected: []const u8 }{
        .{ .root = "C♭", .expected = "C♭ D E♭ F G A♭ B♭ C♭" },
        .{ .root = "C", .expected = "C D♯ E F♯ G♯ A B C" },
        .{ .root = "C♯", .expected = "C♯ D𝄪 E♯ F𝄪 G𝄪 A♯ B♯ C♯" },
        .{ .root = "D", .expected = "D E♯ F♯ G♯ A♯ B C♯ D" },
        .{ .root = "D♯", .expected = "D♯ E𝄪 F𝄪 G𝄪 A𝄪 B♯ C𝄪 D♯" },
        .{ .root = "E♭", .expected = "E♭ F♯ G A B C D E♭" },
        .{ .root = "E", .expected = "E F𝄪 G♯ A♯ B♯ C♯ D♯ E" },
        //.{ .root = "E♯", .expected = "" },
        .{ .root = "F♭", .expected = "F♭ G A♭ B♭ C D♭ E♭ F♭" },
        .{ .root = "F", .expected = "F G♯ A B C♯ D E F" },
        .{ .root = "F♯", .expected = "F♯ G𝄪 A♯ B♯ C𝄪 D♯ E♯ F♯" },
        .{ .root = "G", .expected = "G A♯ B C♯ D♯ E F♯ G" },
        .{ .root = "G♯", .expected = "G♯ A𝄪 B♯ C𝄪 D𝄪 E♯ F𝄪 G♯" },
        .{ .root = "A", .expected = "A B♯ C♯ D♯ E♯ F♯ G♯ A" },
        .{ .root = "A♯", .expected = "A♯ B𝄪 C𝄪 D𝄪 E𝄪 F𝄪 G𝄪 A♯" },
        .{ .root = "B", .expected = "B C𝄪 D♯ E♯ F𝄪 G♯ A♯ B" },
        .{ .root = "B♭", .expected = "B♭ C♯ D E F♯ G A B♭" },
    }) |case| {
        const root = try Note.parse(case.root);
        const scale = generator.scale(root);
        var printer = Printer(8).init(scale);
        //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ .generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "Harmonic Major - LocrianDiminished7" {
    const generator = HarmonicMajor.LocrianDiminished7;
    for ([_]struct { root: []const u8, expected: []const u8 }{
        //.{ .root = "C♭", .expected = "" },
        .{ .root = "C", .expected = "C D♭ E♭ F G♭ A♭ B𝄫 C" },
        .{ .root = "C♯", .expected = "C♯ D E F♯ G A B♭ C♯" },
        .{ .root = "D", .expected = "D E♭ F G A♭ B♭ C♭ D" },
        .{ .root = "D♯", .expected = "D♯ E F♯ G♯ A B C D♯" },
        .{ .root = "E♭", .expected = "E♭ F♭ G♭ A♭ B𝄫 C♭ D𝄫 E♭" },
        .{ .root = "E", .expected = "E F G A B♭ C D♭ E" },
        .{ .root = "E♯", .expected = "E♯ F♯ G♯ A♯ B C♯ D E♯" },
        //.{ .root = "F♭", .expected = "" },
        .{ .root = "F", .expected = "F G♭ A♭ B♭ C♭ D♭ E𝄫 F" },
        .{ .root = "F♯", .expected = "F♯ G A B C D E♭ F♯" },
        .{ .root = "G", .expected = "G A♭ B♭ C D♭ E♭ F♭ G" },
        .{ .root = "G♯", .expected = "G♯ A B C♯ D E F G♯" },
        .{ .root = "A", .expected = "A B♭ C D E♭ F G♭ A" },
        .{ .root = "A♯", .expected = "A♯ B C♯ D♯ E F♯ G A♯" },
        .{ .root = "B", .expected = "B C D E F G A♭ B" },
        .{ .root = "B♭", .expected = "B♭ C♭ D♭ E♭ F♭ G♭ A𝄫 B♭" },
    }) |case| {
        const root = try Note.parse(case.root);
        const scale = generator.scale(root);
        var printer = Printer(8).init(scale);
        //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ .generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}
