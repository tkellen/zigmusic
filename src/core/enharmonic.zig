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

test "equivalents" {
    inline for ([_]struct {
        note: []const u8,
        expected: []const u8,
        count: usize,
    }{
        .{ .note = "A", .expected = "G𝄪 A B𝄫", .count = 3 },
        .{ .note = "A♭", .expected = "G♯ A♭", .count = 2 },
        .{ .note = "A♯", .expected = "C𝄫 A♯ B♭", .count = 3 },
        .{ .note = "A𝄪", .expected = "C♭ A𝄪 B", .count = 3 },
        .{ .note = "A𝄫", .expected = "F𝄪 G A𝄫", .count = 3 },
        .{ .note = "B", .expected = "C♭ A𝄪 B", .count = 3 },
        .{ .note = "B♭", .expected = "C𝄫 A♯ B♭", .count = 3 },
        .{ .note = "B♯", .expected = "C D𝄫 B♯", .count = 3 },
        .{ .note = "B𝄪", .expected = "C♯ D♭ B𝄪", .count = 3 },
        .{ .note = "B𝄫", .expected = "G𝄪 A B𝄫", .count = 3 },
        .{ .note = "C", .expected = "C D𝄫 B♯", .count = 3 },
        .{ .note = "C♭", .expected = "C♭ A𝄪 B", .count = 3 },
        .{ .note = "C♯", .expected = "C♯ D♭ B𝄪", .count = 3 },
        .{ .note = "C𝄪", .expected = "C𝄪 D E𝄫", .count = 3 },
        .{ .note = "C𝄫", .expected = "C𝄫 A♯ B♭", .count = 3 },
        .{ .note = "D", .expected = "C𝄪 D E𝄫", .count = 3 },
        .{ .note = "D♭", .expected = "C♯ D♭ B𝄪", .count = 3 },
        .{ .note = "D♯", .expected = "D♯ E♭ F𝄫", .count = 3 },
        .{ .note = "D𝄪", .expected = "D𝄪 E F♭", .count = 3 },
        .{ .note = "D𝄫", .expected = "C D𝄫 B♯", .count = 3 },
        .{ .note = "E", .expected = "D𝄪 E F♭", .count = 3 },
        .{ .note = "E♭", .expected = "D♯ E♭ F𝄫", .count = 3 },
        .{ .note = "E♯", .expected = "E♯ F G𝄫", .count = 3 },
        .{ .note = "E𝄪", .expected = "E𝄪 F♯ G♭", .count = 3 },
        .{ .note = "E𝄫", .expected = "C𝄪 D E𝄫", .count = 3 },
        .{ .note = "F", .expected = "E♯ F G𝄫", .count = 3 },
        .{ .note = "F♭", .expected = "D𝄪 E F♭", .count = 3 },
        .{ .note = "F♯", .expected = "E𝄪 F♯ G♭", .count = 3 },
        .{ .note = "F𝄪", .expected = "F𝄪 G A𝄫", .count = 3 },
        .{ .note = "F𝄫", .expected = "D♯ E♭ F𝄫", .count = 3 },
        .{ .note = "G", .expected = "F𝄪 G A𝄫", .count = 3 },
        .{ .note = "G♭", .expected = "E𝄪 F♯ G♭", .count = 3 },
        .{ .note = "G♯", .expected = "G♯ A♭", .count = 2 },
        .{ .note = "G𝄪", .expected = "G𝄪 A B𝄫", .count = 3 },
        .{ .note = "G𝄫", .expected = "E♯ F G𝄫", .count = 3 },
    }) |case| {
        const check = try Note.parse(case.note);
        var result: [case.count]Note = undefined;
        _ = equivalents(check.chromaticPosition(), &result);
        var printer = Printer(case.count).init(result);
        try std.testing.expectEqualStrings(case.expected, printer.string());
    }
}
