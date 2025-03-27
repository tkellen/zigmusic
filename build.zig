const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const core = b.createModule(.{ .root_source_file = b.path("src/core/index.zig"), .target = target, .optimize = optimize });
    const scale = b.createModule(.{ .root_source_file = b.path("src/scale/index.zig"), .target = target, .optimize = optimize });
    const chord = b.createModule(.{ .root_source_file = b.path("src/chord/index.zig"), .target = target, .optimize = optimize });
    const progression = b.createModule(.{ .root_source_file = b.path("src/progression/index.zig"), .target = target, .optimize = optimize });
    const cli = b.createModule(.{ .root_source_file = b.path("src/cli/index.zig"), .target = target, .optimize = optimize });
    const exe = b.createModule(.{ .root_source_file = b.path("src/main.zig"), .target = target, .optimize = optimize });

    scale.addImport("core", core);
    chord.addImport("scale", scale);
    chord.addImport("core", core);
    progression.addImport("core", core);
    progression.addImport("scale", scale);
    cli.addImport("core", core);
    cli.addImport("scale", scale);
    cli.addImport("chord", scale);
    cli.addImport("progression", progression);
    exe.addImport("cli", cli);
    exe.addImport("core", core);

    const core_test = b.addTest(.{ .root_module = core });
    const scale_test = b.addTest(.{ .root_module = scale });
    const chord_test = b.addTest(.{ .root_module = chord });
    const progression_test = b.addTest(.{ .root_module = progression });
    const cli_test = b.addTest(.{ .root_module = cli });
    const exe_test = b.addTest(.{ .root_module = exe });

    const run_core_test = b.addRunArtifact(core_test);
    const run_scale_test = b.addRunArtifact(scale_test);
    const run_chord_test = b.addRunArtifact(chord_test);
    const run_progression_test = b.addRunArtifact(progression_test);
    const run_cli_test = b.addRunArtifact(cli_test);
    const run_exe_test = b.addRunArtifact(exe_test);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_core_test.step);
    test_step.dependOn(&run_scale_test.step);
    test_step.dependOn(&run_chord_test.step);
    test_step.dependOn(&run_progression_test.step);
    test_step.dependOn(&run_cli_test.step);
    test_step.dependOn(&run_exe_test.step);

    const zmusic = b.addExecutable(.{ .name = "zmusic", .root_module = exe });
    b.installArtifact(zmusic);
    const run_cmd = b.addRunArtifact(zmusic);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
