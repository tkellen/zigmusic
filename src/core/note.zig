const std = @import("std");
const Letter = @import("letter.zig").Letter;
const Accidental = @import("accidental.zig").Accidental;

pub const Note = struct {
    natural: Letter,
    accidental: Accidental,

    pub fn chromaticPosition(self: Note) u8 {
        return @intCast(@mod(@as(i8, @intCast(self.natural.chromaticPosition())) + self.accidental.offset(), 12));
    }

    pub fn spell(letter: Letter, targetPosition: u8) Note {
        const naturalPosition = letter.chromaticPosition();
        const diff = @as(i8, @intCast(targetPosition)) - @as(i8, @intCast(naturalPosition));
        return Note{
            .natural = letter,
            .accidental = .fromOffset(diff),
        };
    }

    pub fn parse(input: []const u8) !Note {
        if (input.len == 0) return error.InvalidNote;
        const natural = Letter.parse(input[0..1]) orelse return error.InvalidLetter;
        const accidental = if (input.len == 1) Accidental.Natural else Accidental.parse(input[1..]) orelse return error.InvalidAccidental;
        return Note{
            .natural = natural,
            .accidental = accidental,
        };
    }

    pub fn name(self: Note) []const u8 {
        var local_buf: [5]u8 = undefined;
        return self.nameWithBuffer(local_buf[0..]);
    }

    pub fn nameWithBuffer(self: Note, buf: []u8) []const u8 {
        const l = self.natural.name();
        const a = self.accidental.name();
        const total = l.len + a.len;
        std.mem.copyForwards(u8, buf[0..l.len], l);
        std.mem.copyForwards(u8, buf[l.len..][0..a.len], a);
        return buf[0..total];
    }
};
