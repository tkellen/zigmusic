pub const notes = @import("notes.zig");
pub const modes = @import("modes.zig");
pub const scales = @import("scales.zig");

test {
    _ = @import("./test_notes.zig");
    _ = @import("./test_modes.zig");
}
