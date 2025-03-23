const std = @import("std");
const note = @import("note.zig");
const util = @import("util.zig");

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

    pub fn chromaticInterval(interval: Step) i8 {
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
};

fn heptatonicScale(comptime N: usize, root: note.Note, intervals: [N]Step) [N + 1]note.Note {
    var result: [N + 1]note.Note = undefined;
    result[0] = root;
    var position = root.chromaticPosition();
    var natural = root.natural;
    for (intervals, 1..) |step, index| {
        position = util.addChromatic(position, step.chromaticInterval());
        natural = natural.next();
        result[index] = natural.enharmonic(position);
    }
    return result;
}

pub const Diatonic = enum {
    Major,
    HarmonicMajor,
    HarmonicMinor,

    pub fn intervals(self: Diatonic) [7]Step {
        return switch (self) {
            .Major => [7]Step{ .Whole, .Whole, .Half, .Whole, .Whole, .Whole, .Half },
            .HarmonicMajor => [7]Step{ .Whole, .Whole, .Half, .Whole, .Half, .AugmentedSecond, .Half },
            .HarmonicMinor => [7]Step{ .Whole, .Half, .Whole, .Whole, .Half, .AugmentedSecond, .Half },
        };
    }

    pub fn scale(self: Diatonic, root: note.Note) [8]note.Note {
        const steps = self.intervals();
        return heptatonicScale(steps.len, root, steps);
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
    HarmonicMajor,
    DorianB5,
    PhrygianB4,
    LydianB3,
    MixolydianB9,
    LydianAugmentedSharp2,
    LocrianBB7,
    // Harmonic minor variants
    HarmonicMinor,
    LocrianNatural6,
    IonianAugmented,
    DorianSharp4,
    PhrygianDominant,
    LydianSharp2,
    SuperLocrian,

    pub fn name(self: Mode) []const u8 {
        return @tagName(self);
    }

    pub fn parse(input: []const u8) ?Mode {
        return std.meta.stringToEnum(Mode, input);
    }

    pub fn rootIntervals(self: Mode) [7]Step {
        return switch (self) {
            // Major scale modes
            .Ionian,
            .Major,
            .Dorian,
            .Phrygian,
            .Lydian,
            .Mixolydian,
            .Aeolian,
            .Minor,
            .Locrian,
            => Diatonic.Major.intervals(),

            // Harmonic major modes
            .HarmonicMajor,
            .DorianB5,
            .PhrygianB4,
            .LydianB3,
            .MixolydianB9,
            .LydianAugmentedSharp2,
            .LocrianBB7,
            => Diatonic.HarmonicMajor.intervals(),

            // Harmonic minor modes
            .HarmonicMinor,
            .LocrianNatural6,
            .IonianAugmented,
            .DorianSharp4,
            .PhrygianDominant,
            .LydianSharp2,
            .SuperLocrian,
            => Diatonic.HarmonicMinor.intervals(),
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
            // Harmonic major variants
            .HarmonicMajor => 0,
            .DorianB5 => 1,
            .PhrygianB4 => 2,
            .LydianB3 => 3,
            .MixolydianB9 => 4,
            .LydianAugmentedSharp2 => 5,
            .LocrianBB7 => 6,
            // Harmonic minor variants
            .HarmonicMinor => 0,
            .LocrianNatural6 => 1,
            .IonianAugmented => 2,
            .DorianSharp4 => 3,
            .PhrygianDominant => 4,
            .LydianSharp2 => 5,
            .SuperLocrian => 6,
        };
    }

    pub fn intervals(self: Mode) [7]Step {
        var rotated: [7]Step = undefined;
        const steps = self.rootIntervals();
        const startAt = self.startAtStep();
        for (0..7) |i| {
            rotated[i] = steps[(startAt + i) % steps.len];
        }
        return rotated;
    }

    pub fn scale(self: Mode, root: note.Note) [8]note.Note {
        const steps = self.intervals();
        return heptatonicScale(steps.len, root, steps);
    }
};

pub const Chromatic = struct {
    pub const intervals = [12]Step{
        .Half, .Half, .Half, .Half, .Half, .Half,
        .Half, .Half, .Half, .Half, .Half, .Half,
    };

    pub fn scale(root: note.Note) ![13]note.Note {
        var result: [13]note.Note = undefined;
        result[0] = root;

        const allocator = std.heap.page_allocator;
        const preferred = switch (root.accidental) {
            .Sharp, .DoubleSharp => note.Accidental.Sharp,
            .Flat, .DoubleFlat => note.Accidental.Flat,
            .Natural => note.Accidental.Sharp,
        };

        const basePos = root.chromaticPosition();
        for (1..12) |halfSteps| {
            var bestScore: u8 = 255;
            const enharmonics = try note.enharmonicsAt(@intCast(basePos + halfSteps), allocator);
            defer allocator.free(enharmonics);
            result[halfSteps] = enharmonics[0];
            for (enharmonics) |candidate| {
                var score: u8 = switch (candidate.accidental) {
                    .Natural => 0,
                    .Sharp, .Flat => 2,
                    else => 3,
                };
                if (candidate.accidental == preferred) {
                    score = 1;
                }
                if (score < bestScore) {
                    bestScore = score;
                    result[halfSteps] = candidate;
                }
            }
        }
        result[12] = root;
        return result;
    }
};
