const std = @import("std");
const core = @import("core");
const Note = core.Note;
const Printer = core.Printer;

pub const Chord = enum {
    Triad,
    Seventh,

    pub fn degrees(self: Chord) []const core.Degree {
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

    pub fn build(self: Chord, key: Note, scaleType: anytype) [self.degrees().len]Note {
        const notes = scaleType.generate(key);
        const degs = self.degrees();
        var chord: [degs.len]Note = undefined;
        for (degs, 0..) |deg, i| {
            chord[i] = notes[deg.index()];
        }
        return chord;
    }
};
