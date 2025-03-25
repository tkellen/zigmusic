const std = @import("std");
const scale = @import("scale");
const Note = @import("core").Note;

pub const Scale = enum {
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

    pub fn parse(input: []const u8) ?Scale {
        return std.meta.stringToEnum(Scale, input);
    }

    pub fn build(self: Scale, key: Note) []const Note {
        return switch (self) {
            .Chromatic => scale.Chromatic.build(key)[0..],
            .Major => scale.Diatonic.Ionian.build(key)[0..],
            .Minor => scale.Diatonic.Aeolian.build(key)[0..],
            .Ionian => scale.Diatonic.Ionian.build(key)[0..],
            .Dorian => scale.Diatonic.Dorian.build(key)[0..],
            .Phrygian => scale.Diatonic.Phrygian.build(key)[0..],
            .Lydian => scale.Diatonic.Lydian.build(key)[0..],
            .Mixolydian => scale.Diatonic.Mixolydian.build(key)[0..],
            .Aeolian => scale.Diatonic.Aeolian.build(key)[0..],
            .Locrian => scale.Diatonic.Locrian.build(key)[0..],
            .HarmonicMajor => scale.HarmonicMajor.IonianB6.build(key)[0..],
            .HarmonicMajorDorianB5 => scale.HarmonicMajor.DorianB5.build(key)[0..],
            .HarmonicMajorPhrygianB4 => scale.HarmonicMajor.PhrygianB4.build(key)[0..],
            .HarmonicMajorLydianB3 => scale.HarmonicMajor.LydianB3.build(key)[0..],
            .HarmonicMajorMixolydianB2 => scale.HarmonicMajor.MixolydianB2.build(key)[0..],
            .HarmonicMajorLydianAugmented2 => scale.HarmonicMajor.LydianAugmented2.build(key)[0..],
            .HarmonicMajorLocrianDiminished7 => scale.HarmonicMajor.LocrianDiminished7.build(key)[0..],
            .HarmonicMinor => scale.HarmonicMinor.Root.build(key)[0..],
            .HarmonicMinorLocrian6 => scale.HarmonicMinor.Locrian6.build(key)[0..],
            .HarmonicMinorIonianAugmented => scale.HarmonicMinor.IonianAugmented.build(key)[0..],
            .HarmonicMinorDorian4 => scale.HarmonicMinor.Dorian4.build(key)[0..],
            .HarmonicMinorPhrygianDominant => scale.HarmonicMinor.PhrygianDominant.build(key)[0..],
            .HarmonicMinorLydian2 => scale.HarmonicMinor.Lydian2.build(key)[0..],
            .HarmonicMinorUltraLocrian => scale.HarmonicMinor.UltraLocrian.build(key)[0..],
            .MajorBlues => scale.MajorBlues.build(key)[0..],
            //MinorBlues=>scale.MinorBlues.build(key)[0..],
            .MajorPentatonic => scale.MajorPentatonic.build(key)[0..],
            .MinorPentatonic => scale.MinorPentatonic.build(key)[0..],
            .MelodicMinor => scale.MelodicMinor.Root.build(key)[0..],
            .MelodicMinorDorianB2 => scale.MelodicMinor.DorianB2.build(key)[0..],
            .MelodicMinorLydianAugmented => scale.MelodicMinor.LydianAugmented.build(key)[0..],
            .MelodicMinorLydianDominant => scale.MelodicMinor.LydianDominant.build(key)[0..],
            .MelodicMinorMixolydianB6 => scale.MelodicMinor.MixolydianB6.build(key)[0..],
            .MelodicMinorHalfDiminished => scale.MelodicMinor.HalfDiminished.build(key)[0..],
            .MelodicMinorAltered => scale.MelodicMinor.Altered.build(key)[0..],
            .WholeTone => scale.WholeTone.build(key)[0..],
        };
    }

    pub fn print(findGenerator: []const u8, findKey: []const u8) !void {
        if (Scale.parse(findGenerator)) |generator| {
            const key = try Note.parse(findKey);
            for (generator.build(key)) |note| {
                std.debug.print("{s}{s} ", .{ note.natural.name(), note.accidental.name() });
            }
            std.debug.print("\n", .{});
        } else {
            std.debug.print("Invalid scale, options are:\n", .{});
            for (std.meta.tags(Scale)) |kind| {
                std.debug.print("{s}\n", .{@tagName(kind)});
            }
        }
    }
};
