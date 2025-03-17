const std = @import("std");

pub const Letter = enum(u8) {
    C,
    D,
    E,
    F,
    G,
    A,
    B,

    pub fn name(self: Letter) []const u8 {
        return @tagName(self);
    }

    pub fn parse(input: []const u8) ?Letter {
        return std.meta.stringToEnum(Letter, input);
    }

    pub fn chromaticPosition(self: Letter) u8 {
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

    pub fn diatonicStep(self: Letter, count: i8) Letter {
        const start: i8 = @as(i8, @intCast(@intFromEnum(self)));
        const end: i8 = @mod(start + count, 7);
        return @enumFromInt(@as(u8, @intCast(end)));
    }

    pub fn next(self: Letter) Letter {
        return self.diatonicStep(1);
    }

    pub fn previous(self: Letter) Letter {
        return self.diatonicStep(-1);
    }

    pub fn enharmonic(self: Letter, chromaticPos: i8) Note {
        const wrappedChromaticPos: i8 = @as(i8, @mod(chromaticPos, 12));
        var offset: i8 = wrappedChromaticPos - @as(i8, @intCast(self.chromaticPosition()));
        if (offset > 2) offset -= 12;
        if (offset < -2) offset += 12;
        return Note{
            .natural = self,
            .accidental = Accidental.fromOffset(offset),
        };
    }
};

pub const Accidental = enum(i8) {
    Natural = 0,
    Sharp = 1,
    Flat = -1,
    DoubleSharp = 2,
    DoubleFlat = -2,

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
        if (std.mem.eql(u8, input, "")) {
            return .Natural;
        }
        if (std.mem.eql(u8, input, "#") or std.mem.eql(u8, input, "♯")) {
            return .Sharp;
        }
        if (std.mem.eql(u8, input, "b") or std.mem.eql(u8, input, "♭")) {
            return .Flat;
        }
        if (std.mem.eql(u8, input, "x") or std.mem.eql(u8, input, "𝄪")) {
            return .DoubleSharp;
        }
        if (std.mem.eql(u8, input, "bb") or std.mem.eql(u8, input, "𝄫")) {
            return .DoubleFlat;
        }
        return std.meta.stringToEnum(Accidental, input);
    }

    pub fn offset(self: Accidental) i8 {
        return @intFromEnum(self);
    }

    pub fn fromOffset(input: i8) Accidental {
        return @enumFromInt(input);
    }
};

pub const Note = struct {
    natural: Letter,
    accidental: Accidental,

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

    pub fn chromaticPosition(self: Note) i8 {
        return @mod(@as(i8, @intCast(self.natural.chromaticPosition())) + self.accidental.offset(), 12);
    }
};
