const std = @import("std");
const core = @import("core");
const Letter = core.Letter;
const Accidental = core.Accidental;
const Note = core.Note;
const Step = core.Step;
const Printer = core.Printer;

pub const HarmonicMinor = enum(u8) {
    Root = 0,
    Locrian6 = 1,
    IonianAugmented = 2,
    Dorian4 = 3,
    PhrygianDominant = 4,
    Lydian2 = 5,
    UltraLocrian = 6,

    const steps = [7]core.Step{
        .Whole,
        .Half,
        .Whole,
        .Whole,
        .Half,
        .AugmentedSecond,
        .Half,
    };

    fn rotateSteps(self: HarmonicMinor) [7]core.Step {
        var rotated: [7]core.Step = undefined;
        inline for (0..7) |i| {
            rotated[i] = steps[(@intFromEnum(self) + i) % steps.len];
        }
        return rotated;
    }

    pub fn build(self: HarmonicMinor, root: core.Note) [8]core.Note {
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

// test data from: https://everythingmusic.com/learn/music-theory/scale
test "Harmonic Minor - Root" {
    const scale = HarmonicMinor.Root;
    for ([_]struct { root: []const u8, expected: []const u8 }{
        .{ .root = "C♭", .expected = "C♭ D♭ E𝄫 F♭ G♭ A𝄫 B♭ C♭" },
        .{ .root = "C", .expected = "C D E♭ F G A♭ B C" },
        .{ .root = "C♯", .expected = "C♯ D♯ E F♯ G♯ A B♯ C♯" },
        .{ .root = "D♭", .expected = "D♭ E♭ F♭ G♭ A♭ B𝄫 C D♭" },
        .{ .root = "D", .expected = "D E F G A B♭ C♯ D" },
        .{ .root = "E♭", .expected = "E♭ F G♭ A♭ B♭ C♭ D E♭" },
        .{ .root = "E", .expected = "E F♯ G A B C D♯ E" },
        .{ .root = "E♯", .expected = "E♯ F𝄪 G♯ A♯ B♯ C♯ D𝄪 E♯" },
        .{ .root = "F♭", .expected = "F♭ G♭ A𝄫 B𝄫 C♭ D𝄫 E♭ F♭" },
        .{ .root = "F", .expected = "F G A♭ B♭ C D♭ E F" },
        .{ .root = "F♯", .expected = "F♯ G♯ A B C♯ D E♯ F♯" },
        .{ .root = "G♭", .expected = "G♭ A♭ B𝄫 C♭ D♭ E𝄫 F G♭" },
        .{ .root = "G", .expected = "G A B♭ C D E♭ F♯ G" },
        .{ .root = "A♭", .expected = "A♭ B♭ C♭ D♭ E♭ F♭ G A♭" },
        .{ .root = "A", .expected = "A B C D E F G♯ A" },
        .{ .root = "B♭", .expected = "B♭ C D♭ E♭ F G♭ A B♭" },
        .{ .root = "B", .expected = "B C♯ D E F♯ G A♯ B" },
    }) |case| {
        const root = try Note.parse(case.root);
        const notes = scale.build(root);
        var printer = Printer(8).init(notes);
        //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ .generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "Harmonic Minor - Locrian6" {
    const scale = HarmonicMinor.Locrian6;
    for ([_]struct { root: []const u8, expected: []const u8 }{
        .{ .root = "C♭", .expected = "C♭ D𝄫 E𝄫 F♭ G𝄫 A♭ B𝄫 C♭" },
        .{ .root = "C", .expected = "C D♭ E♭ F G♭ A B♭ C" },
        .{ .root = "C♯", .expected = "C♯ D E F♯ G A♯ B C♯" },
        .{ .root = "D", .expected = "D E♭ F G A♭ B C D" },
        .{ .root = "D♯", .expected = "D♯ E F♯ G♯ A B♯ C♯ D♯" },
        .{ .root = "E♭", .expected = "E♭ F♭ G♭ A♭ B𝄫 C D♭ E♭" },
        .{ .root = "E", .expected = "E F G A B♭ C♯ D E" },
        .{ .root = "E♯", .expected = "E♯ F♯ G♯ A♯ B C𝄪 D♯ E♯" },
        .{ .root = "F♭", .expected = "F♭ G𝄫 A𝄫 B𝄫 C𝄫 D♭ E𝄫 F♭" },
        .{ .root = "F", .expected = "F G♭ A♭ B♭ C♭ D E♭ F" },
        .{ .root = "F♯", .expected = "F♯ G A B C D♯ E F♯" },
        .{ .root = "G", .expected = "G A♭ B♭ C D♭ E F G" },
        .{ .root = "G♯", .expected = "G♯ A B C♯ D E♯ F♯ G♯" },
        .{ .root = "A", .expected = "A B♭ C D E♭ F♯ G A" },
        .{ .root = "A♯", .expected = "A♯ B C♯ D♯ E F𝄪 G♯ A♯" },
        .{ .root = "B", .expected = "B C D E F G♯ A B" },
        .{ .root = "B♭", .expected = "B♭ C♭ D♭ E♭ F♭ G A♭ B♭" },
    }) |case| {
        const root = try Note.parse(case.root);
        const notes = scale.build(root);
        var printer = Printer(8).init(notes);
        //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ .generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "Harmonic Minor - IonianAugmented" {
    const scale = HarmonicMinor.IonianAugmented;
    for ([_]struct { root: []const u8, expected: []const u8 }{
        .{ .root = "C♭", .expected = "C♭ D♭ E♭ F♭ G A♭ B♭ C♭" },
        .{ .root = "C", .expected = "C D E F G♯ A B C" },
        .{ .root = "C♯", .expected = "C♯ D♯ E♯ F♯ G𝄪 A♯ B♯ C♯" },
        .{ .root = "D", .expected = "D E F♯ G A♯ B C♯ D" },
        .{ .root = "D♯", .expected = "D♯ E♯ F𝄪 G♯ A𝄪 B♯ C𝄪 D♯" },
        .{ .root = "E♭", .expected = "E♭ F G A♭ B C D E♭" },
        .{ .root = "E", .expected = "E F♯ G♯ A B♯ C♯ D♯ E" },
        .{ .root = "E♯", .expected = "E♯ F𝄪 G𝄪 A♯ B𝄪 C𝄪 D𝄪 E♯" },
        .{ .root = "F♭", .expected = "F♭ G♭ A♭ B𝄫 C D♭ E♭ F♭" },
        .{ .root = "F", .expected = "F G A B♭ C♯ D E F" },
        .{ .root = "F♯", .expected = "F♯ G♯ A♯ B C𝄪 D♯ E♯ F♯" },
        .{ .root = "G", .expected = "G A B C D♯ E F♯ G" },
        .{ .root = "G♯", .expected = "G♯ A♯ B♯ C♯ D𝄪 E♯ F𝄪 G♯" },
        .{ .root = "A", .expected = "A B C♯ D E♯ F♯ G♯ A" },
        .{ .root = "A♯", .expected = "A♯ B♯ C𝄪 D♯ E𝄪 F𝄪 G𝄪 A♯" },
        .{ .root = "B", .expected = "B C♯ D♯ E F𝄪 G♯ A♯ B" },
        .{ .root = "B♭", .expected = "B♭ C D E♭ F♯ G A B♭" },
    }) |case| {
        const root = try Note.parse(case.root);
        const notes = scale.build(root);
        var printer = Printer(8).init(notes);
        //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ .generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "Harmonic Minor - Dorian4" {
    const scale = HarmonicMinor.Dorian4;
    for ([_]struct { root: []const u8, expected: []const u8 }{
        .{ .root = "C♭", .expected = "C♭ D♭ E𝄫 F G♭ A♭ B𝄫 C♭" },
        .{ .root = "C", .expected = "C D E♭ F♯ G A B♭ C" },
        .{ .root = "C♯", .expected = "C♯ D♯ E F𝄪 G♯ A♯ B C♯" },
        .{ .root = "D", .expected = "D E F G♯ A B C D" },
        .{ .root = "D♯", .expected = "D♯ E♯ F♯ G𝄪 A♯ B♯ C♯ D♯" },
        .{ .root = "E♭", .expected = "E♭ F G♭ A B♭ C D♭ E♭" },
        .{ .root = "E", .expected = "E F♯ G A♯ B C♯ D E" },
        .{ .root = "E♯", .expected = "E♯ F𝄪 G♯ A𝄪 B♯ C𝄪 D♯ E♯" },
        .{ .root = "F♭", .expected = "F♭ G♭ A𝄫 B♭ C♭ D♭ E𝄫 F♭" },
        .{ .root = "F", .expected = "F G A♭ B C D E♭ F" },
        .{ .root = "F♯", .expected = "F♯ G♯ A B♯ C♯ D♯ E F♯" },
        .{ .root = "G", .expected = "G A B♭ C♯ D E F G" },
        .{ .root = "G♯", .expected = "G♯ A♯ B C𝄪 D♯ E♯ F♯ G♯" },
        .{ .root = "A", .expected = "A B C D♯ E F♯ G A" },
        .{ .root = "A♯", .expected = "A♯ B♯ C♯ D𝄪 E♯ F𝄪 G♯ A♯" },
        .{ .root = "B", .expected = "B C♯ D E♯ F♯ G♯ A B" },
        .{ .root = "B♭", .expected = "B♭ C D♭ E F G A♭ B♭" },
    }) |case| {
        const root = try Note.parse(case.root);
        const notes = scale.build(root);
        var printer = Printer(8).init(notes);
        //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ .generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "Harmonic Minor - PhrygianDominant" {
    const scale = HarmonicMinor.PhrygianDominant;
    for ([_]struct { root: []const u8, expected: []const u8 }{
        .{ .root = "C♭", .expected = "C♭ D𝄫 E♭ F♭ G♭ A𝄫 B𝄫 C♭" },
        .{ .root = "C", .expected = "C D♭ E F G A♭ B♭ C" },
        .{ .root = "C♯", .expected = "C♯ D E♯ F♯ G♯ A B C♯" },
        .{ .root = "D", .expected = "D E♭ F♯ G A B♭ C D" },
        .{ .root = "D♯", .expected = "D♯ E F𝄪 G♯ A♯ B C♯ D♯" },
        .{ .root = "E♭", .expected = "E♭ F♭ G A♭ B♭ C♭ D♭ E♭" },
        .{ .root = "E", .expected = "E F G♯ A B C D E" },
        .{ .root = "E♯", .expected = "E♯ F♯ G𝄪 A♯ B♯ C♯ D♯ E♯" },
        .{ .root = "F♭", .expected = "F♭ G𝄫 A♭ B𝄫 C♭ D𝄫 E𝄫 F♭" },
        .{ .root = "F", .expected = "F G♭ A B♭ C D♭ E♭ F" },
        .{ .root = "F♯", .expected = "F♯ G A♯ B C♯ D E F♯" },
        .{ .root = "G", .expected = "G A♭ B C D E♭ F G" },
        .{ .root = "G♯", .expected = "G♯ A B♯ C♯ D♯ E F♯ G♯" },
        .{ .root = "A", .expected = "A B♭ C♯ D E F G A" },
        .{ .root = "A♯", .expected = "A♯ B C𝄪 D♯ E♯ F♯ G♯ A♯" },
        .{ .root = "B", .expected = "B C D♯ E F♯ G A B" },
        .{ .root = "B♭", .expected = "B♭ C♭ D E♭ F G♭ A♭ B♭" },
    }) |case| {
        const root = try Note.parse(case.root);
        const notes = scale.build(root);
        var printer = Printer(8).init(notes);
        //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ .generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

// test "Harmonic Minor - Lydian2" {
//     for ([_]struct { root: []const u8, expected: []const u8 }{
//         //.{ .root = "C♭", .expected = "" },
//         .{ .root = "C", .expected = "C D♭ E♭ F♭ G♭ A♭ B𝄫 C" },
//         .{ .root = "C♯", .expected = "C♯ D E F G A B♭ C♯" },
//         .{ .root = "D", .expected = "D E♭ F G♭ A♭ B♭ C♭ D" },
//         .{ .root = "D♯", .expected = "D♯ E F♯ G A B C D♯" },
//         .{ .root = "E♭", .expected = "E♭ F♭ G♭ A𝄫 B𝄫 C♭ D𝄫 E♭" },
//         .{ .root = "E", .expected = "E F G A♭ B♭ C D♭ E" },
//         .{ .root = "E♯", .expected = "E♯ F♯ G♯ A B C♯ D E♯" },
//         // .{ .root = "F♭", .expected = "" },
//         .{ .root = "F", .expected = "F G♭ A♭ B𝄫 C♭ D♭ E𝄫 F" },
//         .{ .root = "F♯", .expected = "F♯ G A B♭ C D E♭ F♯" },
//         .{ .root = "G", .expected = "G A♭ B♭ C♭ D♭ E♭ F♭ G" },
//         .{ .root = "G♯", .expected = "G♯ A B C D E F G♯" },
//         .{ .root = "A", .expected = "A B♭ C D♭ E♭ F G♭ A" },
//         .{ .root = "A♯", .expected = "A♯ B C♯ D E F♯ G A♯" },
//         .{ .root = "B", .expected = "B C D E♭ F G A♭ B" },
//         .{ .root = "B♭", .expected = "B♭ C♭ D♭ E𝄫 F♭ G♭ A𝄫 B♭" },
//     }) |case| {
//         const root = try Note.parse(case.root);
//         const scale = Mode.Lydian2.generate(root);
//         var printer = Printer(8).init(notes);
// //         std.debug.print("{s}{s} | got: {s} expected: {s}\n", .{ root.natural.name(), root.accidental.name(), printer.string(), case.expected });
//         //try std.testing.expectEqualStrings(case.expected, printer.string());
//     }
// }

test "Harmonic Minor - UltraLocrian" {
    const scale = HarmonicMinor.UltraLocrian;
    for ([_]struct { root: []const u8, expected: []const u8 }{
        //.{ .root = "C♭", .expected = "" },
        .{ .root = "C", .expected = "C D♭ E♭ F♭ G♭ A♭ B𝄫 C" },
        .{ .root = "C♯", .expected = "C♯ D E F G A B♭ C♯" },
        .{ .root = "D", .expected = "D E♭ F G♭ A♭ B♭ C♭ D" },
        .{ .root = "D♯", .expected = "D♯ E F♯ G A B C D♯" },
        .{ .root = "E♭", .expected = "E♭ F♭ G♭ A𝄫 B𝄫 C♭ D𝄫 E♭" },
        .{ .root = "E", .expected = "E F G A♭ B♭ C D♭ E" },
        .{ .root = "E♯", .expected = "E♯ F♯ G♯ A B C♯ D E♯" },
        // .{ .root = "F♭", .expected = "" },
        .{ .root = "F", .expected = "F G♭ A♭ B𝄫 C♭ D♭ E𝄫 F" },
        .{ .root = "F♯", .expected = "F♯ G A B♭ C D E♭ F♯" },
        .{ .root = "G", .expected = "G A♭ B♭ C♭ D♭ E♭ F♭ G" },
        .{ .root = "G♯", .expected = "G♯ A B C D E F G♯" },
        .{ .root = "A", .expected = "A B♭ C D♭ E♭ F G♭ A" },
        .{ .root = "A♯", .expected = "A♯ B C♯ D E F♯ G A♯" },
        .{ .root = "B", .expected = "B C D E♭ F G A♭ B" },
        .{ .root = "B♭", .expected = "B♭ C♭ D♭ E𝄫 F♭ G♭ A𝄫 B♭" },
    }) |case| {
        const root = try Note.parse(case.root);
        const notes = scale.build(root);
        var printer = Printer(8).init(notes);
        //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ .generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}
