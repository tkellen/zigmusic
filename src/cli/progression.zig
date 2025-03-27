const std = @import("std");
const Progression = @import("progression");
const ScaleCLI = @import("scale.zig").ScaleCLI;
const NoteCLI = @import("note.zig").NoteCLI;
const Note = @import("core").Note;
const Scale = @import("scale");

pub const ProgressionCLI = enum {
    TwelveBarBlues,

    pub fn parse(findProgression: []const u8) !ProgressionCLI {
        if (std.meta.stringToEnum(ProgressionCLI, findProgression)) |progression| {
            return progression;
        } else {
            std.debug.print("Invalid progression, options are:\n", .{});
            for (std.meta.tags(ProgressionCLI)) |entry| {
                std.debug.print("{s}\n", .{@tagName(entry)});
            }
        }
        return error.InvalidProgression;
    }

    pub fn build(self: ProgressionCLI, notes: []const Note, buffer: []Note) usize {
        const result = switch (self) {
            .TwelveBarBlues => Progression.TwelveBarBlues.build(notes)[0..],
        };
        const count = result.len;
        std.mem.copyForwards(Note, buffer[0..count], result);
        return count;
    }
};
