const std = @import("std");
const testing = std.testing;
const mt = @import("./main.zig");
const util = @import("./test_util.zig");

test "C♭ Major Ionian" {
    const key = mt.Note.new(.C, .Flat);
    const expected = &[_]mt.Note{
        mt.Note.new(.C, .Flat),
        mt.Note.new(.D, .Flat),
        mt.Note.new(.E, .Flat),
        mt.Note.new(.F, .Flat),
        mt.Note.new(.G, .Flat),
        mt.Note.new(.A, .Flat),
        mt.Note.new(.B, .Flat),
        mt.Note.new(.C, .Flat),
    };
    try util.validate(key, mt.Mode.IonianMajor.steps(), expected);
}

test "C Major Ionian" {
    const key = mt.Note.new(.C, .Natural);
    const expected = &[_]mt.Note{
        mt.Note.new(.C, .Natural),
        mt.Note.new(.D, .Natural),
        mt.Note.new(.E, .Natural),
        mt.Note.new(.F, .Natural),
        mt.Note.new(.G, .Natural),
        mt.Note.new(.A, .Natural),
        mt.Note.new(.B, .Natural),
        mt.Note.new(.C, .Natural),
    };
    try util.validate(key, mt.Mode.IonianMajor.steps(), expected);
}

test "C♯ Major Ionian" {
    const key = mt.Note.new(.C, .Sharp);
    const expected = &[_]mt.Note{
        mt.Note.new(.C, .Sharp),
        mt.Note.new(.D, .Sharp),
        mt.Note.new(.E, .Sharp),
        mt.Note.new(.F, .Sharp),
        mt.Note.new(.G, .Sharp),
        mt.Note.new(.A, .Sharp),
        mt.Note.new(.B, .Sharp),
        mt.Note.new(.C, .Sharp),
    };
    try util.validate(key, mt.Mode.IonianMajor.steps(), expected);
}

test "D♭ Major Ionian" {
    const key = mt.Note.new(.D, .Flat);
    const expected = &[_]mt.Note{
        mt.Note.new(.D, .Flat),
        mt.Note.new(.E, .Flat),
        mt.Note.new(.F, .Natural),
        mt.Note.new(.G, .Flat),
        mt.Note.new(.A, .Flat),
        mt.Note.new(.B, .Flat),
        mt.Note.new(.C, .Natural),
        mt.Note.new(.D, .Flat),
    };
    try util.validate(key, mt.Mode.IonianMajor.steps(), expected);
}

test "D Major Ionian" {
    const key = mt.Note.new(.D, .Natural);
    const expected = &[_]mt.Note{
        mt.Note.new(.D, .Natural),
        mt.Note.new(.E, .Natural),
        mt.Note.new(.F, .Sharp),
        mt.Note.new(.G, .Natural),
        mt.Note.new(.A, .Natural),
        mt.Note.new(.B, .Natural),
        mt.Note.new(.C, .Sharp),
        mt.Note.new(.D, .Natural),
    };
    try util.validate(key, mt.Mode.IonianMajor.steps(), expected);
}

test "D♯ Major Ionian" {
    const key = mt.Note.new(.D, .Sharp);
    const expected = &[_]mt.Note{
        mt.Note.new(.D, .Sharp),
        mt.Note.new(.E, .Sharp),
        mt.Note.new(.F, .DoubleSharp),
        mt.Note.new(.G, .Sharp),
        mt.Note.new(.A, .Sharp),
        mt.Note.new(.B, .Sharp),
        mt.Note.new(.C, .DoubleSharp),
        mt.Note.new(.D, .Sharp),
    };
    try util.validate(key, mt.Mode.IonianMajor.steps(), expected);
}

test "E Major Ionian" {
    const key = mt.Note.new(.E, .Natural);
    const expected = &[_]mt.Note{
        mt.Note.new(.E, .Natural),
        mt.Note.new(.F, .Sharp),
        mt.Note.new(.G, .Sharp),
        mt.Note.new(.A, .Natural),
        mt.Note.new(.B, .Natural),
        mt.Note.new(.C, .Sharp),
        mt.Note.new(.D, .Sharp),
        mt.Note.new(.E, .Natural),
    };
    try util.validate(key, mt.Mode.IonianMajor.steps(), expected);
}

test "F Major Ionian" {
    const key = mt.Note.new(.F, .Natural);
    const expected = &[_]mt.Note{
        mt.Note.new(.F, .Natural),
        mt.Note.new(.G, .Natural),
        mt.Note.new(.A, .Natural),
        mt.Note.new(.B, .Flat),
        mt.Note.new(.C, .Natural),
        mt.Note.new(.D, .Natural),
        mt.Note.new(.E, .Natural),
        mt.Note.new(.F, .Natural),
    };
    try util.validate(key, mt.Mode.IonianMajor.steps(), expected);
}

test "A Major Ionian" {
    const key = mt.Note.new(.A, .Natural);
    const expected = &[_]mt.Note{
        mt.Note.new(.A, .Natural),
        mt.Note.new(.B, .Natural),
        mt.Note.new(.C, .Sharp),
        mt.Note.new(.D, .Natural),
        mt.Note.new(.E, .Natural),
        mt.Note.new(.F, .Sharp),
        mt.Note.new(.G, .Sharp),
        mt.Note.new(.A, .Natural),
    };
    try util.validate(key, mt.Mode.IonianMajor.steps(), expected);
}

test "B Major Ionian" {
    const key = mt.Note.new(.B, .Natural);
    const expected = &[_]mt.Note{
        mt.Note.new(.B, .Natural),
        mt.Note.new(.C, .Sharp),
        mt.Note.new(.D, .Sharp),
        mt.Note.new(.E, .Natural),
        mt.Note.new(.F, .Sharp),
        mt.Note.new(.G, .Sharp),
        mt.Note.new(.A, .Sharp),
        mt.Note.new(.B, .Natural),
    };
    try util.validate(key, mt.Mode.IonianMajor.steps(), expected);
}
