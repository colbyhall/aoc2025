const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;

const input = @embedFile("day1_input.txt");

pub fn main() !void {
    var dial: i64 = 50;
    var result: i64 = 0;
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

        const amount = try fmt.parseInt(usize, line[1..], 10);
        const first = line[0];

        switch (first) {
            'L' => {
                for (0..amount) |_| {
                    dial -= 1;
                    const actual = @mod(dial, 100);
                    if (actual == 0) {
                        result += 1;
                    }
                }
            },
            'R' => {
                for (0..amount) |_| {
                    dial += 1;
                    const actual = @mod(dial, 100);
                    if (actual == 0) {
                        result += 1;
                    }
                }
            },
            else => unreachable,
        }

        if (working.len == 0) {
            break;
        }
    }

    std.debug.print("Result: {}\n", .{result});
}
