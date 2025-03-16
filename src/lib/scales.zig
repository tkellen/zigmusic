const std = @import("std");
const notes = @import("notes.zig");
const chords = @import("chords.zig");

pub const Interval = enum(u8) {
    Half,
    Whole,
    Second,
    Augmented_Second,
    Third,
    Fourth,
    Fifth,
    Sixth,
    Seventh,
    Octave,

    pub fn chromatic(interval: Interval) i8 {
        return switch (interval) {
            .Half => 1,
            .Whole => 2,
            .Second => 2,
            .Augmented_Second => 3,
            .Third => 3,
            .Fourth => 5,
            .Fifth => 7,
            .Sixth => 9,
            .Seventh => 11,
            .Octave => 12,
        };
    }
};

pub const Mode = enum {
    Ionian_Major, // Standard major scale.
    Aeolian_Minor, // Standard minor scale.
    Lydian_Major, // Raised 4th degree, dreamy sound.
    Mixolydian_Major, // Lowered 7th degree, dominant feel.
    Pentatonic_Major, // Five notes, widely used in rock, blues, and folk.
    Blues_Major, // Pentatonic variation with a "blue note", widely used in blues and jazz.
    Harmonic_Major, // Augmented second interval, widly used in classical and Middle Eastern music.
    Dorian_Minor, // Raised 6th degree, used in jazz and modal music.
    Phrygian_Minor, // Lowered 2nd degree, Spanish or Eastern sound.
    Locrian_Minor, // Lowered 2nd and 5th, dissonant, used in jazz and modern metal.
    Pentatonic_Minor, // Omits 2nd and 6th degrees. Widely used in blues, rock, and folk music.
    Blues_Minor, // Pentatonic variation with a "blue note", widely used in blues and jazz.
    Harmonic_Minor, // Raised 7th degree, classical, or "Middle Eastern" character
    Melodic_Minor, // Raised 6th and 7th when ascending, often reverts to natural _minor (Aeolian) when descending. Jazz and classical music.
    Chromatic,
    WholeTone,

    pub fn intervals(self: Mode) []const Interval {
        return switch (self) {
            .Ionian_Major => &[_]Interval{ .Whole, .Whole, .Half, .Whole, .Whole, .Whole, .Half },
            .Lydian_Major => &[_]Interval{ .Whole, .Whole, .Whole, .Half, .Whole, .Whole, .Half },
            .Mixolydian_Major => &[_]Interval{ .Whole, .Whole, .Half, .Whole, .Whole, .Half, .Whole },
            .Pentatonic_Major => &[_]Interval{ .Whole, .Whole, .Third, .Whole, .Third },
            .Blues_Major => &[_]Interval{ .Whole, .Half, .Half, .Third, .Whole, .Third },
            .Harmonic_Major => &[_]Interval{ .Whole, .Whole, .Half, .Whole, .Half, .Augmented_Second, .Half },
            .Aeolian_Minor => &[_]Interval{ .Whole, .Half, .Whole, .Whole, .Half, .Whole, .Whole },
            .Dorian_Minor => &[_]Interval{ .Whole, .Half, .Whole, .Whole, .Whole, .Half, .Whole },
            .Phrygian_Minor => &[_]Interval{ .Half, .Whole, .Whole, .Whole, .Half, .Whole, .Whole },
            .Locrian_Minor => &[_]Interval{ .Half, .Whole, .Whole, .Half, .Whole, .Whole, .Whole },
            .Pentatonic_Minor => &[_]Interval{ .Third, .Whole, .Whole, .Third, .Whole },
            .Blues_Minor => &[_]Interval{ .Third, .Whole, .Half, .Half, .Third, .Whole },
            .Harmonic_Minor => &[_]Interval{ .Whole, .Half, .Whole, .Whole, .Half, .Augmented_Second, .Half },
            .Melodic_Minor => &[_]Interval{ .Whole, .Half, .Whole, .Whole, .Whole, .Whole, .Half }, // Ascending form
            .Chromatic => &[_]Interval{ .Half, .Half, .Half, .Half, .Half, .Half, .Half, .Half, .Half, .Half, .Half, .Half },
            .WholeTone => &[_]Interval{ .Whole, .Whole, .Whole, .Whole, .Whole, .Whole },
        };
    }

    pub fn name(self: Mode) []const u8 {
        return @tagName(self);
    }

    pub fn parse(input: []const u8) ?Mode {
        return std.meta.stringToEnum(Mode, input);
    }
};

pub const Scale = struct {
    notes: []notes.Note,

    pub fn build(key: notes.Note, mode: Mode, buffer: []notes.Note) Scale {
        const intervals = mode.intervals();
        buffer[0] = key;
        buffer[intervals.len] = key;
        var chromaticPosition = key.chromaticPosition();
        var natural = key.natural;
        for (intervals[0 .. intervals.len - 1], 1..) |step, index| {
            natural = natural.diatonicStep(1);
            chromaticPosition = @mod(chromaticPosition + step.chromatic(), 12);
            buffer[index] = notes.Note.fromChromaticPosition(chromaticPosition, natural);
        }
        return Scale{ .notes = buffer[0 .. intervals.len + 1] };
    }

    pub fn chord(self: Scale, chordType: chords.Chord, buffer: []notes.Note) []notes.Note {
        const degrees = chordType.positions();
        for (degrees, 0..) |degree, index| {
            buffer[index] = self.notes[@intFromEnum(degree)];
        }
        return buffer[0..degrees.len];
    }
};
