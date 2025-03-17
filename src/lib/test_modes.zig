const std = @import("std");
const music = @import("./index.zig");

const Note = music.notes.Note;
const Step = music.modes.Step;
const Mode = music.modes.Mode;
const Scale = music.scales.Scale;

test "mode.intervals" {
    var buffer: [7]Step = undefined;

    const expected_modes = [_]struct { Mode, [7]Step }{
        // Major Scale Modes
        .{ Mode.Ionian, [_]Step{ .Whole, .Whole, .Half, .Whole, .Whole, .Whole, .Half } },
        .{ Mode.Dorian, [_]Step{ .Whole, .Half, .Whole, .Whole, .Whole, .Half, .Whole } },
        .{ Mode.Phrygian, [_]Step{ .Half, .Whole, .Whole, .Whole, .Half, .Whole, .Whole } },
        .{ Mode.Lydian, [_]Step{ .Whole, .Whole, .Whole, .Half, .Whole, .Whole, .Half } },
        .{ Mode.Mixolydian, [_]Step{ .Whole, .Whole, .Half, .Whole, .Whole, .Half, .Whole } },
        .{ Mode.Aeolian, [_]Step{ .Whole, .Half, .Whole, .Whole, .Half, .Whole, .Whole } },
        .{ Mode.Locrian, [_]Step{ .Half, .Whole, .Whole, .Half, .Whole, .Whole, .Whole } },
        // Harmonic Major Modes
        .{ Mode.Harmonic_Major, [_]Step{ .Whole, .Whole, .Half, .Whole, .Half, .Augmented_Second, .Half } },
        //.{ Mode.Dorian_B5, [_]Step{ .Whole, .Half, .Whole, .Half, .Augmented_Second, .Half, .Whole } },
        //.{ Mode.Phrygian_B4, [_]Step{ .Half, .Whole, .Half, .Augmented_Second, .Half, .Whole, .Whole } },
        //.{ Mode.Lydian_B3, [_]Step{ .Whole, .Half, .Augmented_Second, .Half, .Whole, .Whole, .Half } },
        //.{ Mode.Mixolydian_B9, [_]Step{ .Half, .Augmented_Second, .Half, .Whole, .Whole, .Half, .Whole } },
        //.{ Mode.Lydian_Augmented_Sharp2, [_]Step{ .Augmented_Second, .Half, .Whole, .Whole, .Half, .Whole, .Half } },
        //.{ Mode.Locrian_BB7, [_]Step{ .Half, .Whole, .Whole, .Half, .Whole, .Half, .Augmented_Second } },
        // Harmonic Minor Modes
        .{ Mode.Harmonic_Minor, [_]Step{ .Whole, .Half, .Whole, .Whole, .Half, .Augmented_Second, .Half } },
        //.{ Mode.Locrian_Natural_6, [_]Step{ .Half, .Whole, .Whole, .Half, .Augmented_Second, .Half, .Whole } },
        //.{ Mode.Ionian_Augmented, [_]Step{ .Whole, .Whole, .Half, .Augmented_Second, .Half, .Whole, .Half } },
        //.{ Mode.Dorian_Sharp_4, [_]Step{ .Whole, .Half, .Augmented_Second, .Half, .Whole, .Half, .Whole } },
        //.{ Mode.Phrygian_Dominant, [_]Step{ .Half, .Augmented_Second, .Half, .Whole, .Half, .Whole, .Whole } },
        //.{ Mode.Lydian_Sharp_2, [_]Step{ .Augmented_Second, .Half, .Whole, .Half, .Whole, .Whole, .Half } },
        //.{ Mode.Super_Locrian, [_]Step{ .Half, .Whole, .Half, .Whole, .Whole, .Half, .Augmented_Second } },
    };

    for (expected_modes) |entry| {
        const mode = entry[0];
        const expected = entry[1];
        const actual = mode.intervals(&buffer);
        try std.testing.expectEqualSlices(Step, &expected, actual);
    }
}

