const std = @import("std");
const math = std.math;
const time = std.time;

pub fn bench(comptime name: []const u8, comptime function: anytype) !void {
    const bench_count = 100;
    var accum: f64 = 0;
    var min: f64 = math.floatMax(f64);
    var max: f64 = 0;
    for (0..bench_count) |_| {
        var timer = try time.Timer.start();
        _ = try function();
        const ms = @as(f64, @floatFromInt(timer.read())) / @as(f64, @floatFromInt(time.ns_per_ms));
        min = @min(min, ms);
        max = @max(max, ms);
        accum += ms;
    }
    const mean: f64 = accum / @as(f64, @floatFromInt(bench_count));
    const value = try function();
    std.debug.print(
        "{s}:\n  result: {}\n    mean: {d:.2}ms\n     min: {d:.2}ms\n     max: {d:.2}ms\n",
        .{
            name,
            value,
            mean,
            min,
            max,
        },
    );
}

