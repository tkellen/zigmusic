const std = @import("std");
const cli = @import("cli");
const Note = @import("core").Note;

pub fn main() !void {
    const args = std.process.argsAlloc(std.heap.page_allocator) catch unreachable;
    defer std.process.argsFree(std.heap.page_allocator, args);

    if (args.len > 3) {
        if (cli.Scale.parse(args[2]) catch null) |scale| {
            if (cli.Note.parse(args[3]) catch null) |key| {
                var notes = scale.build(key);
                if (args.len == 6 and std.mem.eql(u8, args[4], "progression")) {
                    if (cli.Progression.parse(args[5]) catch null) |progression| {
                        var buffer: [13]Note = undefined;
                        const len = progression.build(notes, &buffer);
                        notes = buffer[0..len];
                    }
                }
                for (notes) |note| {
                    std.debug.print("{s} ", .{note.name()});
                }
                return;
            }
        }

        return;
    }
    cli.usage();
}
