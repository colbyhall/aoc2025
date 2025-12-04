const std = @import("std");
const math = std.math;
const bench = @import("bench.zig").bench;

const input = @embedFile("day3_input.txt");

fn evalPart1() !u32 {
    var largest: u8 = 0;
    var secondary: ?u8 = null;
    var total: u32 = 0;
    for (0..input.len) |index| {
        const c = input[index];
        if (c == '\n') {
            var joltage: u32 = 0;
            joltage += largest * 10;
            joltage += secondary.?;
            total += joltage;

            largest = 0;
            continue;
        }
        const next = input[index + 1];
        const last = next == '\n';

        const digit = c - '0';
        if (largest < digit) {
            if (last) {
                secondary = digit;
            } else {
                largest = digit;
                secondary = null;
            }
        } else if (secondary == null or (secondary != null and secondary.? < digit)) {
            secondary = digit;
        }
    }
    return total;
}

fn evalPart2() !u64 {
    var total: u64 = 0;
    var start: usize = 0;
    for (0..input.len) |outer| {
        if (input[outer] != '\n') {
            continue;
        }

        const current = input[start..outer];
        const number_size = 12;
        var number: [number_size]u8 = undefined;

        var last_largest_pos: usize = 0;
        for (0..number_size) |digit| {
            const end_delta = number_size - digit - 1;

            var largest: u8 = 0;
            inner: for (last_largest_pos..current.len - end_delta) |index| {
                const c = current[index];
                const value = c - '0';

                if (value > largest) {
                    largest = value;
                    last_largest_pos = index + 1;

                    if (value == 9) {
                        break :inner;
                    }
                }
            }
            number[digit] = largest;
        }

        var joltage: u64 = 0;
        for (0..number_size) |index| {
            const exp = number_size - index - 1;
            joltage += number[index] * try math.powi(u64, 10, @intCast(exp));
        }
        total += joltage;
        start = outer + 1;
    }
    return total;
}

pub fn main() !void {
    try bench("Part1", evalPart1);
    try bench("Part2", evalPart2);
}
