const std = @import("std");
const core = @import("core");
const scale = @import("scale");
const Note = core.Note;
const Phrase = core.Phrase;

pub const Chord = enum {
    Triad,
    Seventh,

    pub fn init(self: Chord, key: Note, scaleType: anytype) [self.degrees().len]Note {
        const notes = scaleType.generate(key);
        const degs = self.degrees();
        var chord: [degs.len]Note = undefined;
        for (degs, 0..) |deg, i| {
            chord[i] = notes[deg.index()];
        }
        return chord;
    }

    pub fn degrees(self: Chord) []const scale.Degree {
        return switch (self) {
            .Triad => &[_]core.Degree{ .First, .Third, .Fifth },
            .Seventh => &[_]core.Degree{ .First, .Third, .Fifth, .Seventh },
        };
    }

    pub fn parse(input: []const u8) ?Chord {
        return std.meta.stringToEnum(Chord, input);
    }

    pub fn name(self: Chord) []const u8 {
        return @tagName(self);
    }
};
