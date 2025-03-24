const std = @import("std");
const Letter = @import("letter.zig").Letter;

pub const Accidental = enum(i8) {
    DoubleFlat,
    Flat,
    Natural,
    Sharp,
    DoubleSharp,

    pub const min = -2;
    pub const max = 2;

    pub fn offset(self: Accidental) i8 {
        return switch (self) {
            .DoubleFlat => -2,
            .Flat => -1,
            .Natural => 0,
            .Sharp => 1,
            .DoubleSharp => 2,
        };
    }

    pub fn fromOffset(input: i8) Accidental {
        var normalized = input;
        while (normalized > max) normalized -= 12;
        while (normalized < min) normalized += 12;
        return switch (normalized) {
            -2 => .DoubleFlat,
            -1 => .Flat,
            0 => .Natural,
            1 => .Sharp,
            2 => .DoubleSharp,
            else => unreachable, // This should never be reached if we normalized correctly
        };
    }

    pub fn validOffset(input: i8) bool {
        return input >= min and input <= max;
    }

    pub fn name(self: Accidental) []const u8 {
        return switch (self) {
            .Natural => "",
            .Sharp => "♯",
            .Flat => "♭",
            .DoubleSharp => "𝄪",
            .DoubleFlat => "𝄫",
        };
    }

    pub fn parse(input: []const u8) ?Accidental {
        const view = std.unicode.Utf8View.init(input) catch return null;
        var accidentals = view.iterator();
        var flats: i8 = 0;
        var sharps: i8 = 0;
        while (accidentals.nextCodepoint()) |code_point| {
            switch (code_point) {
                '♮' => return .Natural,
                'b', '♭' => flats += 1,
                '#', '♯' => sharps += 1,
                '𝄫' => flats += 2,
                'x', '𝄪' => sharps += 2,
                else => return null,
            }
        }
        if (flats > 0 and sharps > 0) {
            return null;
        }
        return .fromOffset(sharps - flats);
    }
};

test "Accidental.parse" {
    const cases = [_]struct {
        input: []const u8,
        expected: ?Accidental,
    }{
        .{ .input = "♭", .expected = .Flat },
        .{ .input = "b", .expected = .Flat },
        .{ .input = "♭♭", .expected = .DoubleFlat },
        .{ .input = "bb", .expected = .DoubleFlat },
        .{ .input = "𝄫", .expected = .DoubleFlat },
        .{ .input = "♯", .expected = .Sharp },
        .{ .input = "#", .expected = .Sharp },
        .{ .input = "♯♯", .expected = .DoubleSharp },
        .{ .input = "##", .expected = .DoubleSharp },
        .{ .input = "𝄪", .expected = .DoubleSharp },
        .{ .input = "x", .expected = .DoubleSharp },
        .{ .input = "♮", .expected = .Natural },
        .{ .input = "", .expected = .Natural },
        .{ .input = "♯𝄫", .expected = null },
        .{ .input = "y", .expected = null },
    };
    for (cases) |case| {
        const result = Accidental.parse(case.input);
        try std.testing.expectEqual(result, case.expected);
    }
}
