const std = @import("std");
const music = @import("music");
const Note = music.notes.Note;
const Mode = music.modes.Mode;
const Scale = music.scales.Scale;

pub fn main() !void {
    const args = std.process.argsAlloc(std.heap.page_allocator) catch unreachable;
    defer std.process.argsFree(std.heap.page_allocator, args);

    if (args.len != 4) {
        std.debug.print("Usage: music scale [Mode] [Note]\n", .{});
        return;
    }

    if (!std.mem.eql(u8, args[1], "scale")) {
        std.debug.print("Unknown command: {s}\n", .{args[1]});
        return;
    }

    const mode = Mode.parse(args[2]) orelse {
        std.debug.print("Invalid mode: {s}\n", .{args[2]});
        std.debug.print("Valid modes:\n", .{});
        for (std.meta.tags(Mode)) |m| {
            std.debug.print("{s}\n", .{@tagName(m)});
        }
        return;
    };

    const key = try Note.parse(args[3]);

    var buffer: [16]Note = undefined;
    const scale = Scale{ .mode = mode };
    const notes = scale.build(key, &buffer);

    std.debug.print("{s}{s} {s}: ", .{ key.natural.name(), key.accidental.name(), mode.name() });
    for (notes) |note| {
        std.debug.print("{s}{s} ", .{ note.natural.name(), note.accidental.name() });
    }
    std.debug.print("\n", .{});
}
