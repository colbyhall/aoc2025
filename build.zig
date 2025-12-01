const std = @import("std");
const fmt = std.fmt;

pub fn build(b: *std.Build) void {
    addDay(b, 1);
}

fn addDay(b: *std.Build, index: u32) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const name = fmt.allocPrint(b.allocator, "day{}", .{ index }) catch unreachable;
    const path = fmt.allocPrint(b.allocator, "src/day{}.zig", .{ index }) catch unreachable;

    const day = b.addExecutable(.{
        .name = name,
        .root_module = b.createModule(.{
            .root_source_file = b.path(path),
            .target = target,
            .optimize = optimize,
        }),
    });

    b.installArtifact(day);

    const run_step_desc = fmt.allocPrint(b.allocator, "Run Day{} AOC", .{ index }) catch unreachable;
    const run_step = b.step(name, run_step_desc);

    const run_cmd = b.addRunArtifact(day);
    run_step.dependOn(&run_cmd.step);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
}
