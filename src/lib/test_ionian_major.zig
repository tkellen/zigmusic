const std = @import("std");
const util = @import("test_util.zig");
const music = @import("./index.zig");
const Mode = music.scales.Mode;

test "Ionian Major" {
    try util.validate("C♭", Mode.Ionian_Major, "C♭ D♭ E♭ F♭ G♭ A♭ B♭ C♭");
    try util.validate("C", Mode.Ionian_Major, "C D E F G A B C");
    try util.validate("C♯", Mode.Ionian_Major, "C♯ D♯ E♯ F♯ G♯ A♯ B♯ C♯");
    try util.validate("D♭", Mode.Ionian_Major, "D♭ E♭ F G♭ A♭ B♭ C D♭");
    try util.validate("D", Mode.Ionian_Major, "D E F♯ G A B C♯ D");
    try util.validate("D♯", Mode.Ionian_Major, "D♯ E♯ F𝄪 G♯ A♯ B♯ C𝄪 D♯");
    try util.validate("E♭", Mode.Ionian_Major, "E♭ F G A♭ B♭ C D E♭");
    try util.validate("E", Mode.Ionian_Major, "E F♯ G♯ A B C♯ D♯ E");
    try util.validate("F", Mode.Ionian_Major, "F G A B♭ C D E F");
    try util.validate("F♯", Mode.Ionian_Major, "F♯ G♯ A♯ B C♯ D♯ E♯ F♯");
    try util.validate("G♭", Mode.Ionian_Major, "G♭ A♭ B♭ C♭ D♭ E♭ F G♭");
    try util.validate("G", Mode.Ionian_Major, "G A B C D E F♯ G");
    try util.validate("G♯", Mode.Ionian_Major, "G♯ A♯ B♯ C♯ D♯ E♯ F𝄪 G♯");
    try util.validate("A♭", Mode.Ionian_Major, "A♭ B♭ C D♭ E♭ F G A♭");
    try util.validate("A", Mode.Ionian_Major, "A B C♯ D E F♯ G♯ A");
    try util.validate("A♯", Mode.Ionian_Major, "A♯ B♯ C𝄪 D♯ E♯ F𝄪 G𝄪 A♯");
    try util.validate("B♭", Mode.Ionian_Major, "B♭ C D E♭ F G A B♭");
    try util.validate("B", Mode.Ionian_Major, "B C♯ D♯ E F♯ G♯ A♯ B");
    try util.validate("B♯", Mode.Ionian_Major, "B♯ C𝄪 D𝄪 E♯ F𝄪 G𝄪 A𝄪 B♯");
}
