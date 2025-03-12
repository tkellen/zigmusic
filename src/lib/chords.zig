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

    pub fn scaleDegree(self: Tone) usize {
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

    pub fn scaleDegrees(self: Type) []const Tone {
        return switch (self) {
            .Major => &[_]Tone{ .Root, .MajorThird, .PerfectFifth },
            .Minor => &[_]Tone{ .Root, .MinorThird, .PerfectFifth },
            .Diminished => &[_]Tone{ .Root, .MinorThird, .DiminishedFifth },
            .Augmented => &[_]Tone{ .Root, .MajorThird, .AugmentedFifth },
            .Major7 => &[_]Tone{ .Root, .MajorThird, .PerfectFifth, .MajorSeventh },
            .Dominant7 => &[_]Tone{ .Root, .MajorThird, .PerfectFifth, .MinorSeventh },
            .Minor7 => &[_]Tone{ .Root, .MinorThird, .PerfectFifth, .MinorSeventh },
            .Diminished7 => &[_]Tone{ .Root, .MinorThird, .DiminishedFifth, .MinorSeventh },
            .HalfDiminished7 => &[_]Tone{ .Root, .MinorThird, .DiminishedFifth, .MinorSeventh },
            .Augmented7 => &[_]Tone{ .Root, .MajorThird, .AugmentedFifth, .MinorSeventh },
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
        const tones = self.chordType.scaleDegrees();
        const chordSize = @min(tones.len, chordBuffer.len);
        for (tones[0..chordSize], 0..) |tone, i| {
            const index = tone.scaleDegree() % scale.len;
            chordBuffer[i] = scale[index];
        }
        return chordBuffer[0..chordSize];
    }
};