test "Ionian (Major)" {
    try validate("C♭", Mode.Ionian, "C♭ D♭ E♭ F♭ G♭ A♭ B♭ C♭");
    try validate("C", Mode.Ionian, "C D E F G A B C");
    try validate("C♯", Mode.Ionian, "C♯ D♯ E♯ F♯ G♯ A♯ B♯ C♯");
    try validate("D♭", Mode.Ionian, "D♭ E♭ F G♭ A♭ B♭ C D♭");
    try validate("D", Mode.Ionian, "D E F♯ G A B C♯ D");
    try validate("D♯", Mode.Ionian, "D♯ E♯ F𝄪 G♯ A♯ B♯ C𝄪 D♯");
    try validate("E♭", Mode.Ionian, "E♭ F G A♭ B♭ C D E♭");
    try validate("E", Mode.Ionian, "E F♯ G♯ A B C♯ D♯ E");
    try validate("E♯", Mode.Ionian, "E♯ F𝄪 G𝄪 A♯ B♯ C𝄪 D𝄪 E♯");
    //try validate("F♭", Mode.Ionian, "F♭ G♭ A♭ B♭ C♭ D♭ E♭ F♭");
    try validate("F", Mode.Ionian, "F G A B♭ C D E F");
    try validate("F♯", Mode.Ionian, "F♯ G♯ A♯ B C♯ D♯ E♯ F♯");
    try validate("G♭", Mode.Ionian, "G♭ A♭ B♭ C♭ D♭ E♭ F G♭");
    try validate("G", Mode.Ionian, "G A B C D E F♯ G");
    try validate("G♯", Mode.Ionian, "G♯ A♯ B♯ C♯ D♯ E♯ F𝄪 G♯");
    try validate("A♭", Mode.Ionian, "A♭ B♭ C D♭ E♭ F G A♭");
    try validate("A", Mode.Ionian, "A B C♯ D E F♯ G♯ A");
    try validate("A♯", Mode.Ionian, "A♯ B♯ C𝄪 D♯ E♯ F𝄪 G𝄪 A♯");
    try validate("B♭", Mode.Ionian, "B♭ C D E♭ F G A B♭");
    try validate("B", Mode.Ionian, "B C♯ D♯ E F♯ G♯ A♯ B");
    try validate("B♯", Mode.Ionian, "B♯ C𝄪 D𝄪 E♯ F𝄪 G𝄪 A𝄪 B♯");
}

test "Dorian" {
    //try validate("C♭", Mode.Dorian, "C♭ D♭ E♭ F♭ G♭ A♭ B♭ C♭");
    try validate("C", Mode.Dorian, "C D E♭ F G A B♭ C");
    try validate("C♯", Mode.Dorian, "C♯ D♯ E F♯ G♯ A♯ B C♯");
    //try validate("D♭", Mode.Dorian, "D♭ E♭ F♭ G♭ A♭ B♭ C D♭");
    //try validate("D", Mode.Dorian, "D E F G A B♭ C D");
    //try validate("D♯", Mode.Dorian, "D♯ E♯ F♯ G♯ A♯ B C♯ D♯");
    //try validate("E♭", Mode.Dorian, "E♭ F G♭ A♭ B♭ C D E♭");
    //try validate("E", Mode.Dorian, "E F♯ G A B C D E");
    //try validate("E♯", Mode.Dorian, "E♯ F𝄪 G♯ A♯ B♯ C♯ D♯ E♯");
    //try validate("F♭", Mode.Dorian, "F♭ G♭ A♭ B♭ C♭ D♭ E♭ F♭");
    try validate("F", Mode.Dorian, "F G A♭ B♭ C D E♭ F");
    //try validate("G♭", Mode.Dorian, "G♭ A♭ B♭ C♭ D♭ E♭ F G♭");
    try validate("G", Mode.Dorian, "G A B♭ C D E F G");
    //try validate("G♯", Mode.Dorian, "G♯ A♯ B C♯ D♯ E F♯ G♯");
    //try validate("A♭", Mode.Dorian, "A♭ B♭ C♭ D♭ E♭ F G A♭");
    try validate("A", Mode.Dorian, "A B C D E F♯ G A");
    //try validate("A♯", Mode.Dorian, "A♯ B♯ C♯ D♯ E F♯ G♯ A♯");
    //try validate("B♭", Mode.Dorian, "B♭ C D♭ E♭ F G A B♭");
    //try validate("B", Mode.Dorian, "B C♯ D E F♯ G A B");
    //try validate("B♯", Mode.Dorian, "B♯ C𝄪 D♯ E♯ F♯ G♯ A♯ B♯");
}

