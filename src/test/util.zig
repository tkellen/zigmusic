const std = @import("std");
const testing = std.testing;
const music = @import("music");

pub fn validate(root: music.notes.Note, mode: music.scales.Mode, expected: []const music.notes.Note) !void {
    var buffer: [16]music.notes.Note = undefined;
    const result = mode.scale(root, &buffer);

    try testing.expectEqual(expected.len, result.len);

    for (result, expected, 0..) |actual, exp, index| {
        try testing.expectEqual(exp.name, actual.name);
        try testing.expectEqual(exp.accidental, actual.accidental);
    }
}
