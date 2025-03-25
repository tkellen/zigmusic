// const std = @import("std");
// const core = @import("core");
// const Letter = core.Letter;
// const Accidental = core.Accidental;
// const Note = core.Note;
// const Step = core.Step;
// const Enharmonic = core.Enharmonic;
// const Printer = core.Printer;

// pub const MinorBlues = struct {
//     const steps = [6]Step{
//         .Minor3rd,
//         .Whole,
//         .Half,
//         .Half,
//         .Minor3rd,
//         .Whole,
//     };

//     fn pickPattern(root: Note) [7]i8 {
//         const nat = root.natural;
//         const acc = root.accidental;
//         // Use modified pattern when the blue note should have the same natural letter.
//         if (nat == Letter.F or
//             ((nat == Letter.D or nat == Letter.A or nat == Letter.G or nat == Letter.B) and acc == Accidental.Flat))
//         {
//             return .{ 0, 2, 3, 3, 4, 6, 7 };
//         }
//         return .{ 0, 2, 3, 4, 4, 6, 7 };
//     }

//     pub fn build(root: Note) [7]Note {
//         var result: [7]Note = undefined;
//         result[0] = root;
//         // Get the letter pattern offsets for this scale.
//         const letterPattern = pickPattern(root);
//         var currentNote = root;
//         var currentPos = root.chromaticPosition();

//         for (steps, 0..) |step, i| {
//             // Compute the new chromatic position.
//             currentPos = @intCast(@mod(currentPos + step.chromaticInterval(), 12));

//             // Compute the expected natural letter for this degree.
//             const letterDelta = letterPattern[i + 1] - letterPattern[i];
//             const expectedNatural = currentNote.natural.step(letterDelta);

//             // Get all enharmonic equivalents for the target position.
//             var buffer: [3]Note = undefined;
//             const count = Enharmonic.equivalents(currentPos, &buffer);
//             var chosen: Note = buffer[0];
//             var foundMatch = false;
//             for (buffer[0..count]) |candidate| {
//                 if (candidate.natural == expectedNatural) {
//                     chosen = candidate;
//                     foundMatch = true;
//                     break;
//                 }
//             }
//             if (!foundMatch) {
//                 // Fallback: score candidates based on accidental preference.
//                 const preferred = switch (root.accidental) {
//                     .Sharp, .DoubleSharp => Accidental.Sharp,
//                     .Flat, .DoubleFlat => Accidental.Flat,
//                     .Natural => Accidental.Sharp,
//                 };
//                 var bestScore: u8 = 255;
//                 for (buffer[0..count]) |candidate| {
//                     var score: u8 = switch (candidate.accidental) {
//                         .Natural => 0,
//                         .Sharp, .Flat => 2,
//                         else => 3,
//                     };
//                     if (candidate.accidental == preferred) {
//                         score = 1;
//                     }
//                     if (score < bestScore) {
//                         bestScore = score;
//                         chosen = candidate;
//                     }
//                 }
//             }
//             result[i + 1] = chosen;
//             currentNote = chosen;
//         }
//         return result;
//     }
// };

// test "Minor Blues" {
//     const scale = MinorBlues;
//     for ([_]struct { root: []const u8, expected: []const u8 }{
//         .{ .root = "C♭", .expected = "C♭ E𝄫 F♭ G𝄫 G♭ B𝄫 C♭" },
//         .{ .root = "C", .expected = "C E♭ F G♭ G B♭ C" },
//         .{ .root = "C♯", .expected = "C♯ E F♯ G G♯ B C♯" },
//         .{ .root = "D♭", .expected = "D♭ F♭ G♭ G A♭ C♭ D♭" },
//         .{ .root = "D", .expected = "D F G A♭ A C D" },
//         .{ .root = "D♯", .expected = "D♯ F♯ G♯ A A♯ C♯ D♯" },
//         .{ .root = "E♭", .expected = "E♭ G♭ A♭ B B♭ D♭ E♭" },
//         .{ .root = "E", .expected = "E G A B♭ B D E" },
//         .{ .root = "E♯", .expected = "E♯ G♯ A♯ B B♯ D♯ E♯" },
//         .{ .root = "F♭", .expected = "F♭ A𝄫 B𝄫 B♭ C♭ E𝄫 F♭" }, // FAILING
//         .{ .root = "F", .expected = "F A♭ B♭ B C E♭ F" }, // FAILING
//         .{ .root = "F♯", .expected = "F♯ A B C C♯ E F♯" },
//         .{ .root = "G♭", .expected = "G♭ B𝄫 C♭ C D♭ F♭ G♭" }, // FAILING
//         .{ .root = "G", .expected = "G B♭ C D♭ D F G" },
//         .{ .root = "G♯", .expected = "G♯ B C♯ D D♯ F♯ G♯" },
//         .{ .root = "A♭", .expected = "A♭ C♭ D♭ D E♭ G♭ A♭" },
//         .{ .root = "A", .expected = "A C D E♭ E G A" },
//         .{ .root = "A♯", .expected = "A♯ C♯ D♯ E E♯ G♯ A♯" },
//         .{ .root = "B♭", .expected = "B♭ D♭ E♭ E F A♭ B♭" }, // FAILING
//         .{ .root = "B", .expected = "B D E F F♯ A B" }, // FAILING
//         .{ .root = "B♯", .expected = "B♯ D♯ E♯ F♯ F𝄪 A♯ B♯" },
//     }) |case| {
//         const root = try Note.parse(case.root);
//         const notes = scale.build(root);
//         var printer = Printer(7).init(notes);
//         //std.debug.print("{s}: {s}{s} | got: {s} expected: {s}\n", .{ generator.name(), root.natural.name(), root.accidental.name(), printer.string(), case.expected });
//         try std.testing.expectEqualStrings(case.expected, printer.string());
//     }
// }
