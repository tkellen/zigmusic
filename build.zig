const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const core_mod = b.createModule(.{
        .root_source_file = b.path("src/core/index.zig"),
        .target = target,
        .optimize = optimize,
    });

    const scales_mod = b.createModule(.{
        .root_source_file = b.path("src/scales/index.zig"),
        .target = target,
        .optimize = optimize,
    });

    scales_mod.addImport("core", core_mod);
    exe_mod.addImport("core", core_mod);
    exe_mod.addImport("scales", scales_mod);

    const exe = b.addExecutable(.{ .name = "foo", .root_module = exe_mod });

    // This declares intent for the executable to be installed into the
    // standard location when the user invokes the "install" step (the default
    // step when running `zig build`).
    b.installArtifact(exe);

    // This *creates* a Run step in the build graph, to be executed when another
    // step is evaluated that depends on it. The next line below will establish
    // such a dependency.
    const run_cmd = b.addRunArtifact(exe);

    // By making the run step depend on the install step, it will be run from the
    // installation directory rather than directly from within the cache directory.
    // This is not necessary, however, if the application depends on other installed
    // files, this ensures they will be present and in the expected location.
    run_cmd.step.dependOn(b.getInstallStep());

    // This allows the user to pass arguments to the application in the build
    // command itself, like this: `zig build run -- arg1 arg2 etc`
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const core_unit_tests = b.addTest(.{ .root_module = core_mod });
    const scale_unit_tests = b.addTest(.{ .root_module = scales_mod });
    const exe_unit_tests = b.addTest(.{ .root_module = exe_mod });

    const run_core_unit_tests = b.addRunArtifact(core_unit_tests);
    const run_scales_unit_tests = b.addRunArtifact(scale_unit_tests);
    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_core_unit_tests.step);
    test_step.dependOn(&run_scales_unit_tests.step);
    test_step.dependOn(&run_exe_unit_tests.step);
}
