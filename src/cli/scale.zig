const std = @import("std");
const Scale = @import("scale");
const Note = @import("core").Note;

pub const ScaleCLI = enum {
    Chromatic,
    Major,
    Minor,
    Ionian,
    Dorian,
    Phrygian,
    Lydian,
    Mixolydian,
    Aeolian,
    Locrian,
    HarmonicMajor,
    HarmonicMajorDorianB5,
    HarmonicMajorPhrygianB4,
    HarmonicMajorLydianB3,
    HarmonicMajorMixolydianB2,
    HarmonicMajorLydianAugmented2,
    HarmonicMajorLocrianDiminished7,
    HarmonicMinor,
    HarmonicMinorLocrian6,
    HarmonicMinorIonianAugmented,
    HarmonicMinorDorian4,
    HarmonicMinorPhrygianDominant,
    HarmonicMinorLydian2,
    HarmonicMinorUltraLocrian,
    MajorBlues,
    //MinorBlues,
    MajorPentatonic,
    MinorPentatonic,
    MelodicMinor,
    MelodicMinorDorianB2,
    MelodicMinorLydianAugmented,
    MelodicMinorLydianDominant,
    MelodicMinorMixolydianB6,
    MelodicMinorHalfDiminished,
    MelodicMinorAltered,
    WholeTone,

    pub fn parse(findScale: []const u8) !ScaleCLI {
        if (std.meta.stringToEnum(ScaleCLI, findScale)) |cli| {
            return cli;
        }
        std.debug.print("Invalid scale, options are:\n", .{});
        for (std.meta.tags(ScaleCLI)) |entry| {
            std.debug.print("{s}\n", .{@tagName(entry)});
        }
        return error.InvalidScale;
    }

    pub fn noteCount(self: ScaleCLI) usize {
        return switch (self) {
            .Chromatic => 13,
            .MajorBlues, .WholeTone => 7,
            .MajorPentatonic, .MinorPentatonic => 5,
            else => 8,
        };
    }

    pub fn build(self: ScaleCLI, key: Note) []const Note {
        return switch (self) {
            .Chromatic => Scale.Chromatic.build(key)[0..],
            .Major => Scale.Diatonic.Ionian.build(key)[0..],
            .Minor => Scale.Diatonic.Aeolian.build(key)[0..],
            .Ionian => Scale.Diatonic.Ionian.build(key)[0..],
            .Dorian => Scale.Diatonic.Dorian.build(key)[0..],
            .Phrygian => Scale.Diatonic.Phrygian.build(key)[0..],
            .Lydian => Scale.Diatonic.Lydian.build(key)[0..],
            .Mixolydian => Scale.Diatonic.Mixolydian.build(key)[0..],
            .Aeolian => Scale.Diatonic.Aeolian.build(key)[0..],
            .Locrian => Scale.Diatonic.Locrian.build(key)[0..],
            .HarmonicMajor => Scale.HarmonicMajor.IonianB6.build(key)[0..],
            .HarmonicMajorDorianB5 => Scale.HarmonicMajor.DorianB5.build(key)[0..],
            .HarmonicMajorPhrygianB4 => Scale.HarmonicMajor.PhrygianB4.build(key)[0..],
            .HarmonicMajorLydianB3 => Scale.HarmonicMajor.LydianB3.build(key)[0..],
            .HarmonicMajorMixolydianB2 => Scale.HarmonicMajor.MixolydianB2.build(key)[0..],
            .HarmonicMajorLydianAugmented2 => Scale.HarmonicMajor.LydianAugmented2.build(key)[0..],
            .HarmonicMajorLocrianDiminished7 => Scale.HarmonicMajor.LocrianDiminished7.build(key)[0..],
            .HarmonicMinor => Scale.HarmonicMinor.Root.build(key)[0..],
            .HarmonicMinorLocrian6 => Scale.HarmonicMinor.Locrian6.build(key)[0..],
            .HarmonicMinorIonianAugmented => Scale.HarmonicMinor.IonianAugmented.build(key)[0..],
            .HarmonicMinorDorian4 => Scale.HarmonicMinor.Dorian4.build(key)[0..],
            .HarmonicMinorPhrygianDominant => Scale.HarmonicMinor.PhrygianDominant.build(key)[0..],
            .HarmonicMinorLydian2 => Scale.HarmonicMinor.Lydian2.build(key)[0..],
            .HarmonicMinorUltraLocrian => Scale.HarmonicMinor.UltraLocrian.build(key)[0..],
            .MajorBlues => Scale.MajorBlues.build(key)[0..],
            //MinorBlues=>Scale.MinorBlues.build(key)[0..],
            .MajorPentatonic => Scale.MajorPentatonic.build(key)[0..],
            .MinorPentatonic => Scale.MinorPentatonic.build(key)[0..],
            .MelodicMinor => Scale.MelodicMinor.Root.build(key)[0..],
            .MelodicMinorDorianB2 => Scale.MelodicMinor.DorianB2.build(key)[0..],
            .MelodicMinorLydianAugmented => Scale.MelodicMinor.LydianAugmented.build(key)[0..],
            .MelodicMinorLydianDominant => Scale.MelodicMinor.LydianDominant.build(key)[0..],
            .MelodicMinorMixolydianB6 => Scale.MelodicMinor.MixolydianB6.build(key)[0..],
            .MelodicMinorHalfDiminished => Scale.MelodicMinor.HalfDiminished.build(key)[0..],
            .MelodicMinorAltered => Scale.MelodicMinor.Altered.build(key)[0..],
            .WholeTone => Scale.WholeTone.build(key)[0..],
        };
    }
};