test "Phrygian" {
    //try validate("C♭", Mode.Phrygian, "C♭ D♭ E♭ F♭ G♭ A♭ B♭ C♭");
    try validate("C", Mode.Phrygian, "C D♭ E♭ F G A♭ B♭ C");
    try validate("C♯", Mode.Phrygian, "C♯ D E F♯ G♯ A B C♯");
    //try validate("D♭", Mode.Phrygian, "D♭ E♭ F G♭ A♭ B♭ C D♭");
    try validate("D", Mode.Phrygian, "D E♭ F G A B♭ C D");
    try validate("D♯", Mode.Phrygian, "D♯ E F♯ G♯ A♯ B C♯ D♯");
    //try validate("E♭", Mode.Phrygian, "E♭ F G♭ A♭ B♭ C D E♭");
    //try validate("E", Mode.Phrygian, "E F G A B♭ C D E");
    //try validate("E♯", Mode.Phrygian, "E♯ F G♯ A♯ B C♯ D♯ E♯");
    //try validate("F♭", Mode.Phrygian, "F♭ G♭ A♭ B♭ C♭ D♭ E♭ F♭");
    try validate("F", Mode.Phrygian, "F G♭ A♭ B♭ C D♭ E♭ F");
    //try validate("G♭", Mode.Phrygian, "G♭ A♭ B♭ C♭ D♭ E♭ F G♭");
    try validate("G", Mode.Phrygian, "G A♭ B♭ C D E♭ F G");
    // try validate("G♯", Mode.Phrygian, "G♯ A B♭ C♯ D♯ E F♯ G♯");
    //try validate("A♭", Mode.Phrygian, "A♭ B♭ C D♭ E♭ F G A♭");
    try validate("A", Mode.Phrygian, "A B♭ C D E F G A");
    // try validate("A♯", Mode.Phrygian, "A♯ B C D♯ E F♯ G♯ A♯");
    // try validate("B♭", Mode.Phrygian, "B♭ C D♭ E♭ F G♭ A♭ B♭");
    try validate("B", Mode.Phrygian, "B C D E F♯ G A B");
    //try validate("B♯", Mode.Phrygian, "B♯ C♯ D E♯ F♯ G♯ A♯ B♯");
}

test "Lydian" {
    //try validate("C♭", Mode.Lydian, "C♭ D♭ E♭ F𝄪 G♭ A♭ B♭ C♭");
    try validate("C", Mode.Lydian, "C D E F♯ G A B C");
    //try validate("C♯", Mode.Lydian, "C♯ D♯ E♯ F♯ G♯ A♯ B♯ C♯");
    //try validate("D♭", Mode.Lydian, "D♭ E♭ F F♯ G♭ A♭ B♭ D♭");
    //try validate("D", Mode.Lydian, "D E F# G A B C# D");
    //try validate("D♯", Mode.Lydian, "D♯ E♯ F♯ G♯ A♯ B♯ C♯ D♯");
    //try validate("E♭", Mode.Lydian, "E♭ F G A♯ B♭ C D E♭");
    //try validate("E", Mode.Lydian, "E F# G# A B C# D# E");
    //try validate("E♯", Mode.Lydian, "E♯ F𝄪 G𝄪 A♯ B♯ C♯ D♯ E♯");
    //try validate("F♭", Mode.Lydian, "F♭ G♭ A♭ B♯ C♭ D♭ E♭ F♭");
    try validate("F", Mode.Lydian, "F G A B C D E F");
    //try validate("G♭", Mode.Lydian, "G♭ A♭ B♭ C♯ D♭ E♭ F G♭");
    //try validate("G", Mode.Lydian, "G A B C♯ D E F# G");
    //try validate("G♯", Mode.Lydian, "G♯ A♯ B C D♯ E F♯ G♯");
    //try validate("A♭", Mode.Lydian, "A♭ B♭ C D♯ E♭ F G A♭");
    //try validate("A", Mode.Lydian, "A B C# D E F♯ G# A");
    //try validate("A♯", Mode.Lydian, "A♯ B♯ C𝄪 D♯ E♯ F♯ G♯ A♯");
    try validate("B♭", Mode.Lydian, "B♭ C D E F G A B♭");
    //try validate("B", Mode.Lydian, "B C♯ D E F♯ G♯ A B");
}

