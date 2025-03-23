const std = @import("std");
const util = @import("util.zig");

pub const Letter = enum(u8) {
    C,
    D,
    E,
    F,
    G,
    A,
    B,

    pub fn name(self: Letter) []const u8 {
        return @tagName(self);
    }

    pub fn parse(input: []const u8) ?Letter {
        return std.meta.stringToEnum(Letter, input);
    }

    pub fn fifthsFromC(self: Letter) i8 {
        return switch (self) {
            .C => 0,
            .G => 1,
            .D => 2,
            .A => 3,
            .E => 4,
            .B => 5,
            .F => -1,
        };
    }

    pub inline fn circleOfFifths() [7]Letter {
        return [7]Letter{
            .C,
            .G,
            .D,
            .A,
            .E,
            .B,
            .F,
        };
    }

    pub fn chromaticPosition(self: Letter) u8 {
        return switch (self) {
            .C => 0,
            .D => 2,
            .E => 4,
            .F => 5,
            .G => 7,
            .A => 9,
            .B => 11,
        };
    }

    pub fn diatonicStep(self: Letter, step: i8) Letter {
        const start: i8 = @as(i8, @intCast(@intFromEnum(self)));
        const end: i8 = @mod(start + step, 7);
        return @enumFromInt(@as(u8, @intCast(end)));
    }

    pub fn next(self: Letter) Letter {
        return self.diatonicStep(1);
    }

    pub fn previous(self: Letter) Letter {
        return self.diatonicStep(-1);
    }

    pub fn fromFifths(fifths: i8) Letter {
        const wrapped = @mod(fifths, 7);
        return Letter.circleOfFifths()[@intCast(wrapped)];
    }

    pub fn enharmonic(self: Letter, target: u8) Note {
        // this works for diatonic scales but not whole tone
        // const diff = util.asi8(util.wrapChromatic(target)) - util.asi8(self.chromaticPosition());
        // return Note{
        //     .natural = self,
        //     .accidental = .fromOffset(diff),
        // };
        const desired = util.wrapChromatic(target);
        for (std.meta.tags(Accidental)) |accidental| {
            const note = Note{
                .natural = self,
                .accidental = accidental,
            };
            if (note.chromaticPosition() == desired) {
                return note;
            }
        }
        unreachable;
    }
};

pub const Accidental = enum(i8) {
    DoubleFlat,
    Flat,
    Natural,
    Sharp,
    DoubleSharp,

    pub fn name(self: Accidental) []const u8 {
        return switch (self) {
            .DoubleFlat => "𝄫",
            .Flat => "♭",
            .Natural => "",
            .Sharp => "♯",
            .DoubleSharp => "𝄪",
        };
    }

    pub fn parse(input: []const u8) ?Accidental {
        const view = std.unicode.Utf8View.init(input) catch return null;
        var accidentals = view.iterator();
        var flats: i8 = 0;
        var sharps: i8 = 0;
        while (accidentals.nextCodepoint()) |code_point| {
            switch (code_point) {
                '♮' => return .Natural,
                'b', '♭' => flats += 1,
                '#', '♯' => sharps += 1,
                '𝄫' => flats += 2,
                'x', '𝄪' => sharps += 2,
                else => return null,
            }
        }
        if (flats > 0 and sharps > 0) {
            return null;
        }
        return .fromOffset(sharps - flats);
    }

    pub fn offset(self: Accidental) i8 {
        return switch (self) {
            .DoubleFlat => -2,
            .Flat => -1,
            .Natural => 0,
            .Sharp => 1,
            .DoubleSharp => 2,
        };
    }

    pub fn fromOffset(input: i8) Accidental {
        var normalized = input;
        while (normalized > 3) normalized -= 12;
        while (normalized < -3) normalized += 12;
        return switch (normalized) {
            -2 => .DoubleFlat,
            -1 => .Flat,
            0 => .Natural,
            1 => .Sharp,
            2 => .DoubleSharp,
            else => unreachable, // This should never be reached if we normalized correctly
        };
    }
};

pub const Note = struct {
    natural: Letter,
    accidental: Accidental,

    pub fn parse(input: []const u8) !Note {
        if (input.len == 0)
            return error.InvalidNote;

        const natural = Letter.parse(input[0..1]) orelse return error.InvalidLetter;

        const accidental = if (input.len == 1)
            Accidental.Natural
        else
            Accidental.parse(input[1..]) orelse return error.InvalidAccidental;

        return Note{
            .natural = natural,
            .accidental = accidental,
        };
    }

    pub fn fifthsFromC(self: Note) i8 {
        return self.natural.fifthsFromC() + self.accidental.offset();
    }

    pub fn chromaticPosition(self: Note) u8 {
        return util.addChromatic(
            self.natural.chromaticPosition(),
            self.accidental.offset(),
        );
    }

    pub fn enharmonics(self: Note, allocator: std.mem.Allocator) ![]Note {
        return enharmonicsAt(self.chromaticPosition(), allocator);
    }
};

pub fn enharmonicsAt(position: u8, allocator: std.mem.Allocator) ![]Note {
    var equivalents = std.ArrayList(Note).init(allocator);
    errdefer equivalents.deinit();
    const pos = util.wrapChromatic(position);
    for (std.meta.tags(Letter)) |letter| {
        for (std.meta.tags(Accidental)) |accidental| {
            const note = Note{
                .natural = letter,
                .accidental = accidental,
            };

            if (note.chromaticPosition() == pos) {
                try equivalents.append(note);
            }
        }
    }

    return equivalents.toOwnedSlice();
}
