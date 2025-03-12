const std = @import("std");
const testing = std.testing;
const m = @import("./main.zig");
const util = @import("./test_util.zig");

test "C Lydian Major" {
    const key = m.Note.new(.C, .Natural);
    const expected = &[_]m.Note{
        m.Note.new(.C, .Natural),
        m.Note.new(.D, .Natural),
        m.Note.new(.E, .Natural),
        m.Note.new(.F, .Sharp),
        m.Note.new(.G, .Natural),
        m.Note.new(.A, .Natural),
        m.Note.new(.B, .Natural),
        m.Note.new(.C, .Natural),
    };
    try util.validate(key, m.Mode.Lydian_Major, expected);
}

test "D Lydian Major" {
    const key = m.Note.new(.D, .Natural);
    const expected = &[_]m.Note{
        m.Note.new(.D, .Natural),
        m.Note.new(.E, .Natural),
        m.Note.new(.F, .Sharp),
        m.Note.new(.G, .Sharp),
        m.Note.new(.A, .Natural),
        m.Note.new(.B, .Natural),
        m.Note.new(.C, .Sharp),
        m.Note.new(.D, .Natural),
    };
    try util.validate(key, m.Mode.Lydian_Major, expected);
}

test "E Lydian Major" {
    const key = m.Note.new(.E, .Natural);
    const expected = &[_]m.Note{
        m.Note.new(.E, .Natural),
        m.Note.new(.F, .Sharp),
        m.Note.new(.G, .Sharp),
        m.Note.new(.A, .Sharp),
        m.Note.new(.B, .Natural),
        m.Note.new(.C, .Sharp),
        m.Note.new(.D, .Sharp),
        m.Note.new(.E, .Natural),
    };
    try util.validate(key, m.Mode.Lydian_Major, expected);
}

test "F Lydian Major" {
    const key = m.Note.new(.F, .Natural);
    const expected = &[_]m.Note{
        m.Note.new(.F, .Natural),
        m.Note.new(.G, .Natural),
        m.Note.new(.A, .Natural),
        m.Note.new(.B, .Natural),
        m.Note.new(.C, .Natural),
        m.Note.new(.D, .Natural),
        m.Note.new(.E, .Natural),
        m.Note.new(.F, .Natural),
    };
    try util.validate(key, m.Mode.Lydian_Major, expected);
}

test "G Lydian Major" {
    const key = m.Note.new(.G, .Natural);
    const expected = &[_]m.Note{
        m.Note.new(.G, .Natural),
        m.Note.new(.A, .Natural),
        m.Note.new(.B, .Natural),
        m.Note.new(.C, .Sharp),
        m.Note.new(.D, .Natural),
        m.Note.new(.E, .Natural),
        m.Note.new(.F, .Sharp),
        m.Note.new(.G, .Natural),
    };
    try util.validate(key, m.Mode.Lydian_Major, expected);
}

test "A Lydian Major" {
    const key = m.Note.new(.A, .Natural);
    const expected = &[_]m.Note{
        m.Note.new(.A, .Natural),
        m.Note.new(.B, .Natural),
        m.Note.new(.C, .Sharp),
        m.Note.new(.D, .Sharp),
        m.Note.new(.E, .Natural),
        m.Note.new(.F, .Sharp),
        m.Note.new(.G, .Sharp),
        m.Note.new(.A, .Natural),
    };
    try util.validate(key, m.Mode.Lydian_Major, expected);
}

test "B Lydian Major" {
    const key = m.Note.new(.B, .Natural);
    const expected = &[_]m.Note{
        m.Note.new(.B, .Natural),
        m.Note.new(.C, .Sharp),
        m.Note.new(.D, .Sharp),
        m.Note.new(.E, .Sharp),
        m.Note.new(.F, .Sharp),
        m.Note.new(.G, .Sharp),
        m.Note.new(.A, .Sharp),
        m.Note.new(.B, .Natural),
    };
    try util.validate(key, m.Mode.Lydian_Major, expected);
}
