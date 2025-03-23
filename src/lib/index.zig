pub const note = @import("note.zig");
pub const scale = @import("scale.zig");
pub const printer = @import("printer.zig");

test {
    _ = @import("./test_note.zig");
    _ = @import("./test_scale.zig");
}
