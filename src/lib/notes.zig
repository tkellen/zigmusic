const std = @import("std");

pub const Letter = enum(u8) {
    C,
    D,
    E,
    F,
    G,
    A,
    B,

    pub fn position(self: Letter) i8 {
        return switch (self) {
            .C => 0,
            .D => 2,
            .E => 4,
            .F => 5,
            .G => 7,
            .A => 9,
            .B => 11,
        };
    }

    pub fn diatonicStep(self: Letter, stepCount: i8) Letter {
        const base: i8 = @as(i8, @intCast(@intFromEnum(self)));
        var index: i8 = base + stepCount;
        index = @mod(index, 7);
        if (index < 0) {
            index += 7;
        }
        return @enumFromInt(@as(u8, @intCast(index)));
    }

    pub fn name(self: Letter) []const u8 {
        return @tagName(self);
    }

    pub fn parse(input: []const u8) ?Letter {
        return std.meta.stringToEnum(Letter, input);
    }
};

// const testing = std.testing;
test "letter.diatonicStep" {
    try std.testing.expectEqual(Letter.D, Letter.C.diatonicStep(1));
    try std.testing.expectEqual(Letter.E, Letter.C.diatonicStep(2));
    try std.testing.expectEqual(Letter.F, Letter.C.diatonicStep(3));
    try std.testing.expectEqual(Letter.G, Letter.C.diatonicStep(4));
    try std.testing.expectEqual(Letter.A, Letter.C.diatonicStep(5));
    try std.testing.expectEqual(Letter.B, Letter.C.diatonicStep(6));
    try std.testing.expectEqual(Letter.C, Letter.C.diatonicStep(7));
    try std.testing.expectEqual(Letter.B, Letter.C.diatonicStep(-1));
    try std.testing.expectEqual(Letter.A, Letter.C.diatonicStep(-2));
    try std.testing.expectEqual(Letter.G, Letter.C.diatonicStep(-3));
    try std.testing.expectEqual(Letter.F, Letter.C.diatonicStep(-4));
    try std.testing.expectEqual(Letter.E, Letter.C.diatonicStep(-5));
    try std.testing.expectEqual(Letter.D, Letter.C.diatonicStep(-6));
    try std.testing.expectEqual(Letter.C, Letter.C.diatonicStep(-7));
    try std.testing.expectEqual(Letter.D, Letter.C.diatonicStep(8));
    try std.testing.expectEqual(Letter.E, Letter.C.diatonicStep(9));
    try std.testing.expectEqual(Letter.F, Letter.C.diatonicStep(10));
    try std.testing.expectEqual(Letter.C, Letter.C.diatonicStep(14));
    try std.testing.expectEqual(Letter.A, Letter.C.diatonicStep(19));
    try std.testing.expectEqual(Letter.B, Letter.C.diatonicStep(-8));
    try std.testing.expectEqual(Letter.A, Letter.C.diatonicStep(-9));
    try std.testing.expectEqual(Letter.G, Letter.C.diatonicStep(-10));
    try std.testing.expectEqual(Letter.C, Letter.C.diatonicStep(-14));
    try std.testing.expectEqual(Letter.E, Letter.C.diatonicStep(-19));
}

pub const Accidental = enum {
    Natural,
    Sharp,
    Flat,
    DoubleSharp,
    DoubleFlat,

    pub fn offset(self: Accidental) i8 {
        return switch (self) {
            .Natural => 0,
            .Sharp => 1,
            .Flat => -1,
            .DoubleSharp => 2,
            .DoubleFlat => -2,
        };
    }

    pub fn name(self: Accidental) []const u8 {
        return switch (self) {
            .Natural => "",
            .Sharp => "♯",
            .Flat => "♭",
            .DoubleSharp => "𝄪",
            .DoubleFlat => "𝄫",
        };
    }

    pub fn parse(input: []const u8) ?Accidental {
        if (std.mem.eql(u8, input, "") or std.mem.eql(u8, input, "natural")) {
            return .Natural;
        }
        if (std.mem.eql(u8, input, "#") or std.mem.eql(u8, input, "♯") or std.mem.eql(u8, input, "sharp")) {
            return .Sharp;
        }
        if (std.mem.eql(u8, input, "b") or std.mem.eql(u8, input, "♭") or std.mem.eql(u8, input, "flat")) {
            return .Flat;
        }
        if (std.mem.eql(u8, input, "x") or std.mem.eql(u8, input, "𝄪") or std.mem.eql(u8, input, "double sharp")) {
            return .DoubleSharp;
        }
        if (std.mem.eql(u8, input, "bb") or std.mem.eql(u8, input, "𝄫") or std.mem.eql(u8, input, "double flat")) {
            return .DoubleFlat;
        }
        return std.meta.stringToEnum(Accidental, input);
    }
};

