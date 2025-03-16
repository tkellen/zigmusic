const std = @import("std");
const testing = std.testing;
const music = @import("./index.zig");
const util = @import("test_util.zig");
const Mode = music.scales.Mode;

test "Harmonic Major" {
    // try util.validate("C♭", Mode.Harmonic_Major, "C♭ D♭ E♭ F♭ G♭ A𝄫 B𝄫 C♭");
    // try util.validate("C", Mode.Harmonic_Major, "C D E F G A♭ B C");
    // try util.validate("C♯", Mode.Harmonic_Major, "C♯ D♯ E♯ F♯ G♯ A B♯ C♯");
    // try util.validate("D♭", Mode.Harmonic_Major, "D♭ E♭ F G♭ A♭ B𝄫 C D♭");
    // try util.validate("D", Mode.Harmonic_Major, "D E F♯ G A B♭ C♯ D");
    // try util.validate("E♭", Mode.Harmonic_Major, "E♭ F G A♭ B♭ C♭ D E♭");
    // try util.validate("E", Mode.Harmonic_Major, "E F♯ G♯ A B C D♯ E");
    // try util.validate("F", Mode.Harmonic_Major, "F G A B♭ C D♭ E F");
    // try util.validate("F♯", Mode.Harmonic_Major, "F♯ G♯ A♯ B C♯ D E♯ F♯");
    // try util.validate("G♭", Mode.Harmonic_Major, "G♭ A♭ B♭ C♭ D♭ E𝄫 F G♭");
    // try util.validate("G", Mode.Harmonic_Major, "G A B C D E♭ F♯ G");
    // try util.validate("A♭", Mode.Harmonic_Major, "A♭ B♭ C D♭ E♭ F♭ G A♭");
    // try util.validate("A", Mode.Harmonic_Major, "A B C♯ D E F G♯ A");
    // try util.validate("B♭", Mode.Harmonic_Major, "B♭ C D E♭ F G♭ A B♭");
    // try util.validate("B", Mode.Harmonic_Major, "B C♯ D♯ E F♯ G A♯ B");
}
