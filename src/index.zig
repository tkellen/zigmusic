const std = @import("std");
const cli = @import("cli");

pub fn main() !void {
    const args = std.process.argsAlloc(std.heap.page_allocator) catch unreachable;
    defer std.process.argsFree(std.heap.page_allocator, args);

    if (args.len != 4) {
        std.debug.print("Usage: music scale [Type] [Key]\n", .{});
        return;
    }

    if (!std.mem.eql(u8, args[1], "scale")) {
        std.debug.print("Unknown command: {s}\n", .{args[1]});
        return;
    }

    try cli.Scale.print(args[2], args[3]);
}
