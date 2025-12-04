const std = @import("std");
const mem = std.mem;

const bench = @import("bench.zig").bench;


pub fn main() !void {
    try bench("Part1", evalPart1);
    try bench("Part2", evalPart2);
}

const input = @embedFile("day4_input.txt");
const width = mem.indexOf(u8, input, "\n") orelse @compileError("Invalid input");
const height = input.len / (width + 1);

fn indexOf(x: i32, y: i32) ?usize {
    if (x < 0 or x >= width or y < 0 or y >= height) {
        return null;
    }

    return @intCast((@as(i32, @intCast(width)) + 1) * y + x);
}

fn isRollOfPaper(grid: []const u8, x: i32, y: i32) bool {
    const index = indexOf(x, y) orelse return false;
    return grid[index] == '@';
}

fn evalPart1() !u32 {
    var total: u32 = 0;

    var y: i32 = 0;
    while (y < height) {
        defer y += 1;

        var x: i32 = 0;
        while (x < width) {
            defer x += 1;

            if (isRollOfPaper(input, @intCast(x), @intCast(y))) {
                var count: u32 = 0;

                var dy: i32 = -1;
                while (dy <= 1) {
                    defer dy += 1;

                    var dx: i32 = -1;
                    while (dx <= 1) {
                        defer dx += 1;

                        if (dy == 0 and dx == 0) {
                            continue;
                        }

                        if (isRollOfPaper(input, x + dx, y + dy)) {
                            count += 1;
                        }
                    }
                }

                if (count < 4) {
                    total += 1;
                }
            }
        }
    }
    return total;
}

fn evalPart2() !u32 {
    var total: u32 = 0;

    var grid: [input.len]u8 = input.*;

    while (true) {
        const total_start = total;
        var y: i32 = 0;
        while (y < height) {
            defer y += 1;

            var x: i32 = 0;
            while (x < width) {
                defer x += 1;

                if (isRollOfPaper(&grid, @intCast(x), @intCast(y))) {
                    var count: u32 = 0;

                    var dy: i32 = -1;
                    while (dy <= 1) {
                        defer dy += 1;

                        var dx: i32 = -1;
                        while (dx <= 1) {
                            defer dx += 1;

                            if (dy == 0 and dx == 0) {
                                continue;
                            }

                            if (isRollOfPaper(&grid, x + dx, y + dy)) {
                                count += 1;
                            }
                        }
                    }

                    if (count < 4) {
                        total += 1;
                        const index = indexOf(x, y).?;
                        grid[index] = 'x';
                    }
                }
            }
        }
        if (total == total_start) {
            break;
        }
    }
    return total;
}
