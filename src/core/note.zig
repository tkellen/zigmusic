const std = @import("std");
const Letter = @import("letter.zig").Letter;
const Accidental = @import("accidental.zig").Accidental;

pub const Note = struct {
    natural: Letter,
    accidental: Accidental,
    nameBuf: [6]u8,
    nameLen: usize,

    pub fn init(letter: Letter, alteration: Accidental) Note {
        const l = letter.name();
        const a = alteration.name();
        var note = Note{
            .natural = letter,
            .accidental = alteration,
            .nameBuf = undefined,
            .nameLen = l.len + a.len,
        };
        std.mem.copyForwards(u8, note.nameBuf[0..l.len], l);
        std.mem.copyForwards(u8, note.nameBuf[l.len..][0..a.len], a);
        return note;
    }

    pub fn parse(input: []const u8) !Note {
        if (input.len == 0) return error.InvalidNote;
        const letter = Letter.parse(input[0..1]) orelse return error.InvalidLetter;
        const accidental = if (input.len == 1) Accidental.Natural else Accidental.parse(input[1..]) orelse return error.InvalidAccidental;
        return Note.init(letter, accidental);
    }

    pub fn chromaticPosition(self: Note) u8 {
        return @intCast(@mod(@as(i8, @intCast(self.natural.chromaticPosition())) + self.accidental.offset(), 12));
    }

    pub fn spell(letter: Letter, targetPosition: u8) Note {
        const naturalPosition = letter.chromaticPosition();
        const diff = @as(i8, @intCast(targetPosition)) - @as(i8, @intCast(naturalPosition));
        return Note.init(letter, Accidental.fromOffset(diff));
    }

    pub fn name(self: *const Note) []const u8 {
        return self.nameBuf[0..self.nameLen];
    }
};
