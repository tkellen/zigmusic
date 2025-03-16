const std = @import("std");
const testing = std.testing;
const music = @import("./index.zig");

pub fn validate(root: []const u8, mode: music.scales.Mode, expected: []const u8) !void {
    var buffer: [16]music.notes.Note = undefined;
    var actualBuffer: [128]u8 = undefined;

    const key = try music.notes.Note.parse(root);
    const scale = music.scales.Scale.build(key, mode, &buffer);

    var fbs = std.io.fixedBufferStream(&actualBuffer);
    const writer = fbs.writer();

    for (scale.notes, 0..) |note, idx| {
        if (idx > 0) try writer.writeAll(" ");
        try writer.print("{s}{s}", .{ note.natural.name(), note.accidental.name() });
    }

    const actualString = fbs.getWritten();
    try std.testing.expectEqualStrings(expected, actualString);
}
