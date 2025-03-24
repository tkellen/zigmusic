const std = @import("std");

pub const Chromatic = @import("chromatic.zig");
pub const Diatonic = @import("diatonic.zig");
pub const HarmonicMajor = @import("harmonic_major.zig");
pub const HarmonicMinor = @import("harmonic_minor.zig");
pub const MelodicMinor = @import("melodic_minor.zig");
pub const WholeTone = @import("wholetone.zig");
pub const MajorPentatonic = @import("major_pentatonic.zig");

test {
    std.testing.refAllDeclsRecursive(@This());
}
