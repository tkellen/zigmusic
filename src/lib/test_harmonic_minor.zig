const std = @import("std");
const testing = std.testing;
const util = @import("test_util.zig");
const music = @import("./index.zig");
const Mode = music.scales.Mode;

test "Harmonic Minor" {
    try util.validate("C", Mode.Harmonic_Minor, "C D E♭ F G A♭ B C");
    // try util.validate("C♯", Mode.Harmonic_Minor, "C♯ D♯ E F♯ G♯ A B♯ C♯");
    // try util.validate("D", Mode.Harmonic_Minor, "D E F G A B♭ C♯ D");
    // try util.validate("D♯", Mode.Harmonic_Minor, "D♯ E♯ F♯ G♯ A♯ B C𝄪 D♯");
    // try util.validate("E♭", Mode.Harmonic_Minor, "E♭ F G♭ A♭ B♭ C♭ D E♭");
    // try util.validate("E", Mode.Harmonic_Minor, "E F♯ G A B C D♯ E");
    // try util.validate("F", Mode.Harmonic_Minor, "F G A♭ B♭ C D♭ E F");
    // try util.validate("F♯", Mode.Harmonic_Minor, "F♯ G♯ A B C♯ D E♯ F♯");
    // try util.validate("G", Mode.Harmonic_Minor, "G A B♭ C D E♭ F♯ G");
    // try util.validate("G♯", Mode.Harmonic_Minor, "G♯ A♯ B C♯ D♯ E F𝄪 G♯");
    // try util.validate("A", Mode.Harmonic_Minor, "A B C D E F G♯ A");
    // try util.validate("A♯", Mode.Harmonic_Minor, "A♯ B♯ C♯ D♯ E♯ F♯ G𝄪 A♯");
    // try util.validate("B", Mode.Harmonic_Minor, "B C♯ D E F♯ G A♯ B");
    // try util.validate("B♭", Mode.Harmonic_Minor, "B♭ C D♭ E♭ F G♭ A B♭");
}
