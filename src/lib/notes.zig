const std = @import("std");
const steps = @import("steps.zig");

const allocator = std.heap.page_allocator;

pub const Pitch = enum(u8) {
    C,
    D,
    E,
    F,
    G,
    A,
    B,

    pub fn next(self: Pitch) Pitch {
        return @enumFromInt(((@intFromEnum(self) + 1) % 7));
    }

    pub fn position(self: Pitch) u8 {
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

    pub fn name(self: Pitch) []const u8 {
        return @tagName(self);
    }
};

pub const Accidental = enum {
    Natural,
    Sharp,
    Flat,
    DoubleSharp,
    DoubleFlat,

    pub fn name(self: Accidental) []const u8 {
        return switch (self) {
            .Natural => "",
            .Sharp => "♯",
            .Flat => "♭",
            .DoubleSharp => "𝄪",
            .DoubleFlat => "𝄫",
        };
    }
};

pub const Note = struct {
    pitch: Pitch,
    accidental: Accidental,

    pub fn position(self: Note) u8 {
        return switch (self.accidental) {
            .Natural => self.pitch.position(),
            .Sharp => (self.pitch.position() + 1) % 12,
            .Flat => (self.pitch.position() + 11) % 12,
            .DoubleSharp => (self.pitch.position() + 2) % 12,
            .DoubleFlat => (self.pitch.position() + 10) % 12,
        };
    }

    pub fn stepBy(self: Note, movement: steps.Step) Note {
        const targetPosition: i8 = @intCast((self.position() + movement.value()) % 12);
        const nextPitch = self.pitch.next();
        const nextPitchPosition: i8 = @intCast(nextPitch.position());
        const diff: i8 = @mod(targetPosition - nextPitchPosition + 12, 12);
        return Note{
            .pitch = nextPitch,
            .accidental = switch (diff) {
                0 => .Natural,
                1 => .Sharp,
                2 => .DoubleSharp,
                10 => .DoubleFlat,
                11 => .Flat,
                else => .Natural,
            },
        };
    }

    pub fn name(self: Note) []const u8 {
        const result = std.fmt.allocPrint(allocator, "{s}{s}", .{
            @tagName(self.pitch),
            self.accidental.name(),
        }) catch return "<Error>";
        return result;
    }
};
