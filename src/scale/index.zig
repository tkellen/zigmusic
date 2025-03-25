const std = @import("std");
const Note = @import("core").Note;

pub const Chromatic = @import("chromatic.zig").Chromatic;
pub const Diatonic = @import("diatonic.zig").Diatonic;
pub const HarmonicMajor = @import("harmonic_major.zig").HarmonicMajor;
pub const HarmonicMinor = @import("harmonic_minor.zig").HarmonicMinor;
pub const MelodicMinor = @import("melodic_minor.zig").MelodicMinor;
pub const WholeTone = @import("wholetone.zig").WholeTone;
pub const MajorBlues = @import("major_blues.zig").MajorBlues;
//pub const MinorBlues = @import("minor_blues.zig");
pub const MajorPentatonic = @import("major_pentatonic.zig").MajorPentatonic;
pub const MinorPentatonic = @import("minor_pentatonic.zig").MinorPentatonic;

test {
    std.testing.refAllDeclsRecursive(@This());
}
