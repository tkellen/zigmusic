const std = @import("std");
const core = @import("core");
const Note = core.Note;
const Letter = core.Letter;
const Accidental = core.Accidental;

pub const NoteCLI = enum {
    pub fn parse(findNote: []const u8) !Note {
        if (Note.parse(findNote) catch null) |note| {
            return note;
        }
        std.debug.print("Invalid note, options are:\n", .{});
        for (std.meta.tags(Letter)) |entry| {
            std.debug.print("{s}\n", .{@tagName(entry)});
        }
        return error.InvalidNote;
    }
};
