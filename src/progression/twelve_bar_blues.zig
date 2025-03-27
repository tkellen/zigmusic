const std = @import("std");
const core = @import("core");
const scale = @import("scale");
const Progression = @import("progression");
const Note = core.Note;
const Scale = scale.Degree;

const progression = [12]scale.Degree{
    scale.Degree.First,
    scale.Degree.First,
    scale.Degree.First,
    scale.Degree.First,
    scale.Degree.Fourth,
    scale.Degree.Fourth,
    scale.Degree.First,
    scale.Degree.First,
    scale.Degree.Fifth,
    scale.Degree.Fourth,
    scale.Degree.First,
    scale.Degree.First,
};

pub fn build(notes: []const Note) [12]Note {
    var result: [12]Note = undefined;
    for (progression, 0..) |deg, i| {
        result[i] = notes[deg.index()];
    }
    return result;
}
