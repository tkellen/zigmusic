/// This function wraps a chromatic position into the 0–11 range.
/// It accepts signed or unsigned input and uses true modulo
/// to correctly handle negative values (e.g., -1 becomes 11).
pub fn wrapChromatic(pos: anytype) u8 {
    return @intCast(@mod(asi8(pos), 12));
}

/// Adds a chromatic interval to a base and wraps to 0–11.
/// Useful for upward transpositions or applying intervals.
pub fn addChromatic(base: anytype, step: anytype) u8 {
    return wrapChromatic(@as(i16, @intCast(base)) + @as(i16, @intCast(step)));
}

pub fn asi8(input: anytype) i8 {
    return @as(i8, @intCast(input));
}
