const std = @import("std");
const Note = @import("note.zig").Note;

pub fn Printer(comptime N: usize) type {
    const MaxLen = N * (5 + 1); // +1 for space

    return struct {
        notes: [N]Note,
        buffer: [MaxLen]u8 = undefined,
        used: usize = 0,
        pub fn init(input: [N]Note) @This() {
            return .{ .notes = input };
        }
        pub fn string(self: *@This()) []const u8 {
            var index: usize = 0;
            var buffer: [5]u8 = undefined;
            for (self.notes, 0..) |note, i| {
                const name = note.name(&buffer);
                std.mem.copyForwards(u8, self.buffer[index..][0..name.len], name);
                index += name.len;
                if (i != self.notes.len - 1) {
                    self.buffer[index] = ' ';
                    index += 1;
                }
            }
            self.used = index;
            return self.buffer[0..index];
        }
    };
}
