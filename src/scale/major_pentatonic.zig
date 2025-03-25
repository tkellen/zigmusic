const std = @import("std");
const core = @import("core");
const Letter = core.Letter;
const Accidental = core.Accidental;
const Note = core.Note;
const Step = core.Step;
const Printer = core.Printer;

pub const MajorPentatonic = struct {
    const steps = [5]core.Step{
        .Whole,
        .Whole,
        .Minor3rd,
        .Whole,
        .Minor3rd,
    };
    const letterPattern: [6]i8 = .{ 0, 1, 2, 4, 5, 7 };
    pub fn build(root: Note) [6]Note {
        var result: [6]Note = undefined;
        result[0] = root;
        var note = root;

        for (steps, 0..) |step, i| {
            const interval = letterPattern[i + 1] - letterPattern[i];
            note = Note.spell(
                note.natural.step(interval),
                step.chromaticPositionFrom(note),
            );
            result[i + 1] = note;
        }
        return result;
    }
};

test "Major Pentatonic" {
    const scale = MajorPentatonic;
    for ([_]struct { root: []const u8, expected: []const u8 }{
        .{ .root = "C♭", .expected = "C♭ D♭ E♭ G♭ A♭ C♭" },
        .{ .root = "C", .expected = "C D E G A C" },
        .{ .root = "C♯", .expected = "C♯ D♯ E♯ G♯ A♯ C♯" },
        .{ .root = "D♭", .expected = "D♭ E♭ F A♭ B♭ D♭" },
        .{ .root = "D", .expected = "D E F♯ A B D" },
        .{ .root = "D♯", .expected = "D♯ E♯ F𝄪 A♯ B♯ D♯" },
        .{ .root = "E♭", .expected = "E♭ F G B♭ C E♭" },
        .{ .root = "E", .expected = "E F♯ G♯ B C♯ E" },
        .{ .root = "E♯", .expected = "E♯ F𝄪 G𝄪 B♯ C𝄪 E♯" },
        .{ .root = "F♭", .expected = "F♭ G♭ A♭ C♭ D♭ F♭" },
        .{ .root = "F", .expected = "F G A C D F" },
        .{ .root = "F♯", .expected = "F♯ G♯ A♯ C♯ D♯ F♯" },
        .{ .root = "G♭", .expected = "G♭ A♭ B♭ D♭ E♭ G♭" },
        .{ .root = "G", .expected = "G A B D E G" },
        .{ .root = "G♯", .expected = "G♯ A♯ B♯ D♯ E♯ G♯" },
        .{ .root = "A♭", .expected = "A♭ B♭ C E♭ F A♭" },
        .{ .root = "A", .expected = "A B C♯ E F♯ A" },
        .{ .root = "A♯", .expected = "A♯ B♯ C𝄪 E♯ F𝄪 A♯" },
        .{ .root = "B♭", .expected = "B♭ C D F G B♭" },
        .{ .root = "B", .expected = "B C♯ D♯ F♯ G♯ B" },
        .{ .root = "B♯", .expected = "B♯ C𝄪 D𝄪 F𝄪 G𝄪 B♯" },
    }) |case| {
        const root = try Note.parse(case.root);
        const notes = scale.build(root);
        var printer = Printer(6).init(notes);
        //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ .generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}
