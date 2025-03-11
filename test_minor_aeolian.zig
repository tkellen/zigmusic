const std = @import("std");
const testing = std.testing;
const mt = @import("./main.zig");
const util = @import("./test_util.zig");

test "A Aeolian Minor" {
    const key = mt.Note.new(.A, .Natural);
    const expected = &[_]mt.Note{
        mt.Note.new(.A, .Natural),
        mt.Note.new(.B, .Natural),
        mt.Note.new(.C, .Natural),
        mt.Note.new(.D, .Natural),
        mt.Note.new(.E, .Natural),
        mt.Note.new(.F, .Natural),
        mt.Note.new(.G, .Natural),
        mt.Note.new(.A, .Natural),
    };
    try util.validate(key, mt.Mode.AeolianMinor.steps(), expected);
}

test "B Aeolian Minor" {
    const key = mt.Note.new(.B, .Natural);
    const expected = &[_]mt.Note{
        mt.Note.new(.B, .Natural),
        mt.Note.new(.C, .Sharp),
        mt.Note.new(.D, .Natural),
        mt.Note.new(.E, .Natural),
        mt.Note.new(.F, .Sharp),
        mt.Note.new(.G, .Natural),
        mt.Note.new(.A, .Natural),
        mt.Note.new(.B, .Natural),
    };
    try util.validate(key, mt.Mode.AeolianMinor.steps(), expected);
}

test "C Aeolian Minor" {
    const key = mt.Note.new(.C, .Natural);
    const expected = &[_]mt.Note{
        mt.Note.new(.C, .Natural),
        mt.Note.new(.D, .Natural),
        mt.Note.new(.E, .Flat),
        mt.Note.new(.F, .Natural),
        mt.Note.new(.G, .Natural),
        mt.Note.new(.A, .Flat),
        mt.Note.new(.B, .Flat),
        mt.Note.new(.C, .Natural),
    };
    try util.validate(key, mt.Mode.AeolianMinor.steps(), expected);
}

test "D Aeolian Minor" {
    const key = mt.Note.new(.D, .Natural);
    const expected = &[_]mt.Note{
        mt.Note.new(.D, .Natural),
        mt.Note.new(.E, .Natural),
        mt.Note.new(.F, .Natural),
        mt.Note.new(.G, .Natural),
        mt.Note.new(.A, .Natural),
        mt.Note.new(.B, .Flat),
        mt.Note.new(.C, .Natural),
        mt.Note.new(.D, .Natural),
    };
    try util.validate(key, mt.Mode.AeolianMinor.steps(), expected);
}

test "E Aeolian Minor" {
    const key = mt.Note.new(.E, .Natural);
    const expected = &[_]mt.Note{
        mt.Note.new(.E, .Natural),
        mt.Note.new(.F, .Sharp),
        mt.Note.new(.G, .Natural),
        mt.Note.new(.A, .Natural),
        mt.Note.new(.B, .Natural),
        mt.Note.new(.C, .Natural),
        mt.Note.new(.D, .Natural),
        mt.Note.new(.E, .Natural),
    };
    try util.validate(key, mt.Mode.AeolianMinor.steps(), expected);
}

test "G Aeolian Minor" {
    const key = mt.Note.new(.G, .Natural);
    const expected = &[_]mt.Note{
        mt.Note.new(.G, .Natural),
        mt.Note.new(.A, .Natural),
        mt.Note.new(.B, .Flat),
        mt.Note.new(.C, .Natural),
        mt.Note.new(.D, .Natural),
        mt.Note.new(.E, .Flat),
        mt.Note.new(.F, .Natural),
        mt.Note.new(.G, .Natural),
    };
    try util.validate(key, mt.Mode.AeolianMinor.steps(), expected);
}
