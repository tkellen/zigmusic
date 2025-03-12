const std = @import("std");
const testing = std.testing;
const m = @import("./main.zig");
const util = @import("./test_util.zig");
test "C Aeolian Minor" {
    const key = m.Note.new(.C, .Natural);
    const expected = &[_]m.Note{
        m.Note.new(.C, .Natural),
        m.Note.new(.D, .Natural),
        m.Note.new(.E, .Flat),
        m.Note.new(.F, .Natural),
        m.Note.new(.G, .Natural),
        m.Note.new(.A, .Flat),
        m.Note.new(.B, .Flat),
        m.Note.new(.C, .Natural),
    };
    try util.validate(key, m.Mode.Aeolian_Minor, expected);
}

test "D Aeolian Minor" {
    const key = m.Note.new(.D, .Natural);
    const expected = &[_]m.Note{
        m.Note.new(.D, .Natural),
        m.Note.new(.E, .Natural),
        m.Note.new(.F, .Natural),
        m.Note.new(.G, .Natural),
        m.Note.new(.A, .Natural),
        m.Note.new(.B, .Flat),
        m.Note.new(.C, .Natural),
        m.Note.new(.D, .Natural),
    };
    try util.validate(key, m.Mode.Aeolian_Minor, expected);
}

test "E Aeolian Minor" {
    const key = m.Note.new(.E, .Natural);
    const expected = &[_]m.Note{
        m.Note.new(.E, .Natural),
        m.Note.new(.F, .Sharp),
        m.Note.new(.G, .Natural),
        m.Note.new(.A, .Natural),
        m.Note.new(.B, .Natural),
        m.Note.new(.C, .Natural),
        m.Note.new(.D, .Natural),
        m.Note.new(.E, .Natural),
    };
    try util.validate(key, m.Mode.Aeolian_Minor, expected);
}

test "F Aeolian Minor" {
    const key = m.Note.new(.F, .Natural);
    const expected = &[_]m.Note{
        m.Note.new(.F, .Natural),
        m.Note.new(.G, .Natural),
        m.Note.new(.A, .Flat),
        m.Note.new(.B, .Flat),
        m.Note.new(.C, .Natural),
        m.Note.new(.D, .Flat),
        m.Note.new(.E, .Flat),
        m.Note.new(.F, .Natural),
    };
    try util.validate(key, m.Mode.Aeolian_Minor, expected);
}

test "G Aeolian Minor" {
    const key = m.Note.new(.G, .Natural);
    const expected = &[_]m.Note{
        m.Note.new(.G, .Natural),
        m.Note.new(.A, .Natural),
        m.Note.new(.B, .Flat),
        m.Note.new(.C, .Natural),
        m.Note.new(.D, .Natural),
        m.Note.new(.E, .Flat),
        m.Note.new(.F, .Natural),
        m.Note.new(.G, .Natural),
    };
    try util.validate(key, m.Mode.Aeolian_Minor, expected);
}

test "A Aeolian Minor" {
    const key = m.Note.new(.A, .Natural);
    const expected = &[_]m.Note{
        m.Note.new(.A, .Natural),
        m.Note.new(.B, .Natural),
        m.Note.new(.C, .Natural),
        m.Note.new(.D, .Natural),
        m.Note.new(.E, .Natural),
        m.Note.new(.F, .Natural),
        m.Note.new(.G, .Natural),
        m.Note.new(.A, .Natural),
    };
    try util.validate(key, m.Mode.Aeolian_Minor, expected);
}

test "B Aeolian Minor" {
    const key = m.Note.new(.B, .Natural);
    const expected = &[_]m.Note{
        m.Note.new(.B, .Natural),
        m.Note.new(.C, .Sharp),
        m.Note.new(.D, .Natural),
        m.Note.new(.E, .Natural),
        m.Note.new(.F, .Sharp),
        m.Note.new(.G, .Natural),
        m.Note.new(.A, .Natural),
        m.Note.new(.B, .Natural),
    };
    try util.validate(key, m.Mode.Aeolian_Minor, expected);
}
