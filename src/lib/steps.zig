pub const Step = enum(u8) {
    Half,
    Whole,
    Second,
    Augmented_Second,
    Third,
    Fourth,
    Fifth,
    Sixth,
    Seventh,
    Octave,

    pub fn chromatic(self: Step) i8 {
        return switch (self) {
            .Half => 1,
            .Whole => 2,
            .Second => 2,
            .Augmented_Second => 3,
            .Third => 3,
            .Fourth => 5,
            .Fifth => 7,
            .Sixth => 9,
            .Seventh => 11,
            .Octave => 12,
        };
    }
};
