const std = @import("std");
const testing = std.testing;
const util = @import("./util.zig");

const music = @import("music");
const Pitch = music.notes.Pitch;
const Accidental = music.notes.Accidental;
const Note = music.notes.Note;
const Mode = music.modes.Mode;

test "C Lydian Major" {
    const key = Note{ .pitch = .C, .accidental = .Natural };
    const expected = &[_]Note{
        Note{ .pitch = .C, .accidental = .Natural },
        Note{ .pitch = .D, .accidental = .Natural },
        Note{ .pitch = .E, .accidental = .Natural },
        Note{ .pitch = .F, .accidental = .Sharp },
        Note{ .pitch = .G, .accidental = .Natural },
        Note{ .pitch = .A, .accidental = .Natural },
        Note{ .pitch = .B, .accidental = .Natural },
        Note{ .pitch = .C, .accidental = .Natural },
    };
    try util.validate(key, Mode.Lydian_Major, expected);
}

test "D Lydian Major" {
    const key = Note{ .pitch = .D, .accidental = .Natural };
    const expected = &[_]Note{
        Note{ .pitch = .D, .accidental = .Natural },
        Note{ .pitch = .E, .accidental = .Natural },
        Note{ .pitch = .F, .accidental = .Sharp },
        Note{ .pitch = .G, .accidental = .Sharp },
        Note{ .pitch = .A, .accidental = .Natural },
        Note{ .pitch = .B, .accidental = .Natural },
        Note{ .pitch = .C, .accidental = .Sharp },
        Note{ .pitch = .D, .accidental = .Natural },
    };
    try util.validate(key, Mode.Lydian_Major, expected);
}

test "E Lydian Major" {
    const key = Note{ .pitch = .E, .accidental = .Natural };
    const expected = &[_]Note{
        Note{ .pitch = .E, .accidental = .Natural },
        Note{ .pitch = .F, .accidental = .Sharp },
        Note{ .pitch = .G, .accidental = .Sharp },
        Note{ .pitch = .A, .accidental = .Sharp },
        Note{ .pitch = .B, .accidental = .Natural },
        Note{ .pitch = .C, .accidental = .Sharp },
        Note{ .pitch = .D, .accidental = .Sharp },
        Note{ .pitch = .E, .accidental = .Natural },
    };
    try util.validate(key, Mode.Lydian_Major, expected);
}

test "F Lydian Major" {
    const key = Note{ .pitch = .F, .accidental = .Natural };
    const expected = &[_]Note{
        Note{ .pitch = .F, .accidental = .Natural },
        Note{ .pitch = .G, .accidental = .Natural },
        Note{ .pitch = .A, .accidental = .Natural },
        Note{ .pitch = .B, .accidental = .Natural },
        Note{ .pitch = .C, .accidental = .Natural },
        Note{ .pitch = .D, .accidental = .Natural },
        Note{ .pitch = .E, .accidental = .Natural },
        Note{ .pitch = .F, .accidental = .Natural },
    };
    try util.validate(key, Mode.Lydian_Major, expected);
}

test "G Lydian Major" {
    const key = Note{ .pitch = .G, .accidental = .Natural };
    const expected = &[_]Note{
        Note{ .pitch = .G, .accidental = .Natural },
        Note{ .pitch = .A, .accidental = .Natural },
        Note{ .pitch = .B, .accidental = .Natural },
        Note{ .pitch = .C, .accidental = .Sharp },
        Note{ .pitch = .D, .accidental = .Natural },
        Note{ .pitch = .E, .accidental = .Natural },
        Note{ .pitch = .F, .accidental = .Sharp },
        Note{ .pitch = .G, .accidental = .Natural },
    };
    try util.validate(key, Mode.Lydian_Major, expected);
}

test "A Lydian Major" {
    const key = Note{ .pitch = .A, .accidental = .Natural };
    const expected = &[_]Note{
        Note{ .pitch = .A, .accidental = .Natural },
        Note{ .pitch = .B, .accidental = .Natural },
        Note{ .pitch = .C, .accidental = .Sharp },
        Note{ .pitch = .D, .accidental = .Sharp },
        Note{ .pitch = .E, .accidental = .Natural },
        Note{ .pitch = .F, .accidental = .Sharp },
        Note{ .pitch = .G, .accidental = .Sharp },
        Note{ .pitch = .A, .accidental = .Natural },
    };
    try util.validate(key, Mode.Lydian_Major, expected);
}

test "B Lydian Major" {
    const key = Note{ .pitch = .B, .accidental = .Natural };
    const expected = &[_]Note{
        Note{ .pitch = .B, .accidental = .Natural },
        Note{ .pitch = .C, .accidental = .Sharp },
        Note{ .pitch = .D, .accidental = .Sharp },
        Note{ .pitch = .E, .accidental = .Sharp },
        Note{ .pitch = .F, .accidental = .Sharp },
        Note{ .pitch = .G, .accidental = .Sharp },
        Note{ .pitch = .A, .accidental = .Sharp },
        Note{ .pitch = .B, .accidental = .Natural },
    };
    try util.validate(key, Mode.Lydian_Major, expected);
}
