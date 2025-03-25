const std = @import("std");
const core = @import("core");
const Letter = core.Letter;
const Accidental = core.Accidental;
const Note = core.Note;
const Step = core.Step;
const Printer = core.Printer;

pub const MajorBlues = struct {
    const steps = [6]Step{
        .Whole,
        .Half,
        .Half,
        .Minor3rd,
        .Whole,
        .Minor3rd,
    };

    const letterPattern: [7]i8 = .{ 0, 1, 2, 2, 4, 5, 7 };
    pub fn build(root: Note) [7]Note {
        var result: [7]Note = undefined;
        result[0] = root;
        var note = root;
        for (steps, 0..) |step, i| {
            const letterDelta = letterPattern[i + 1] - letterPattern[i];
            note = Note.spell(
                note.natural.step(letterDelta),
                step.chromaticPositionFrom(note),
            );
            result[i + 1] = note;
        }

        return result;
    }
};

test "Major Blues" {
    const scale = MajorBlues;
    for ([_]struct { root: []const u8, expected: []const u8 }{
        .{ .root = "C♭", .expected = "C♭ D♭ E𝄫 E♭ G♭ A♭ C♭" },
        .{ .root = "C", .expected = "C D E♭ E G A C" },
        .{ .root = "C♯", .expected = "C♯ D♯ E E♯ G♯ A♯ C♯" },
        .{ .root = "D♭", .expected = "D♭ E♭ F♭ F A♭ B♭ D♭" },
        .{ .root = "D", .expected = "D E F F♯ A B D" },
        .{ .root = "D♯", .expected = "D♯ E♯ F♯ F𝄪 A♯ B♯ D♯" },
        .{ .root = "E♭", .expected = "E♭ F G♭ G B♭ C E♭" },
        .{ .root = "E", .expected = "E F♯ G G♯ B C♯ E" },
        .{ .root = "E♯", .expected = "E♯ F𝄪 G♯ G𝄪 B♯ C𝄪 E♯" },
        .{ .root = "F♭", .expected = "F♭ G♭ A𝄫 A♭ C♭ D♭ F♭" },
        .{ .root = "F", .expected = "F G A♭ A C D F" },
        .{ .root = "F♯", .expected = "F♯ G♯ A A♯ C♯ D♯ F♯" },
        .{ .root = "G♭", .expected = "G♭ A♭ B𝄫 B♭ D♭ E♭ G♭" },
        .{ .root = "G", .expected = "G A B♭ B D E G" },
        .{ .root = "G♯", .expected = "G♯ A♯ B B♯ D♯ E♯ G♯" },
        .{ .root = "A♭", .expected = "A♭ B♭ C♭ C E♭ F A♭" },
        .{ .root = "A", .expected = "A B C C♯ E F♯ A" },
        .{ .root = "A♯", .expected = "A♯ B♯ C♯ C𝄪 E♯ F𝄪 A♯" },
        .{ .root = "B♭", .expected = "B♭ C D♭ D F G B♭" },
        .{ .root = "B", .expected = "B C♯ D D♯ F♯ G♯ B" },
        .{ .root = "B♯", .expected = "B♯ C𝄪 D♯ D𝄪 F𝄪 G𝄪 B♯" },
    }) |case| {
        const root = try Note.parse(case.root);
        const notes = scale.build(root);
        var printer = Printer(7).init(notes);
        //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}
