const std = @import("std");

const Letter = enum { C, D, E };
const Accidental = enum { Natural, Sharp, Flat };

const Note = struct {
    natural: Letter,
    accidental: Accidental,
    pub fn name(self: Note) []const u8 {
        return switch (self.natural) {
            .C => "C",
            .D => "D",
            .E => "E",
        };
    }
};

pub fn main() void {
    // Properly initialize the fixed-size array of `Note` structs
    const equivalents = [3]Note{
        Note{ .natural = Letter.C, .accidental = Accidental.Natural },
        Note{ .natural = Letter.C, .accidental = Accidental.Natural },
        Note{ .natural = Letter.C, .accidental = Accidental.Natural },
    };

    // Print the names of the notes in the array
    for (equivalents) |note| {
        std.debug.print("{s}\n", .{note.name()});
    }
}
