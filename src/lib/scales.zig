const std = @import("std");
const notes = @import("notes.zig");
const modes = @import("modes.zig");

pub const Scale = struct {
    mode: modes.Mode,

    pub fn build(self: Scale, key: notes.Note, buffer: []notes.Note) []notes.Note {
        var intervalBuffer: [7]modes.Step = undefined;
        const intervals = self.mode.intervals(&intervalBuffer);
        buffer[0] = key;
        var chromaticPosition: i8 = key.chromaticPosition();
        var natural = key.natural;
        for (intervals, 1..) |step, index| {
            natural = natural.next();
            chromaticPosition = @mod(chromaticPosition + step.chromaticInterval(), 12);
            buffer[index] = natural.enharmonic(chromaticPosition);
        }
        return buffer[0 .. intervals.len + 1];
    }
};
