const std = @import("std");
const testing = std.testing;
const util = @import("./util.zig");

const music = @import("music");
const Pitch = music.notes.Pitch;
const Accidental = music.notes.Accidental;
const Note = music.notes.Note;
const Mode = music.modes.Mode;

test "C Aeolian Minor" {
    const key = Note{ .pitch = .C, .accidental = .Natural };
    const expected = &[_]Note{
        Note{ .pitch = .C, .accidental = .Natural },
        Note{ .pitch = .D, .accidental = .Natural },
        Note{ .pitch = .E, .accidental = .Flat },
        Note{ .pitch = .F, .accidental = .Natural },
        Note{ .pitch = .G, .accidental = .Natural },
        Note{ .pitch = .A, .accidental = .Flat },
        Note{ .pitch = .B, .accidental = .Flat },
        Note{ .pitch = .C, .accidental = .Natural },
    };
    try util.validate(key, Mode.Aeolian_Minor, expected);
}

test "D Aeolian Minor" {
    const key = Note{ .pitch = .D, .accidental = .Natural };
    const expected = &[_]Note{
        Note{ .pitch = .D, .accidental = .Natural },
        Note{ .pitch = .E, .accidental = .Natural },
        Note{ .pitch = .F, .accidental = .Natural },
        Note{ .pitch = .G, .accidental = .Natural },
        Note{ .pitch = .A, .accidental = .Natural },
        Note{ .pitch = .B, .accidental = .Flat },
        Note{ .pitch = .C, .accidental = .Natural },
        Note{ .pitch = .D, .accidental = .Natural },
    };
    try util.validate(key, Mode.Aeolian_Minor, expected);
}

test "E Aeolian Minor" {
    const key = Note{ .pitch = .E, .accidental = .Natural };
    const expected = &[_]Note{
        Note{ .pitch = .E, .accidental = .Natural },
        Note{ .pitch = .F, .accidental = .Sharp },
        Note{ .pitch = .G, .accidental = .Natural },
        Note{ .pitch = .A, .accidental = .Natural },
        Note{ .pitch = .B, .accidental = .Natural },
        Note{ .pitch = .C, .accidental = .Natural },
        Note{ .pitch = .D, .accidental = .Natural },
        Note{ .pitch = .E, .accidental = .Natural },
    };
    try util.validate(key, Mode.Aeolian_Minor, expected);
}

test "F Aeolian Minor" {
    const key = Note{ .pitch = .F, .accidental = .Natural };
    const expected = &[_]Note{
        Note{ .pitch = .F, .accidental = .Natural },
        Note{ .pitch = .G, .accidental = .Natural },
        Note{ .pitch = .A, .accidental = .Flat },
        Note{ .pitch = .B, .accidental = .Flat },
        Note{ .pitch = .C, .accidental = .Natural },
        Note{ .pitch = .D, .accidental = .Flat },
        Note{ .pitch = .E, .accidental = .Flat },
        Note{ .pitch = .F, .accidental = .Natural },
    };
    try util.validate(key, Mode.Aeolian_Minor, expected);
}

test "G Aeolian Minor" {
    const key = Note{ .pitch = .G, .accidental = .Natural };
    const expected = &[_]Note{
        Note{ .pitch = .G, .accidental = .Natural },
        Note{ .pitch = .A, .accidental = .Natural },
        Note{ .pitch = .B, .accidental = .Flat },
        Note{ .pitch = .C, .accidental = .Natural },
        Note{ .pitch = .D, .accidental = .Natural },
        Note{ .pitch = .E, .accidental = .Flat },
        Note{ .pitch = .F, .accidental = .Natural },
        Note{ .pitch = .G, .accidental = .Natural },
    };
    try util.validate(key, Mode.Aeolian_Minor, expected);
}

test "A Aeolian Minor" {
    const key = Note{ .pitch = .A, .accidental = .Natural };
    const expected = &[_]Note{
        Note{ .pitch = .A, .accidental = .Natural },
        Note{ .pitch = .B, .accidental = .Natural },
        Note{ .pitch = .C, .accidental = .Natural },
        Note{ .pitch = .D, .accidental = .Natural },
        Note{ .pitch = .E, .accidental = .Natural },
        Note{ .pitch = .F, .accidental = .Natural },
        Note{ .pitch = .G, .accidental = .Natural },
        Note{ .pitch = .A, .accidental = .Natural },
    };
    try util.validate(key, Mode.Aeolian_Minor, expected);
}

test "B Aeolian Minor" {
    const key = Note{ .pitch = .B, .accidental = .Natural };
    const expected = &[_]Note{
        Note{ .pitch = .B, .accidental = .Natural },
        Note{ .pitch = .C, .accidental = .Sharp },
        Note{ .pitch = .D, .accidental = .Natural },
        Note{ .pitch = .E, .accidental = .Natural },
        Note{ .pitch = .F, .accidental = .Sharp },
        Note{ .pitch = .G, .accidental = .Natural },
        Note{ .pitch = .A, .accidental = .Natural },
        Note{ .pitch = .B, .accidental = .Natural },
    };
    try util.validate(key, Mode.Aeolian_Minor, expected);
}
