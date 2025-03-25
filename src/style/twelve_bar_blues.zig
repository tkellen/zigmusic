// const std = @import("std");

// const scale = @import("scale");
// const Note = @import("core").Note;

// const progression = [12]scale.Degree{
//     scale.Degree.First,
//     scale.Degree.First,
//     scale.Degree.First,
//     scale.Degree.First,
//     scale.Degree.Fourth,
//     scale.Degree.Fourth,
//     scale.Degree.First,
//     scale.Degree.First,
//     scale.Degree.Fifth,
//     scale.Degree.Fourth,
//     scale.Degree.First,
//     scale.Degree.First,
// };

// pub fn build(key: Note, scaleType: anytype) !void {
//     const notes = scaleType.generate(key);
//     std.debug.print("12-Bar Blues progression for key {s}{s}:\n", .{ key.natural.name(), key.accidental.name() });
//     for (progression, 0..) |deg, i| {
//         const note = notes[deg.index()];
//         std.debug.print("Bar {d}: {s}{s} ({s})\n", .{ i + 1, note.natural.name(), note.accidental.name(), deg.name() });
//     }
// }

// test "TwelveBarBlues" {
//     const key = try Note.parse("G");
//     try build(key, scale.MajorPentatonic);
// }
