const std = @import("std");
const testing = std.testing;
const music = @import("music");

pub fn validate(root: music.notes.Note, mode: music.modes.Mode, expected: []const music.notes.Note, allocator: std.mem.Allocator) !void {
    var buffer: [16]music.notes.Note = undefined;
    const result = mode.scale(root, &buffer)[0..expected.len];

    try testing.expectEqualSlices(music.notes.Note, expected, result);

    for (result, expected) |actual, exp| {
        const actual_name = try actual.name(allocator);
        const expected_name = try exp.name(allocator);

        defer allocator.free(actual_name);
        defer allocator.free(expected_name);

        try testing.expectEqualStrings(expected_name, actual_name);
    }
}
