const std = @import("std");
const testing = std.testing;
const mt = @import("./main.zig");
const util = @import("./test_util.zig");

test "C Major Lydian" {
    const key = mt.Note.new(.C, .Natural);
    const expected = &[_]mt.Note{
        mt.Note.new(.C, .Natural),
        mt.Note.new(.D, .Natural),
        mt.Note.new(.E, .Natural),
        mt.Note.new(.F, .Sharp),
        mt.Note.new(.G, .Natural),
        mt.Note.new(.A, .Natural),
        mt.Note.new(.B, .Natural),
        mt.Note.new(.C, .Natural),
    };
    try util.validate(key, mt.Mode.LydianMajor.steps(), expected);
}

test "D Major Lydian" {
    const key = mt.Note.new(.D, .Natural);
    const expected = &[_]mt.Note{
        mt.Note.new(.D, .Natural),
        mt.Note.new(.E, .Natural),
        mt.Note.new(.F, .Sharp),
        mt.Note.new(.G, .Sharp),
        mt.Note.new(.A, .Natural),
        mt.Note.new(.B, .Natural),
        mt.Note.new(.C, .Sharp),
        mt.Note.new(.D, .Natural),
    };
    try util.validate(key, mt.Mode.LydianMajor.steps(), expected);
}

test "E Major Lydian" {
    const key = mt.Note.new(.E, .Natural);
    const expected = &[_]mt.Note{
        mt.Note.new(.E, .Natural),
        mt.Note.new(.F, .Sharp),
        mt.Note.new(.G, .Sharp),
        mt.Note.new(.A, .Sharp),
        mt.Note.new(.B, .Natural),
        mt.Note.new(.C, .Sharp),
        mt.Note.new(.D, .Sharp),
        mt.Note.new(.E, .Natural),
    };
    try util.validate(key, mt.Mode.LydianMajor.steps(), expected);
}

test "F Major Lydian" {
    const key = mt.Note.new(.F, .Natural);
    const expected = &[_]mt.Note{
        mt.Note.new(.F, .Natural),
        mt.Note.new(.G, .Natural),
        mt.Note.new(.A, .Natural),
        mt.Note.new(.B, .Natural),
        mt.Note.new(.C, .Natural),
        mt.Note.new(.D, .Natural),
        mt.Note.new(.E, .Natural),
        mt.Note.new(.F, .Natural),
    };
    try util.validate(key, mt.Mode.LydianMajor.steps(), expected);
}

test "G Major Lydian" {
    const key = mt.Note.new(.G, .Natural);
    const expected = &[_]mt.Note{
        mt.Note.new(.G, .Natural),
        mt.Note.new(.A, .Natural),
        mt.Note.new(.B, .Natural),
        mt.Note.new(.C, .Sharp),
        mt.Note.new(.D, .Natural),
        mt.Note.new(.E, .Natural),
        mt.Note.new(.F, .Sharp),
        mt.Note.new(.G, .Natural),
    };
    try util.validate(key, mt.Mode.LydianMajor.steps(), expected);
}

test "A Major Lydian" {
    const key = mt.Note.new(.A, .Natural);
    const expected = &[_]mt.Note{
        mt.Note.new(.A, .Natural),
        mt.Note.new(.B, .Natural),
        mt.Note.new(.C, .Sharp),
        mt.Note.new(.D, .Sharp),
        mt.Note.new(.E, .Natural),
        mt.Note.new(.F, .Sharp),
        mt.Note.new(.G, .Sharp),
        mt.Note.new(.A, .Natural),
    };
    try util.validate(key, mt.Mode.LydianMajor.steps(), expected);
}

test "B Major Lydian" {
    const key = mt.Note.new(.B, .Natural);
    const expected = &[_]mt.Note{
        mt.Note.new(.B, .Natural),
        mt.Note.new(.C, .Sharp),
        mt.Note.new(.D, .Sharp),
        mt.Note.new(.E, .Sharp),
        mt.Note.new(.F, .Sharp),
        mt.Note.new(.G, .Sharp),
        mt.Note.new(.A, .Sharp),
        mt.Note.new(.B, .Natural),
    };
    try util.validate(key, mt.Mode.LydianMajor.steps(), expected);
}
