const std = @import("std");
const testing = std.testing;
const mt = @import("./main.zig");

pub fn validate(root: mt.Note, steps: []const u8, expected: []const mt.Note) !void {
    var buffer: [16]mt.Note = undefined;
    const scale = mt.Scale.new(root, steps);
    const result = scale.compute(&buffer);

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
