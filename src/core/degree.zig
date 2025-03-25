const std = @import("std");

pub const Degree = enum(u8) {
    First,
    Second,
    Third,
    Fourth,
    Fifth,
    Sixth,
    Seventh,

    pub fn index(self: Degree) u8 {
        return @intFromEnum(self);
    }

    pub fn parse(input: []const u8) ?Degree {
        return std.meta.stringToEnum(Degree, input);
    }

    pub fn name(self: Degree) []const u8 {
        return switch (self) {
            .First => "I",
            .Second => "II",
            .Third => "III",
            .Fourth => "IV",
            .Fifth => "V",
            .Sixth => "VI",
            .Seventh => "VII",
        };
    }
};
