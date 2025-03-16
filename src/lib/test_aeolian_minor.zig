const std = @import("std");
const util = @import("test_util.zig");
const music = @import("./index.zig");
const Mode = music.scales.Mode;

test "Aeolian Minor" {
    try util.validate("C♭", Mode.Aeolian_Minor, "C♭ D♭ E𝄫 F♭ G♭ A𝄫 B𝄫 C♭");
    try util.validate("C", Mode.Aeolian_Minor, "C D E♭ F G A♭ B♭ C");
    try util.validate("C♯", Mode.Aeolian_Minor, "C♯ D♯ E F♯ G♯ A B C♯");
    try util.validate("D♭", Mode.Aeolian_Minor, "D♭ E♭ F♭ G♭ A♭ B𝄫 C♭ D♭");
    try util.validate("D", Mode.Aeolian_Minor, "D E F G A B♭ C D");
    try util.validate("D♯", Mode.Aeolian_Minor, "D♯ E♯ F♯ G♯ A♯ B C♯ D♯");
    try util.validate("E♭", Mode.Aeolian_Minor, "E♭ F G♭ A♭ B♭ C♭ D♭ E♭");
    try util.validate("E", Mode.Aeolian_Minor, "E F♯ G A B C D E");
    try util.validate("F", Mode.Aeolian_Minor, "F G A♭ B♭ C D♭ E♭ F");
    try util.validate("G♭", Mode.Aeolian_Minor, "G♭ A♭ B𝄫 C♭ D♭ E𝄫 F♭ G♭");
    try util.validate("G", Mode.Aeolian_Minor, "G A B♭ C D E♭ F G");
    try util.validate("G♯", Mode.Aeolian_Minor, "G♯ A♯ B C♯ D♯ E F♯ G♯");
    try util.validate("A♭", Mode.Aeolian_Minor, "A♭ B♭ C♭ D♭ E♭ F♭ G♭ A♭");
    try util.validate("A", Mode.Aeolian_Minor, "A B C D E F G A");
    try util.validate("A♯", Mode.Aeolian_Minor, "A♯ B♯ C♯ D♯ E♯ F♯ G♯ A♯");
    try util.validate("B♭", Mode.Aeolian_Minor, "B♭ C D♭ E♭ F G♭ A♭ B♭");
    try util.validate("B", Mode.Aeolian_Minor, "B C♯ D E F♯ G A B");
    try util.validate("B♯", Mode.Aeolian_Minor, "B♯ C𝄪 D♯ E♯ F𝄪 G♯ A♯ B♯");
}
