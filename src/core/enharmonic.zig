const std = @import("std");
const Note = @import("note.zig").Note;
const Letter = @import("letter.zig").Letter;
const Accidental = @import("accidental.zig").Accidental;
const Printer = @import("printer.zig").Printer;

pub fn equivalents(position: u8, buffer: []Note) usize {
    const pos: u8 = @intCast(@mod(@as(i8, @intCast(position)), 12));
    var count: usize = 0;
    for (std.meta.tags(Letter)) |letter| {
        for (std.meta.tags(Accidental)) |accidental| {
            const candidate = Note{
                .natural = letter,
                .accidental = accidental,
            };
            if (candidate.chromaticPosition() == pos) {
                buffer[count] = candidate;
                count += 1;
                if (count == buffer.len) break;
            }
        }
        if (count == buffer.len) break;
    }
    return count;
}

// test "equivalents" {
//     for ([_]struct {
//         note: []const u8,
//         expected: []const u8,
//     }{
//         .{ .note = "A", .expected = "G𝄪 A B𝄫" },
//         .{ .note = "A♭", .expected = "G♯ A♭" },
//         .{ .note = "A♯", .expected = "C𝄫 A♯ B♭" },
//         .{ .note = "A𝄪", .expected = "C♭ A𝄪 B" },
//         .{ .note = "A𝄫", .expected = "F𝄪 G A𝄫" },
//         .{ .note = "B", .expected = "C♭ A𝄪 B" },
//         .{ .note = "B♭", .expected = "C𝄫 A♯ B♭" },
//         .{ .note = "B♯", .expected = "C D𝄫 B♯" },
//         .{ .note = "B𝄪", .expected = "C♯ D♭ B𝄪" },
//         .{ .note = "B𝄫", .expected = "G𝄪 A B𝄫" },
//         .{ .note = "C", .expected = "C D𝄫 B♯" },
//         .{ .note = "C♭", .expected = "C♭ A𝄪 B" },
//         .{ .note = "C♯", .expected = "C♯ D♭ B𝄪" },
//         .{ .note = "C𝄪", .expected = "C𝄪 D E𝄫" },
//         .{ .note = "C𝄫", .expected = "C𝄫 A♯ B♭" },
//         .{ .note = "D", .expected = "C𝄪 D E𝄫" },
//         .{ .note = "D♭", .expected = "C♯ D♭ B𝄪" },
//         .{ .note = "D♯", .expected = "D♯ E♭ F𝄫" },
//         .{ .note = "D𝄪", .expected = "D𝄪 E F♭" },
//         .{ .note = "D𝄫", .expected = "C D𝄫 B♯" },
//         .{ .note = "E", .expected = "D𝄪 E F♭" },
//         .{ .note = "E♭", .expected = "D♯ E♭ F𝄫" },
//         .{ .note = "E♯", .expected = "E♯ F G𝄫" },
//         .{ .note = "E𝄪", .expected = "E𝄪 F♯ G♭" },
//         .{ .note = "E𝄫", .expected = "C𝄪 D E𝄫" },
//         .{ .note = "F", .expected = "E♯ F G𝄫" },
//         .{ .note = "F♭", .expected = "D𝄪 E F♭" },
//         .{ .note = "F♯", .expected = "E𝄪 F♯ G♭" },
//         .{ .note = "F𝄪", .expected = "F𝄪 G A𝄫" },
//         .{ .note = "F𝄫", .expected = "D♯ E♭ F𝄫" },
//         .{ .note = "G", .expected = "F𝄪 G A𝄫" },
//         .{ .note = "G♭", .expected = "E𝄪 F♯ G♭" },
//         .{ .note = "G♯", .expected = "G♯ A♭" },
//         .{ .note = "G𝄪", .expected = "G𝄪 A B𝄫" },
//         .{ .note = "G𝄫", .expected = "E♯ F G𝄫" },
//     }) |case| {
//         const check = try Note.parse(case.note);
//         var result: [3]Note = undefined;
//         const found = equivalents(check.chromaticPosition(), &result);
//         var printer = Printer(3).init(result[0..found].*);
//         try std.testing.expectEqualStrings(case.expected, printer.string());
//     }
// }