pub const Note = struct {
    natural: Letter,
    accidental: Accidental,

    pub fn chromaticPosition(self: Note) i8 {
        return @mod(self.natural.position() + self.accidental.offset(), 12);
    }

    pub fn parse(input: []const u8) !Note {
        if (input.len == 0)
            return error.InvalidNote;

        const natural = Letter.parse(input[0..1]) orelse return error.InvalidLetter;

        const accidental = if (input.len == 1)
            Accidental.Natural
        else
            Accidental.parse(input[1..]) orelse return error.InvalidAccidental;

        return Note{
            .natural = natural,
            .accidental = accidental,
        };
    }

    pub fn fromChromaticPosition(chromaticPos: i8, referenceNatural: Letter) Note {
        const naturalPos = referenceNatural.position();
        var accidentalOffset = @mod(chromaticPos - naturalPos, 12);
        if (accidentalOffset > 6) accidentalOffset -= 12;
        if (accidentalOffset < -6) accidentalOffset += 12;
        const accidental: Accidental = switch (accidentalOffset) {
            -2 => Accidental.DoubleFlat,
            -1 => Accidental.Flat,
            0 => Accidental.Natural,
            1 => Accidental.Sharp,
            2 => Accidental.DoubleSharp,
            else => {
                std.debug.panic("Unexpected accidental difference: {d}", .{accidentalOffset});
            },
        };
        return Note{
            .natural = referenceNatural,
            .accidental = accidental,
        };
    }
};

const testing = std.testing;
test "note.chromaticPosition" {
    for ([_]struct { Letter, Accidental, i8 }{
        .{ Letter.C, Accidental.Natural, 0 },
        .{ Letter.C, Accidental.Sharp, 1 },
        .{ Letter.C, Accidental.Flat, 11 },
        .{ Letter.C, Accidental.DoubleSharp, 2 },
        .{ Letter.C, Accidental.DoubleFlat, 10 },

        .{ Letter.D, Accidental.Natural, 2 },
        .{ Letter.D, Accidental.Sharp, 3 },
        .{ Letter.D, Accidental.Flat, 1 },
        .{ Letter.D, Accidental.DoubleSharp, 4 },
        .{ Letter.D, Accidental.DoubleFlat, 0 },

        .{ Letter.E, Accidental.Natural, 4 },
        .{ Letter.E, Accidental.Sharp, 5 },
        .{ Letter.E, Accidental.Flat, 3 },
        .{ Letter.E, Accidental.DoubleSharp, 6 },
        .{ Letter.E, Accidental.DoubleFlat, 2 },

        .{ Letter.F, Accidental.Natural, 5 },
        .{ Letter.F, Accidental.Sharp, 6 },
        .{ Letter.F, Accidental.Flat, 4 },
        .{ Letter.F, Accidental.DoubleSharp, 7 },
        .{ Letter.F, Accidental.DoubleFlat, 3 },

        .{ Letter.G, Accidental.Natural, 7 },
        .{ Letter.G, Accidental.Sharp, 8 },
        .{ Letter.G, Accidental.Flat, 6 },
        .{ Letter.G, Accidental.DoubleSharp, 9 },
        .{ Letter.G, Accidental.DoubleFlat, 5 },

        .{ Letter.A, Accidental.Natural, 9 },
        .{ Letter.A, Accidental.Sharp, 10 },
        .{ Letter.A, Accidental.Flat, 8 },
        .{ Letter.A, Accidental.DoubleSharp, 11 },
        .{ Letter.A, Accidental.DoubleFlat, 7 },

        .{ Letter.B, Accidental.Natural, 11 },
        .{ Letter.B, Accidental.Sharp, 0 },
        .{ Letter.B, Accidental.Flat, 10 },
        .{ Letter.B, Accidental.DoubleSharp, 1 },
        .{ Letter.B, Accidental.DoubleFlat, 9 },
    }) |case| {
        const note = Note{
            .natural = case[0],
            .accidental = case[1],
        };
        try testing.expectEqual(case[2], note.chromaticPosition());
    }
}