test "Mixolydian" {
    //try validate("C♭", Mode.Mixolydian, "C♭ D♭ E♭ F G♭ A♭ B♭ C♭");
    try validate("C", Mode.Mixolydian, "C D E F G A B♭ C");
    //try validate("C♯", Mode.Mixolydian, "C♯ D♯ E♯ F♯ G♯ A B C♯");
    //try validate("D♭", Mode.Mixolydian, "D♭ E♭ F G♭ A♭ B♭ C D♭");
    //try validate("D", Mode.Mixolydian, "D E F# G A B C D");
    //try validate("D♯", Mode.Mixolydian, "D♯ E♯ F♯ G♯ A♯ B C♯ D♯");
    //try validate("E♭", Mode.Mixolydian, "E♭ F G A♭ B♭ C D E♭");
    //try validate("E", Mode.Mixolydian, "E F♯ G A B C♯ D E");
    //try validate("E♯", Mode.Mixolydian, "E♯ F♯ G♯ A♯ B♯ C♯ D♯ E♯");
    //try validate("F♭", Mode.Mixolydian, "F♭ G♭ A♭ B♭ C♭ D♭ E♭ F♭");
    //try validate("F", Mode.Mixolydian, "F G A B♭ C D E F");
    //try validate("G♭", Mode.Mixolydian, "G♭ A♭ B♭ C D♭ E♭ F G♭");
    //try validate("G", Mode.Mixolydian, "G A B♭ C D E♭ F G");
    //try validate("G♯", Mode.Mixolydian, "G♯ A♯ B C D♯ E F♯ G♯");
    //try validate("A♭", Mode.Mixolydian, "A♭ B♭ C D E♭ F G A♭");
    //try validate("A", Mode.Mixolydian, "A B C D E F♯ G A");
    //try validate("A♯", Mode.Mixolydian, "A♯ B♯ C♯ D♯ E F♯ G♯ A♯");
    //try validate("B♭", Mode.Mixolydian, "B♭ C D♭ E♭ F G A B♭");
    //try validate("B", Mode.Mixolydian, "B C♯ D E F♯ G A B");
}

