const std = @import("std");
const core = @import("core");
const Letter = core.Letter;
const Accidental = core.Accidental;
const Note = core.Note;
const Step = core.Step;
const Enharmonic = core.Enharmonic;
const Printer = core.Printer;

pub const Chromatic = struct {
    pub const steps = [12]core.Step{
        .Half, .Half, .Half, .Half, .Half, .Half,
        .Half, .Half, .Half, .Half, .Half, .Half,
    };

    pub fn name() []const u8 {
        return "Chromatic";
    }

    pub fn scale(root: core.Note) ![13]core.Note {
        var result: [13]core.Note = undefined;
        result[0] = root;
        // Choose a preferred accidental based on the root.
        const preferred = switch (root.accidental) {
            .Sharp, .DoubleSharp => core.Accidental.Sharp,
            .Flat, .DoubleFlat => core.Accidental.Flat,
            .Natural => core.Accidental.Sharp,
        };

        var currentPos = root.chromaticPosition();
        // For each step, update the position and choose the best enharmonic equivalent.
        for (steps, 0..) |step, i| {
            currentPos = @intCast(@mod(currentPos + step.chromaticInterval(), 12));
            var bestScore: u8 = 255;
            var buffer: [3]Note = undefined;
            // Get the enharmonic equivalents for this chromatic position.
            const found = Enharmonic.equivalents(currentPos, &buffer);
            const enharmonics = buffer[0..found];
            // Select a candidate—start with the first.
            var chosen: Note = enharmonics[0];
            // Evaluate each candidate with a score: lower is better.
            for (enharmonics) |candidate| {
                var score: u8 = switch (candidate.accidental) {
                    .Natural => 0,
                    .Sharp, .Flat => 2,
                    else => 3,
                };
                // If the candidate matches the preferred accidental, adjust its score.
                if (candidate.accidental == preferred) {
                    score = 1;
                }
                if (score < bestScore) {
                    bestScore = score;
                    chosen = candidate;
                }
            }
            result[i + 1] = chosen;
        }
        // Force the octave to be the same as the root.
        result[12] = root;
        return result;
    }
};

// test data from: https://everythingmusic.com/learn/music-theory/scales
test "Chromatic" {
    const generator = Chromatic;
    for ([_]struct { root: []const u8, expected: []const u8 }{
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
        const scale = try generator.scale(root);
        var printer = Printer(13).init(scale);
        //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}
