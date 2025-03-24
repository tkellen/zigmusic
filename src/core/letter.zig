const std = @import("std");

pub const Letter = enum(u8) {
    C = 0,
    D = 1,
    E = 2,
    F = 3,
    G = 4,
    A = 5,
    B = 6,

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

    pub fn step(self: Letter, target: i8) Letter {
        const start: i8 = @as(i8, @intCast(@intFromEnum(self)));
        const end: i8 = @mod(start + target, 7);
        return @enumFromInt(@as(u8, @intCast(end)));
    }

    pub fn next(self: Letter) Letter {
        return self.step(1);
    }

    pub fn previous(self: Letter) Letter {
        return self.step(-1);
    }

    pub fn name(self: Letter) []const u8 {
        return @tagName(self);
    }

    pub fn parse(input: []const u8) ?Letter {
        return std.meta.stringToEnum(Letter, input);
    }
};
