const std = @import("std");
const core = @import("core");
const Letter = core.Letter;
const Accidental = core.Accidental;
const Note = core.Note;
const Step = core.Step;
const Printer = core.Printer;

pub const WholeTone = struct {
    pub const steps = [6]Step{
        .Whole, .Whole, .Whole, .Whole, .Whole, .Whole,
    };

    pub fn name() []const u8 {
        return "WholeTone";
    }

    pub const letterPattern: [7]i8 = .{ 0, 1, 2, 3, 4, 6, 0 };
    pub const bsharpLetterPattern: [7]i8 = .{ 0, 1, 2, 3, 5, 6, 0 };
    pub fn scale(root: Note) [7]Note {
        var result: [7]Note = undefined;
        const bsharpRoot = (root.natural == Letter.B and root.accidental == Accidental.Sharp);
        const pattern = if (bsharpRoot) bsharpLetterPattern else letterPattern;
        result[0] = root;
        var note = root;
        for (steps, 0..) |step, i| {
            note = Note.spell(
                root.natural.step(pattern[i + 1]),
                step.chromaticPositionFrom(note),
            );
            result[i + 1] = note;
        }
        return result;
    }
};

// test data from: https://everythingmusic.com/learn/music-theory/scales
test "WholeTone" {
    const generator = WholeTone;
    for ([_]struct { root: []const u8, expected: []const u8 }{
        .{ .root = "C♭", .expected = "C♭ D♭ E♭ F G B𝄫 C♭" },
        .{ .root = "C", .expected = "C D E F♯ G♯ B♭ C" },
        .{ .root = "C♯", .expected = "C♯ D♯ E♯ F𝄪 G𝄪 B C♯" },
        .{ .root = "D♭", .expected = "D♭ E♭ F G A C♭ D♭" },
        .{ .root = "D", .expected = "D E F♯ G♯ A♯ C D" },
        .{ .root = "D♯", .expected = "D♯ E♯ F𝄪 G𝄪 A𝄪 C♯ D♯" },
        .{ .root = "E♭", .expected = "E♭ F G A B D♭ E♭" },
        .{ .root = "E", .expected = "E F♯ G♯ A♯ B♯ D E" },
        .{ .root = "E♯", .expected = "E♯ F𝄪 G𝄪 A𝄪 B𝄪 D♯ E♯" },
        .{ .root = "F♭", .expected = "F♭ G♭ A♭ B♭ C E𝄫 F♭" },
        .{ .root = "F", .expected = "F G A B C♯ E♭ F" },
        .{ .root = "F♯", .expected = "F♯ G♯ A♯ B♯ C𝄪 E F♯" },
        .{ .root = "G♭", .expected = "G♭ A♭ B♭ C D F♭ G♭" },
        .{ .root = "G", .expected = "G A B C♯ D♯ F G" },
        .{ .root = "G♯", .expected = "G♯ A♯ B♯ C𝄪 D𝄪 F♯ G♯" },
        .{ .root = "A♭", .expected = "A♭ B♭ C D E G♭ A♭" },
        .{ .root = "A", .expected = "A B C♯ D♯ E♯ G A" },
        .{ .root = "A♯", .expected = "A♯ B♯ C𝄪 D𝄪 E𝄪 G♯ A♯" },
        .{ .root = "B♭", .expected = "B♭ C D E F♯ A♭ B♭" },
        .{ .root = "B", .expected = "B C♯ D♯ E♯ F𝄪 A B" },
        .{ .root = "B♯", .expected = "B♯ C𝄪 D𝄪 E𝄪 G♯ A♯ B♯" },
    }) |case| {
        const root = try Note.parse(case.root);
        const scale = generator.scale(root);
        var printer = Printer(7).init(scale);
        //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ .generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}
