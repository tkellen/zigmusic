const std = @import("std");
const testing = std.testing;
const m = @import("./main.zig");

pub fn validate(root: m.Note, mode: m.Mode, expected: []const m.Note) !void {
    var buffer: [16]m.Note = undefined;
    const result = mode.scale(root, &buffer);

    if (result.len != expected.len) {
        std.debug.print("Length mismatch: expected {}, got {}\n", .{ expected.len, result.len });
        return error.ValidationError;
    }

    for (result, expected, 0..) |actual, exp, index| {
        if (actual.name != exp.name) {
            std.debug.print("Mismatch at index {}: Expected name {s}, found {s}\n", .{ index, @tagName(exp.name), @tagName(actual.name) });
            return error.ValidationError;
        }

        if (actual.accidental != exp.accidental) {
            std.debug.print("Mismatch at index {}: Expected accidental {s}, found {s}\n", .{ index, @tagName(exp.accidental), @tagName(actual.accidental) });
            return error.ValidationError;
        }
    }
}
