const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;

const input = @embedFile("day1_input.txt");

pub fn main() !void {
    var dial: i64 = 50;
    var part1: i64 = 0;
    var part2: i64 = 0;
    var working: [:0]const u8 = input[0..];
    while (true) {
        const line = blk: {
            if (mem.indexOf(u8, working, "\n")) |index| {
                const line = working[0..index];
                working = working[index + 1 ..];
                break :blk line;
            } else {
                const line = working;
                working.len = 0;
                break :blk line;
            }
        };

        var amount = try fmt.parseInt(i64, line[1..], 10);
        const first = line[0];
        switch (first) {
            'L' => amount = -amount,
            'R' => {},
            else => unreachable,
        }
        const old = dial;
        dial += amount;
        dial = @mod(dial, 100);
        if (dial == 0) {
            part1 += 1;
        }

        var turns: i64 = @intCast(@abs(@divTrunc(amount, 100)));
        if (old != 0) {
            const rem = @rem(amount, 100) + old;
            if (rem <= 0 or rem >= 100) {
                turns += 1;
            }
        }
        part2 += turns;

        if (working.len == 0) {
            break;
        }
    }

    std.debug.print("Part1 Result: {}\nPart2 Result: {}\n", .{ part1, part2 });
}
