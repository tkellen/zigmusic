const std = @import("std");
const Note = @import("note.zig").Note;

pub fn Phrase(comptime N: usize) type {
    const MaxLen = N * (5 + 1); // +1 for space

    return struct {
        content: [N]Note,
        buf: [MaxLen]u8 = undefined,
        len: usize = 0,
        pub fn init(input: [N]Note) @This() {
            var phrase = @This(){
                .content = input,
                .buf = undefined,
                .len = 0,
            };
            var index: usize = 0;
            for (input, 0..) |note, i| {
                const name = note.name();
                std.mem.copyForwards(u8, phrase.buf[index .. index + name.len], name);
                index += name.len;
                if (i != input.len - 1) {
                    phrase.buf[index] = ' ';
                    index += 1;
                }
            }
            phrase.len = index;
            return phrase;
        }

        pub fn notes(self: *const @This()) []const u8 {
            return self.buf[0..self.len];
        }
    };
}
