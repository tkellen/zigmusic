const std = @import("std");
const testing = std.testing;
const util = @import("./util.zig");

const music = @import("music");
const Pitch = music.notes.Pitch;
const Accidental = music.notes.Accidental;
const Note = music.notes.Note;
const Mode = music.modes.Mode;

test "C♭ Ionian Major" {
    const key = Note{ .pitch = .C, .accidental = .Flat };
    const expected = &[_]Note{
        Note{ .pitch = .C, .accidental = .Flat },
        Note{ .pitch = .D, .accidental = .Flat },
        Note{ .pitch = .E, .accidental = .Flat },
        Note{ .pitch = .F, .accidental = .Flat },
        Note{ .pitch = .G, .accidental = .Flat },
        Note{ .pitch = .A, .accidental = .Flat },
        Note{ .pitch = .B, .accidental = .Flat },
        Note{ .pitch = .C, .accidental = .Flat },
    };
    try util.validate(key, Mode.Ionian_Major, expected);
}

test "C Ionian Major" {
    const key = Note{ .pitch = .C, .accidental = .Natural };
    const expected = &[_]Note{
        Note{ .pitch = .C, .accidental = .Natural },
        Note{ .pitch = .D, .accidental = .Natural },
        Note{ .pitch = .E, .accidental = .Natural },
        Note{ .pitch = .F, .accidental = .Natural },
        Note{ .pitch = .G, .accidental = .Natural },
        Note{ .pitch = .A, .accidental = .Natural },
        Note{ .pitch = .B, .accidental = .Natural },
        Note{ .pitch = .C, .accidental = .Natural },
    };
    try util.validate(key, Mode.Ionian_Major, expected);
}

test "C♯ Ionian Major" {
    const key = Note{ .pitch = .C, .accidental = .Sharp };
    const expected = &[_]Note{
        Note{ .pitch = .C, .accidental = .Sharp },
        Note{ .pitch = .D, .accidental = .Sharp },
        Note{ .pitch = .E, .accidental = .Sharp },
        Note{ .pitch = .F, .accidental = .Sharp },
        Note{ .pitch = .G, .accidental = .Sharp },
        Note{ .pitch = .A, .accidental = .Sharp },
        Note{ .pitch = .B, .accidental = .Sharp },
        Note{ .pitch = .C, .accidental = .Sharp },
    };
    try util.validate(key, Mode.Ionian_Major, expected);
}

test "D♭ Ionian Major" {
    const key = Note{ .pitch = .D, .accidental = .Flat };
    const expected = &[_]Note{
        Note{ .pitch = .D, .accidental = .Flat },
        Note{ .pitch = .E, .accidental = .Flat },
        Note{ .pitch = .F, .accidental = .Natural },
        Note{ .pitch = .G, .accidental = .Flat },
        Note{ .pitch = .A, .accidental = .Flat },
        Note{ .pitch = .B, .accidental = .Flat },
        Note{ .pitch = .C, .accidental = .Natural },
        Note{ .pitch = .D, .accidental = .Flat },
    };
    try util.validate(key, Mode.Ionian_Major, expected);
}

test "D Ionian Major" {
    const key = Note{ .pitch = .D, .accidental = .Natural };
    const expected = &[_]Note{
        Note{ .pitch = .D, .accidental = .Natural },
        Note{ .pitch = .E, .accidental = .Natural },
        Note{ .pitch = .F, .accidental = .Sharp },
        Note{ .pitch = .G, .accidental = .Natural },
        Note{ .pitch = .A, .accidental = .Natural },
        Note{ .pitch = .B, .accidental = .Natural },
        Note{ .pitch = .C, .accidental = .Sharp },
        Note{ .pitch = .D, .accidental = .Natural },
    };
    try util.validate(key, Mode.Ionian_Major, expected);
}

// test "D♯ Ionian Major" {
//     const key = Note{.pitch = .D, .Sharp};
//     const expected = &[_]Note{
//         Note{.pitch = .D, .accidental = .Sharp},
//         Note{.pitch = .E, .accidental = .Sharp},
//         Note{.pitch = .F, .DoubleSharp),
//         Note{.pitch = .G, .accidental = .Sharp},
//         Note{.pitch = .A, .accidental = .Sharp},
//         Note{.pitch = .B, .accidental = .Sharp},
//         Note{.pitch = .C, .DoubleSharp),
//         Note{.pitch = .D, .accidental = .Sharp},
//     };
//     try util.validate(key, Mode.Ionian_Major, expected);
// }

// test "E Ionian Major" {
//     const key = Note{.pitch = .E, .accidental = .Natural};
//     const expected = &[_]Note{
//         Note{.pitch = .E, .accidental = .Natural},
//         Note{.pitch = .F, .accidental = .Sharp},
//         Note{.pitch = .G, .accidental = .Sharp},
//         Note{.pitch = .A, .accidental = .Natural},
//         Note{.pitch = .B, .accidental = .Natural},
//         Note{.pitch = .C, .accidental = .Sharp},
//         Note{.pitch = .D, .accidental = .Sharp},
//         Note{.pitch = .E, .accidental = .Natural},
//     };
//     try util.validate(key, Mode.Ionian_Major, expected);
// }

// test "F Ionian Major" {
//     const key = Note{.pitch = .F, .accidental = .Natural};
//     const expected = &[_]Note{
//         Note{.pitch = .F, .accidental = .Natural},
//         Note{.pitch = .G, .accidental = .Natural},
//         Note{.pitch = .A, .accidental = .Natural},
//         Note{.pitch = .B, .accidental = .Flat},
//         Note{.pitch = .C, .accidental = .Natural},
//         Note{.pitch = .D, .accidental = .Natural},
//         Note{.pitch = .E, .accidental = .Natural},
//         Note{.pitch = .F, .accidental = .Natural},
//     };
//     try util.validate(key, Mode.Ionian_Major, expected);
// }

// test "A Ionian Major" {
//     const key = Note{.pitch = .A, .accidental = .Natural};
//     const expected = &[_]Note{
//         Note{.pitch = .A, .accidental = .Natural},
//         Note{.pitch = .B, .accidental = .Natural},
//         Note{.pitch = .C, .accidental = .Sharp},
//         Note{.pitch = .D, .accidental = .Natural},
//         Note{.pitch = .E, .accidental = .Natural},
//         Note{.pitch = .F, .accidental = .Sharp},
//         Note{.pitch = .G, .accidental = .Sharp},
//         Note{.pitch = .A, .accidental = .Natural},
//     };
//     try util.validate(key, Mode.Ionian_Major, expected);
// }

// test "B Ionian Major" {
//     const key = Note{.pitch = .B, .accidental = .Natural};
//     const expected = &[_]Note{
//         Note{.pitch = .B, .accidental = .Natural},
//         Note{.pitch = .C, .accidental = .Sharp},
//         Note{.pitch = .D, .accidental = .Sharp},
//         Note{.pitch = .E, .accidental = .Natural},
//         Note{.pitch = .F, .accidental = .Sharp},
//         Note{.pitch = .G, .accidental = .Sharp},
//         Note{.pitch = .A, .accidental = .Sharp},
//         Note{.pitch = .B, .accidental = .Natural},
//     };
//     try util.validate(key, Mode.Ionian_Major, expected);
// }
