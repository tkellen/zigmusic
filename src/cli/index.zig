const std = @import("std");
pub const Note = @import("note.zig").NoteCLI;
pub const Scale = @import("scale.zig").ScaleCLI;
pub const Progression = @import("progression.zig").ProgressionCLI;

pub fn usage() void {
    std.debug.print("Usage:\n", .{});
    std.debug.print("  zigmusic scale <scale> <key>\n", .{});
    std.debug.print("  zigmusic scale <scale> <key> progression <progression>\n", .{});
}
