const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "zmusic",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Define the "music" module
    const music = b.addModule("music", .{
        .root_source_file = b.path("src/lib/index.zig"),
    });

    exe.root_module.addImport("music", music);

    b.installArtifact(exe);

    const cmd = b.addRunArtifact(exe);
    if (b.args) |args| {
        cmd.addArgs(args);
    }
    b.step("run", "Run the program").dependOn(&cmd.step);

    // === Fix: Ensure tests can access the "music" module ===
    const tests = b.addTest(.{
        .root_source_file = b.path("test/index.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Attach the "music" module to the test environment
    tests.root_module.addImport("music", music);

    b.step("test", "Run all unit tests").dependOn(&tests.step);
}
