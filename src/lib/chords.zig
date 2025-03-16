const std = @import("std");

pub const Degree = enum {
    Root,
    MinorThird,
    MajorThird,
    PerfectFifth,
    DiminishedFifth,
    AugmentedFifth,
    MinorSeventh,
    MajorSeventh,
    Ninth,
    Eleventh,
    Thirteenth,

    pub fn toString(self: Degree) ![]const u8 {
        return @tagName(self);
    }

    pub fn position(self: Degree) usize {
        return switch (self) {
            .Root => 0,
            .MinorThird => 2,
            .MajorThird => 2,
            .PerfectFifth => 4,
            .DiminishedFifth => 4,
            .AugmentedFifth => 4,
            .MinorSeventh => 6,
            .MajorSeventh => 6,
            .Ninth => 8,
            .Eleventh => 10,
            .Thirteenth => 12,
        };
    }
};

pub const Chord = enum {
    Major,
    Minor,
    Major7,
    Dominant7,

    pub fn positions(self: Chord) []const Degree {
        return switch (self) {
            .Major => &[_]Degree{ .Root, .MajorThird, .PerfectFifth },
            .Minor => &[_]Degree{ .Root, .MinorThird, .MinorSeventh },
            .Major7 => &[_]Degree{ .Root, .MajorThird, .PerfectFifth, .MajorSeventh },
            .Dominant7 => &[_]Degree{ .Root, .MajorThird, .PerfectFifth, .MinorSeventh },
        };
    }
};
