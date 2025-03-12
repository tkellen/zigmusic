const std = @import("std");
const notes = @import("notes.zig");
const modes = @import("modes.zig");

pub const Tone = enum {
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

    pub fn toString(self: Tone) ![]const u8 {
        return @tagName(self);
    }
};

pub const Type = enum {
    Major,
    Minor,
    Diminished,
    Augmented,
    Major7,
    Dominant7,
    Minor7,
    Diminished7,
    HalfDiminished7,
    Augmented7,

    pub fn scaleDegrees(self: Type) []const u8 {
        return switch (self) {
            .Major => &[_]u8{ 1, 3, 5 }, // Root, Major Third, Perfect Fifth
            .Minor => &[_]u8{ 1, 3, 5 }, // Root, Minor Third, Perfect Fifth (depends on mode)
            .Diminished => &[_]u8{ 1, 3, 5 }, // Root, Minor Third, Diminished Fifth
            .Augmented => &[_]u8{ 1, 3, 5 }, // Root, Major Third, Augmented Fifth
            .Major7 => &[_]u8{ 1, 3, 5, 7 }, // Root, Major Third, Perfect Fifth, Major Seventh
            .Dominant7 => &[_]u8{ 1, 3, 5, 7 }, // Root, Major Third, Perfect Fifth, Minor Seventh
            .Minor7 => &[_]u8{ 1, 3, 5, 7 }, // Root, Minor Third, Perfect Fifth, Minor Seventh
            .Diminished7 => &[_]u8{ 1, 3, 5, 7 }, // Root, Minor Third, Diminished Fifth, Diminished Seventh
            .HalfDiminished7 => &[_]u8{ 1, 3, 5, 7 }, // Root, Minor Third, Diminished Fifth, Minor Seventh
            .Augmented7 => &[_]u8{ 1, 3, 5, 7 }, // Root, Major Third, Augmented Fifth, Minor Seventh
        };
    }

    pub fn name(self: Type) []const u8 {
        return @tagName(self);
    }
};

pub const Chord = struct {
    key: notes.Note,
    mode: modes.Mode,
    chordType: Type,

    pub fn build(self: Chord, chordBuffer: []notes.Note) []notes.Note {
        var scaleBuffer: [16]notes.Note = undefined;
        const scale = self.mode.scale(self.key, &scaleBuffer);

        const degrees = self.chordType.scaleDegrees();
        const chordSize = @min(degrees.len, chordBuffer.len);

        for (degrees[0..chordSize], 0..) |degree, i| {
            const index = (degree - 1) % scale.len;
            chordBuffer[i] = scale[index];
        }

        return chordBuffer[0..chordSize];
    }
};
