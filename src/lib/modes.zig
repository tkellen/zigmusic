const std = @import("std");
const notes = @import("notes.zig");

pub const Step = enum(u8) {
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

    pub fn chromaticInterval(interval: Step) i8 {
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

pub const ScaleRoot = enum {
    Major,
    Harmonic_Major,
    Harmonic_Minor,
    //Chromatic,
    //WholeTone,

    pub fn intervals(self: ScaleRoot) []const Step {
        return switch (self) {
            .Major => &[_]Step{ .Whole, .Whole, .Half, .Whole, .Whole, .Whole, .Half },
            .Harmonic_Major => &[_]Step{ .Whole, .Whole, .Half, .Whole, .Half, .Augmented_Second, .Half },
            .Harmonic_Minor => &[_]Step{ .Whole, .Half, .Whole, .Whole, .Half, .Augmented_Second, .Half },
            //.Chromatic => &[_]Step{ .Half, .Half, .Half, .Half, .Half, .Half, .Half, .Half, .Half, .Half, .Half, .Half },
            //.WholeTone => &[_]Step{ .Whole, .Whole, .Whole, .Whole, .Whole, .Whole },
        };
    }
};

pub const Mode = enum {
    // Major scale variants
    Major,
    Ionian,
    Dorian,
    Phrygian,
    Lydian,
    Mixolydian,
    Minor,
    Aeolian,
    Locrian,
    // Harmonic major variants
    Harmonic_Major,
    //Dorian_B5,
    //Phrygian_B4,
    //Lydian_B3,
    //Mixolydian_B9,
    //Lydian_Augmented_Sharp2,
    //Locrian_BB7,
    // Harmonic minor variants
    Harmonic_Minor,
    //Locrian_Natural_6,
    //Ionian_Augmented,
    //Dorian_Sharp_4,
    //Phrygian_Dominant,
    //Lydian_Sharp_2,
    //Super_Locrian,

    pub fn name(self: Mode) []const u8 {
        return @tagName(self);
    }

    pub fn parse(input: []const u8) ?Mode {
        return std.meta.stringToEnum(Mode, input);
    }

    pub fn scaleRoot(self: Mode) ScaleRoot {
        return switch (self) {
            // Major scale variants
            .Ionian, .Major => .Major,
            .Dorian => .Major,
            .Phrygian => .Major,
            .Lydian => .Major,
            .Mixolydian => .Major,
            .Aeolian, .Minor => .Major,
            .Locrian => .Major,
            // Harmonic minor variants
            .Harmonic_Major => .Harmonic_Major,
            //.Dorian_B5 => .Harmonic_Major,
            //.Phrygian_B4 => .Harmonic_Major,
            //.Lydian_B3 => .Harmonic_Major,
            //.Mixolydian_B9 => .Harmonic_Major,
            //.Lydian_Augmented_Sharp2 => .Harmonic_Major,
            //.Locrian_BB7 => .Harmonic_Major,
            // Harmonic major variants
            .Harmonic_Minor => .Harmonic_Minor,
            //.Locrian_Natural_6 => .Harmonic_Minor,
            //.Ionian_Augmented => .Harmonic_Minor,
            //.Dorian_Sharp_4 => .Harmonic_Minor,
            //.Phrygian_Dominant => .Harmonic_Minor,
            //.Lydian_Sharp_2 => .Harmonic_Minor,
            //.Super_Locrian => .Harmonic_Minor,
        };
    }

    pub fn startAtStep(self: Mode) u8 {
        return switch (self) {
            // Major scale modes
            .Ionian, .Major => 0,
            .Dorian => 1,
            .Phrygian => 2,
            .Lydian => 3,
            .Mixolydian => 4,
            .Aeolian, .Minor => 5,
            .Locrian => 6,
            // Harmonic majoe variants
            .Harmonic_Major => 0,
            //.Dorian_B5 => 1,
            //.Phrygian_B4 => 2,
            //.Lydian_B3 => 3,
            //.Mixolydian_B9 => 4,
            //.Lydian_Augmented_Sharp2 => 5,
            //.Locrian_BB7 => 6,
            // Harmonic minor variants
            .Harmonic_Minor => 0,
            //.Locrian_Natural_6 => 1,
            //.Ionian_Augmented => 2,
            //.Dorian_Sharp_4 => 3,
            //.Phrygian_Dominant => 4,
            //.Lydian_Sharp_2 => 5,
            //.Super_Locrian => 6,
        };
    }

    pub fn intervals(self: Mode, buffer: *[7]Step) []const Step {
        const steps = self.scaleRoot().intervals();
        const startAt = self.startAtStep();
        for (0..7) |i| {
            buffer[i] = steps[(startAt + i) % steps.len];
        }
        return buffer;
    }
};
