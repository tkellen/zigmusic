pub const chords = @import("chords.zig");
pub const notes = @import("notes.zig");
pub const scales = @import("scales.zig");

test {
    _ = @import("scales.zig");
    _ = @import("notes.zig");
    _ = @import("./test_aeolian_minor.zig");
    _ = @import("./test_harmonic_major.zig");
    _ = @import("./test_harmonic_minor.zig");
    _ = @import("./test_ionian_major.zig");
}