test "Aeolian (Minor)" {
    try validate("C♭", Mode.Aeolian, "C♭ D♭ E𝄫 F♭ G♭ A𝄫 B𝄫 C♭");
    try validate("C", Mode.Aeolian, "C D E♭ F G A♭ B♭ C");
    try validate("C♯", Mode.Aeolian, "C♯ D♯ E F♯ G♯ A B C♯");
    try validate("D♭", Mode.Aeolian, "D♭ E♭ F♭ G♭ A♭ B𝄫 C♭ D♭");
    try validate("D", Mode.Aeolian, "D E F G A B♭ C D");
    try validate("D♯", Mode.Aeolian, "D♯ E♯ F♯ G♯ A♯ B C♯ D♯");
    try validate("E♭", Mode.Aeolian, "E♭ F G♭ A♭ B♭ C♭ D♭ E♭");
    try validate("E", Mode.Aeolian, "E F♯ G A B C D E");
    try validate("E♯", Mode.Aeolian, "E♯ F𝄪 G♯ A♯ B♯ C♯ D♯ E♯");
    //try validate("F♭", Mode.Aeolian, "F♭ G♭ A♭ B♭ C♭ D♭ E♭ F♭");
    try validate("F", Mode.Aeolian, "F G A♭ B♭ C D♭ E♭ F");
    try validate("G♭", Mode.Aeolian, "G♭ A♭ B𝄫 C♭ D♭ E𝄫 F♭ G♭");
    try validate("G", Mode.Aeolian, "G A B♭ C D E♭ F G");
    try validate("G♯", Mode.Aeolian, "G♯ A♯ B C♯ D♯ E F♯ G♯");
    try validate("A♭", Mode.Aeolian, "A♭ B♭ C♭ D♭ E♭ F♭ G♭ A♭");
    try validate("A", Mode.Aeolian, "A B C D E F G A");
    try validate("A♯", Mode.Aeolian, "A♯ B♯ C♯ D♯ E♯ F♯ G♯ A♯");
    try validate("B♭", Mode.Aeolian, "B♭ C D♭ E♭ F G♭ A♭ B♭");
    try validate("B", Mode.Aeolian, "B C♯ D E F♯ G A B");
    try validate("B♯", Mode.Aeolian, "B♯ C𝄪 D♯ E♯ F𝄪 G♯ A♯ B♯");
}

test "Locrian" {
    //try validate("C♭", Mode.Locrian, "C♭ D♭ E♭ F♭ G♭ A♭ B♭ C♭");
    try validate("C", Mode.Locrian, "C D♭ E♭ F G♭ A♭ B♭ C");
    //try validate("C♯", Mode.Locrian, "C♯ D E F♯ G♯ A B C♯");
    //try validate("D♭", Mode.Locrian, "D♭ E♭ F G♭ A♭ B♭ C D♭");
    //try validate("D", Mode.Locrian, "D E♭ F G A♭ B♭ C D");
    try validate("D♯", Mode.Locrian, "D♯ E F♯ G♯ A B C♯ D♯");
    //try validate("E♭", Mode.Locrian, "E♭ F G♭ A♭ B♭ C D E♭");
    //try validate("E", Mode.Locrian, "E F G A♭ B♭ C D E");
    //try validate("E♯", Mode.Locrian, "E♯ F G♯ A B C♯ D♯ E♯");
    //try validate("F♭", Mode.Locrian, "F♭ G♭ A♭ B♭ C♭ D♭ E♭ F♭");
    //try validate("F", Mode.Locrian, "F G A♭ B♭ C D♭ E♭ F");
    //try validate("G♭", Mode.Locrian, "G♭ A♭ B♭ C D♭ E♭ F G♭");
    //try validate("G", Mode.Locrian, "G A♭ B♭ C D E♭ F G");
    //try validate("G♯", Mode.Locrian, "G♯ A B C♯ D♯ E F♯ G♯");
    //try validate("A♭", Mode.Locrian, "A♭ B♭ C D♭ E♭ F♭ G♭ A♭");
    try validate("A", Mode.Locrian, "A B♭ C D E♭ F G A");
    //try validate("A♯", Mode.Locrian, "A♯ B C D♯ E F♯ G♯ A♯");
    //try validate("B♭", Mode.Locrian, "B♭ C D♭ E♭ F G♭ A♭ B♭");
    //try validate("B", Mode.Locrian, "B C♯ D E F♯ G A B");
}

