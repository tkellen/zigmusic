const std = @import("std");
const testing = std.testing;
const m = @import("./main.zig");
const util = @import("./test_util.zig");

test "C♭ Ionian Major" {
    const key = m.Note.new(.C, .Flat);
    const expected = &[_]m.Note{
        m.Note.new(.C, .Flat),
        m.Note.new(.D, .Flat),
        m.Note.new(.E, .Flat),
        m.Note.new(.F, .Flat),
        m.Note.new(.G, .Flat),
        m.Note.new(.A, .Flat),
        m.Note.new(.B, .Flat),
        m.Note.new(.C, .Flat),
    };
    try util.validate(key, m.Mode.Ionian_Major, expected);
}

test "C Ionian Major" {
    const key = m.Note.new(.C, .Natural);
    const expected = &[_]m.Note{
        m.Note.new(.C, .Natural),
        m.Note.new(.D, .Natural),
        m.Note.new(.E, .Natural),
        m.Note.new(.F, .Natural),
        m.Note.new(.G, .Natural),
        m.Note.new(.A, .Natural),
        m.Note.new(.B, .Natural),
        m.Note.new(.C, .Natural),
    };
    try util.validate(key, m.Mode.Ionian_Major, expected);
}

test "C♯ Ionian Major" {
    const key = m.Note.new(.C, .Sharp);
    const expected = &[_]m.Note{
        m.Note.new(.C, .Sharp),
        m.Note.new(.D, .Sharp),
        m.Note.new(.E, .Sharp),
        m.Note.new(.F, .Sharp),
        m.Note.new(.G, .Sharp),
        m.Note.new(.A, .Sharp),
        m.Note.new(.B, .Sharp),
        m.Note.new(.C, .Sharp),
    };
    try util.validate(key, m.Mode.Ionian_Major, expected);
}

test "D♭ Ionian Major" {
    const key = m.Note.new(.D, .Flat);
    const expected = &[_]m.Note{
        m.Note.new(.D, .Flat),
        m.Note.new(.E, .Flat),
        m.Note.new(.F, .Natural),
        m.Note.new(.G, .Flat),
        m.Note.new(.A, .Flat),
        m.Note.new(.B, .Flat),
        m.Note.new(.C, .Natural),
        m.Note.new(.D, .Flat),
    };
    try util.validate(key, m.Mode.Ionian_Major, expected);
}

test "D Ionian Major" {
    const key = m.Note.new(.D, .Natural);
    const expected = &[_]m.Note{
        m.Note.new(.D, .Natural),
        m.Note.new(.E, .Natural),
        m.Note.new(.F, .Sharp),
        m.Note.new(.G, .Natural),
        m.Note.new(.A, .Natural),
        m.Note.new(.B, .Natural),
        m.Note.new(.C, .Sharp),
        m.Note.new(.D, .Natural),
    };
    try util.validate(key, m.Mode.Ionian_Major, expected);
}

test "D♯ Ionian Major" {
    const key = m.Note.new(.D, .Sharp);
    const expected = &[_]m.Note{
        m.Note.new(.D, .Sharp),
        m.Note.new(.E, .Sharp),
        m.Note.new(.F, .DoubleSharp),
        m.Note.new(.G, .Sharp),
        m.Note.new(.A, .Sharp),
        m.Note.new(.B, .Sharp),
        m.Note.new(.C, .DoubleSharp),
        m.Note.new(.D, .Sharp),
    };
    try util.validate(key, m.Mode.Ionian_Major, expected);
}

test "E Ionian Major" {
    const key = m.Note.new(.E, .Natural);
    const expected = &[_]m.Note{
        m.Note.new(.E, .Natural),
        m.Note.new(.F, .Sharp),
        m.Note.new(.G, .Sharp),
        m.Note.new(.A, .Natural),
        m.Note.new(.B, .Natural),
        m.Note.new(.C, .Sharp),
        m.Note.new(.D, .Sharp),
        m.Note.new(.E, .Natural),
    };
    try util.validate(key, m.Mode.Ionian_Major, expected);
}

test "F Ionian Major" {
    const key = m.Note.new(.F, .Natural);
    const expected = &[_]m.Note{
        m.Note.new(.F, .Natural),
        m.Note.new(.G, .Natural),
        m.Note.new(.A, .Natural),
        m.Note.new(.B, .Flat),
        m.Note.new(.C, .Natural),
        m.Note.new(.D, .Natural),
        m.Note.new(.E, .Natural),
        m.Note.new(.F, .Natural),
    };
    try util.validate(key, m.Mode.Ionian_Major, expected);
}

test "A Ionian Major" {
    const key = m.Note.new(.A, .Natural);
    const expected = &[_]m.Note{
        m.Note.new(.A, .Natural),
        m.Note.new(.B, .Natural),
        m.Note.new(.C, .Sharp),
        m.Note.new(.D, .Natural),
        m.Note.new(.E, .Natural),
        m.Note.new(.F, .Sharp),
        m.Note.new(.G, .Sharp),
        m.Note.new(.A, .Natural),
    };
    try util.validate(key, m.Mode.Ionian_Major, expected);
}

test "B Ionian Major" {
    const key = m.Note.new(.B, .Natural);
    const expected = &[_]m.Note{
        m.Note.new(.B, .Natural),
        m.Note.new(.C, .Sharp),
        m.Note.new(.D, .Sharp),
        m.Note.new(.E, .Natural),
        m.Note.new(.F, .Sharp),
        m.Note.new(.G, .Sharp),
        m.Note.new(.A, .Sharp),
        m.Note.new(.B, .Natural),
    };
    try util.validate(key, m.Mode.Ionian_Major, expected);
}
