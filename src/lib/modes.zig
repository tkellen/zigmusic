const std = @import("std");
const steps = @import("steps.zig");
const notes = @import("notes.zig");

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

    pub fn intervals(self: Mode) []const steps.Step {
        return switch (self) {
            .Ionian_Major => &[_]steps.Step{ .Whole, .Whole, .Half, .Whole, .Whole, .Whole, .Half },
            .Lydian_Major => &[_]steps.Step{ .Whole, .Whole, .Whole, .Half, .Whole, .Whole, .Half },
            .Mixolydian_Major => &[_]steps.Step{ .Whole, .Whole, .Half, .Whole, .Whole, .Half, .Whole },
            .Pentatonic_Major => &[_]steps.Step{ .Whole, .Whole, .Third, .Whole, .Third },
            .Blues_Major => &[_]steps.Step{ .Whole, .Half, .Half, .Third, .Whole, .Third },
            .Harmonic_Major => &[_]steps.Step{ .Whole, .Half, .Whole, .Whole, .Half, .Third, .Half },
            .Aeolian_Minor => &[_]steps.Step{ .Whole, .Half, .Whole, .Whole, .Half, .Whole, .Whole },
            .Dorian_Minor => &[_]steps.Step{ .Whole, .Half, .Whole, .Whole, .Whole, .Half, .Whole },
            .Phrygian_Minor => &[_]steps.Step{ .Half, .Whole, .Whole, .Whole, .Half, .Whole, .Whole },
            .Locrian_Minor => &[_]steps.Step{ .Half, .Whole, .Whole, .Half, .Whole, .Whole, .Whole },
            .Pentatonic_Minor => &[_]steps.Step{ .Third, .Whole, .Whole, .Third, .Whole },
            .Blues_Minor => &[_]steps.Step{ .Third, .Whole, .Half, .Half, .Third, .Whole },
            .Harmonic_Minor => &[_]steps.Step{ .Whole, .Half, .Whole, .Whole, .Half, .Augmented_Second, .Half },
            .Melodic_Minor => &[_]steps.Step{ .Whole, .Half, .Whole, .Whole, .Whole, .Whole, .Half },
            .Chromatic => &[_]steps.Step{ .Half, .Half, .Half, .Half, .Half, .Half, .Half, .Half, .Half, .Half, .Half, .Half },
            .WholeTone => &[_]steps.Step{ .Whole, .Whole, .Whole, .Whole, .Whole, .Whole },
        };
    }

    pub fn scale(self: Mode, root: notes.Note, buffer: []notes.Note) []notes.Note {
        var currentPosition: usize = 0;
        buffer[currentPosition] = root;
        currentPosition += 1;
        var currentNote = root;
        for (self.intervals()) |interval| {
            currentNote = currentNote.stepBy(interval);
            buffer[currentPosition] = currentNote;
            currentPosition += 1;
        }
        return buffer[0..currentPosition];
    }

    pub fn name(self: Mode) []const u8 {
        return @tagName(self);
    }
};