test "Harmonic Major" {
    //try validate("C♭", Mode.Harmonic_Major, "C♭ D♭ E♭ F♭ G♭ A♭ B♭ C♭");
    try validate("C", Mode.Harmonic_Major, "C D E F G A♭ B C");
    try validate("C♯", Mode.Harmonic_Major, "C♯ D♯ E♯ F♯ G♯ A B♯ C♯");
    try validate("D♭", Mode.Harmonic_Major, "D♭ E♭ F G♭ A♭ B𝄫 C D♭");
    try validate("D", Mode.Harmonic_Major, "D E F♯ G A B♭ C♯ D");
    try validate("E♭", Mode.Harmonic_Major, "E♭ F G A♭ B♭ C♭ D E♭");
    try validate("E", Mode.Harmonic_Major, "E F♯ G♯ A B C D♯ E");
    //try validate("E♯", Mode.Harmonic_Major, "E♯ F𝄪 G𝄪 A♯ B C♯ D𝄪 E♯");
    //try validate("F♭", Mode.Harmonic_Major, "F♭ G♭ A♭ B♭ C♭ D♭ E♭ F♭");
    try validate("F", Mode.Harmonic_Major, "F G A B♭ C D♭ E F");
    try validate("F♯", Mode.Harmonic_Major, "F♯ G♯ A♯ B C♯ D E♯ F♯");
    try validate("G♭", Mode.Harmonic_Major, "G♭ A♭ B♭ C♭ D♭ E𝄫 F G♭");
    try validate("G", Mode.Harmonic_Major, "G A B C D E♭ F♯ G");
    try validate("A♭", Mode.Harmonic_Major, "A♭ B♭ C D♭ E♭ F♭ G A♭");
    try validate("A", Mode.Harmonic_Major, "A B C♯ D E F G♯ A");
    try validate("B♭", Mode.Harmonic_Major, "B♭ C D E♭ F G♭ A B♭");
    try validate("B", Mode.Harmonic_Major, "B C♯ D♯ E F♯ G A♯ B");
}

test "Harmonic Minor" {
    //try validate("C♭", Mode.Harmonic_Minor, "C♭ D♭ E♭ F G A♭ B C♭");
    try validate("C", Mode.Harmonic_Minor, "C D E♭ F G A♭ B C");
    try validate("C♯", Mode.Harmonic_Minor, "C♯ D♯ E F♯ G♯ A B♯ C♯");
    try validate("D", Mode.Harmonic_Minor, "D E F G A B♭ C♯ D");
    try validate("D♯", Mode.Harmonic_Minor, "D♯ E♯ F♯ G♯ A♯ B C𝄪 D♯");
    try validate("E♭", Mode.Harmonic_Minor, "E♭ F G♭ A♭ B♭ C♭ D E♭");
    try validate("E", Mode.Harmonic_Minor, "E F♯ G A B C D♯ E");
    //try validate("E♯", Mode.Harmonic_Minor, "E♯ F♯ G♯ A♯ B C♯ D𝄪 E♯");
    //try validate("F♭", Mode.Harmonic_Minor, "F♭ G♭ A♭ B♭ C♭ D♭ E♭ F♭");
    try validate("F", Mode.Harmonic_Minor, "F G A♭ B♭ C D♭ E F");
    try validate("F♯", Mode.Harmonic_Minor, "F♯ G♯ A B C♯ D E♯ F♯");
    try validate("G", Mode.Harmonic_Minor, "G A B♭ C D E♭ F♯ G");
    try validate("G♯", Mode.Harmonic_Minor, "G♯ A♯ B C♯ D♯ E F𝄪 G♯");
    try validate("A", Mode.Harmonic_Minor, "A B C D E F G♯ A");
    try validate("A♯", Mode.Harmonic_Minor, "A♯ B♯ C♯ D♯ E♯ F♯ G𝄪 A♯");
    try validate("B", Mode.Harmonic_Minor, "B C♯ D E F♯ G A♯ B");
    try validate("B♭", Mode.Harmonic_Minor, "B♭ C D♭ E♭ F G♭ A B♭");
}

pub fn validate(root: []const u8, mode: music.modes.Mode, expected: []const u8) !void {
    var buffer: [16]music.notes.Note = undefined;
    var actualBuffer: [128]u8 = undefined;
    const key = try Note.parse(root);
    const scale = Scale{ .mode = mode };
    const notes = scale.build(key, &buffer);
    var fbs = std.io.fixedBufferStream(&actualBuffer);
    const writer = fbs.writer();
    for (notes, 0..) |note, idx| {
        if (idx > 0) try writer.writeAll(" ");
        try writer.print("{s}{s}", .{ note.natural.name(), note.accidental.name() });
    }
    const actualString = fbs.getWritten();
    try std.testing.expectEqualStrings(expected, actualString);
}
