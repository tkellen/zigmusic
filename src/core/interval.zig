const std = @import("std");
const Note = @import("index.zig").Note;

pub const Step = enum(u8) {
    PerfectUnison,
    Minor2nd,
    Half,
    Major2nd,
    Whole,
    Minor3rd,
    Second,
    AugmentedSecond,
    Major3rd,
    Perfect4th,
    Diminished5th,
    Perfect5th,
    Minor6th,
    Major6th,
    Minor7th,
    Major7th,
    PerfectOctave,

    pub fn parse(input: []const u8) ?Step {
        return std.meta.stringToEnum(Step, input);
    }

    pub fn chromaticInterval(interval: Step) u8 {
        return switch (interval) {
            .PerfectUnison => 0,
            .Minor2nd, .Half => 1,
            .Major2nd, .Whole => 2,
            .Minor3rd, .Second, .AugmentedSecond => 3,
            .Major3rd => 4,
            .Perfect4th => 5,
            .Diminished5th => 6,
            .Perfect5th => 7,
            .Minor6th => 8,
            .Major6th => 9,
            .Minor7th => 10,
            .Major7th => 10,
            .PerfectOctave => 11,
        };
    }

    pub fn chromaticPositionFrom(self: Step, note: Note) u8 {
        return @mod(note.chromaticPosition() + self.chromaticInterval(), 12);
    }
};
