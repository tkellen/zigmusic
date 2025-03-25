const std = @import("std");
const core = @import("core");
const Letter = core.Letter;
const Accidental = core.Accidental;
const Note = core.Note;
const Step = core.Step;
const Printer = core.Printer;

pub const Diatonic = enum(u8) {
    Ionian = 0,
    Dorian = 1,
    Phrygian = 2,
    Lydian = 3,
    Mixolydian = 4,
    Aeolian = 5,
    Locrian = 6,

    const steps = [7]core.Step{
        .Whole,
        .Whole,
        .Half,
        .Whole,
        .Whole,
        .Whole,
        .Half,
    };

    fn rotateSteps(self: Diatonic) [7]core.Step {
        var rotated: [7]core.Step = undefined;
        inline for (0..7) |i| {
            rotated[i] = steps[(@intFromEnum(self) + i) % steps.len];
        }
        return rotated;
    }

    pub fn build(self: Diatonic, root: core.Note) [8]core.Note {
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
test "Diatonic - Ionian" {
    const scale = Diatonic.Ionian;
    for ([_]struct { root: []const u8, expected: []const u8 }{
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
        const root = try Note.parse(case.root);
        const notes = scale.build(root);
        var printer = Printer(8).init(notes);
        //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ .generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "Diatonic - Dorian" {
    const scale = Diatonic.Dorian;
    for ([_]struct { root: []const u8, expected: []const u8 }{
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
        const root = try Note.parse(case.root);
        const notes = scale.build(root);
        var printer = Printer(8).init(notes);
        //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ .generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "Diatonic - Phrygian" {
    const scale = Diatonic.Phrygian;
    for ([_]struct { root: []const u8, expected: []const u8 }{
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
        const root = try Note.parse(case.root);
        const notes = scale.build(root);
        var printer = Printer(8).init(notes);
        //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ .generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "Diatonic - Lydian" {
    const scale = Diatonic.Lydian;
    for ([_]struct { root: []const u8, expected: []const u8 }{
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
        const root = try Note.parse(case.root);
        const notes = scale.build(root);
        var printer = Printer(8).init(notes);
        //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ .generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "Diatonic - Mixolydian" {
    const scale = Diatonic.Mixolydian;
    for ([_]struct { root: []const u8, expected: []const u8 }{
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
        const root = try Note.parse(case.root);
        const notes = scale.build(root);
        var printer = Printer(8).init(notes);
        //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ .generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "Diatonic - Aeolian (Minor)" {
    const scale = Diatonic.Aeolian;
    for ([_]struct { root: []const u8, expected: []const u8 }{
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
        const root = try Note.parse(case.root);
        const notes = scale.build(root);
        var printer = Printer(8).init(notes);
        //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ .generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}

test "Diatonic - Locrian" {
    const scale = Diatonic.Locrian;
    for ([_]struct { root: []const u8, expected: []const u8 }{
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
        const root = try Note.parse(case.root);
        const notes = scale.build(root);
        var printer = Printer(8).init(notes);
        //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ .generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}
