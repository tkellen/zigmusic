const std = @import("std");
const core = @import("core");
const Letter = core.Letter;
const Accidental = core.Accidental;
const Note = core.Note;
const Step = core.Step;
const Phrase = core.Phrase;

pub const MinorPentatonic = struct {
    const steps = [5]core.Step{
        .Minor3rd,
        .Whole,
        .Whole,
        .Minor3rd,
        .Whole,
    };

    pub const letterPattern: [6]i8 = .{ 0, 2, 3, 4, 6, 7 };
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

test "Minor Pentatonic" {
    const scale = MinorPentatonic;
    for ([_]struct { root: []const u8, expected: []const u8 }{
        .{ .root = "C♭", .expected = "C♭ E𝄫 F♭ G♭ B𝄫 C♭" },
        .{ .root = "C", .expected = "C E♭ F G B♭ C" },
        .{ .root = "C♯", .expected = "C♯ E F♯ G♯ B C♯" },
        .{ .root = "D♭", .expected = "D♭ F♭ G♭ A♭ C♭ D♭" },
        .{ .root = "D", .expected = "D F G A C D" },
        .{ .root = "D♯", .expected = "D♯ F♯ G♯ A♯ C♯ D♯" },
        .{ .root = "E♭", .expected = "E♭ G♭ A♭ B♭ D♭ E♭" },
        .{ .root = "E", .expected = "E G A B D E" },
        .{ .root = "E♯", .expected = "E♯ G♯ A♯ B♯ D♯ E♯" },
        .{ .root = "F♭", .expected = "F♭ A𝄫 B𝄫 C♭ E𝄫 F♭" },
        .{ .root = "F", .expected = "F A♭ B♭ C E♭ F" },
        .{ .root = "F♯", .expected = "F♯ A B C♯ E F♯" },
        .{ .root = "G♭", .expected = "G♭ B𝄫 C♭ D♭ F♭ G♭" },
        .{ .root = "G", .expected = "G B♭ C D F G" },
        .{ .root = "G♯", .expected = "G♯ B C♯ D♯ F♯ G♯" },
        .{ .root = "A♭", .expected = "A♭ C♭ D♭ E♭ G♭ A♭" },
        .{ .root = "A", .expected = "A C D E G A" },
        .{ .root = "A♯", .expected = "A♯ C♯ D♯ E♯ G♯ A♯" },
        .{ .root = "B♭", .expected = "B♭ D♭ E♭ F A♭ B♭" },
        .{ .root = "B", .expected = "B D E F♯ A B" },
        .{ .root = "B♯", .expected = "B♯ D♯ E♯ F𝄪 A♯ B♯" },
    }) |case| {
        const tonic = try Note.parse(case.root);
        const actual = Phrase(6).init(scale.build(tonic));
        //std.debug.print("{s}: {s} | got: {s} expected: {s}\n", .{ .generator.name(), root.name, actual.notes(), case.expected });
        try std.testing.expectEqualStrings(case.expected, actual.notes());
    }
}
