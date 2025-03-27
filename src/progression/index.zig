const std = @import("std");

pub const TwelveBarBlues = @import("twelve_bar_blues.zig");

test {
    std.testing.refAllDeclsRecursive(@This());
}
