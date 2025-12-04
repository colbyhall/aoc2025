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

        const bank = input[start..outer];
        const batteries = 12;

        var last_battery: usize = 0;
        for (0..batteries) |digit| {
            const end_delta = batteries - digit - 1;

            var largest: u8 = 0;
            for (last_battery..bank.len - end_delta) |index| {
                const battery = bank[index] - '0';
                if (battery > largest) {
                    largest = battery;
                    last_battery = index + 1;

                    if (battery == 9) {
                        break;
                    }
                }
            }
            total += largest * try math.powi(u64, 10, @intCast(end_delta));
        }

        start = outer + 1;
    }
    return total;
}

pub fn main() !void {
    try bench("Part1", evalPart1);
    try bench("Part2", evalPart2);
}
