const std = @import("std");
const note = @import("note.zig");

pub const Printer = struct {
    notes: []const note.Note,
    buffer: []u8,

    pub fn init(allocator: std.mem.Allocator, notes: []const note.Note) !Printer {
        var buffer_size: usize = 0;
        for (notes) |n| {
            buffer_size += n.natural.name().len;
            buffer_size += n.accidental.name().len;
            buffer_size += 1; // space or null terminator
        }

        const buffer = try allocator.alloc(u8, buffer_size);
        return Printer{
            .notes = notes,
            .buffer = buffer,
        };
    }

    pub fn deinit(self: *Printer, allocator: std.mem.Allocator) void {
        allocator.free(self.buffer);
    }

    pub fn string(self: *Printer) []const u8 {
        var fbs = std.io.fixedBufferStream(self.buffer);
        const writer = fbs.writer();
        for (self.notes, 0..) |n, i| {
            if (i != 0) {
                _ = writer.writeAll(" ") catch unreachable;
            }
            _ = writer.print("{s}{s}", .{ n.natural.name(), n.accidental.name() }) catch unreachable;
        }
        return fbs.getWritten();
    }
};
