const std = @import("std");
const music = @import("music");
const Pitch = music.notes.Letter;
const Accidental = music.notes.Accidental;
const Note = music.notes.Note;
const Mode = music.scales.Mode;
const Scale = music.scales.Scale;
const Chord = music.chords.Chord;

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
    const scale = Scale.build(key, mode, &buffer);

    std.debug.print("{s}{s} {s}: ", .{ key.natural.name(), key.accidental.name(), mode.name() });
    for (scale.notes) |note| {
        std.debug.print("{s}{s} ", .{ note.natural.name(), note.accidental.name() });
    }
    std.debug.print("\n", .{});

    var majorBuffer: [16]Note = undefined;
    const major = scale.chord(Chord.Major, &majorBuffer);
    std.debug.print("Major: ", .{});
    for (major) |note| {
        std.debug.print("{s}{s} ", .{ note.natural.name(), note.accidental.name() });
    }
    std.debug.print("\n", .{});

    var minorBuffer: [16]Note = undefined;
    const minor = scale.chord(Chord.Minor, &minorBuffer);
    std.debug.print("Minor: ", .{});
    for (minor) |note| {
        std.debug.print("{s}{s} ", .{ note.natural.name(), note.accidental.name() });
    }
    std.debug.print("\n", .{});

    var major7Buffer: [16]Note = undefined;
    const major7 = scale.chord(Chord.Major7, &major7Buffer);
    std.debug.print("Major 7: ", .{});
    for (major7) |note| {
        std.debug.print("{s}{s} ", .{ note.natural.name(), note.accidental.name() });
    }
    std.debug.print("\n", .{});

    var minor7Buffer: [16]Note = undefined;
    const minor7 = scale.chord(Chord.Minor, &minor7Buffer);
    std.debug.print("Minor 7: ", .{});
    for (minor7) |note| {
        std.debug.print("{s}{s} ", .{ note.natural.name(), note.accidental.name() });
    }
    std.debug.print("\n", .{});
}
