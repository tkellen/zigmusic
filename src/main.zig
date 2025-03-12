// All of this assumes western music theory where there are 12 notes.

const std = @import("std");
const music = @import("music");
const Pitch = music.notes.Pitch;
const Accidental = music.notes.Accidental;
const Note = music.notes.Note;
const Mode = music.modes.Mode;

pub fn main() !void {
    var buffer: [16]Note = undefined;
    const key = Note{ .pitch = .F, .accidental = .Sharp };
    const mode = music.modes.Mode.Harmonic_Minor;
    const scale = mode.scale(key, &buffer);

    std.debug.print("{s} {s}: ", .{ key.name(), mode.name() });
    for (scale) |note| {
        std.debug.print("{s} ", .{note.name()});
    }
    std.debug.print("\n", .{});

    var chord_buffer: [6]Note = undefined;
    const chord = music.chords.Chord{
        .mode = mode,
        .key = key,
        .chordType = music.chords.Type.Major7,
    };
    const chordNotes = chord.build(&chord_buffer);

    std.debug.print("Chord Notes: ", .{});
    for (chordNotes) |note| {
        std.debug.print("{s} ", .{note.name()});
    }
    std.debug.print("\n", .{});
}
