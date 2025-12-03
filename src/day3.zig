const std = @import("std");
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

pub fn main() !void {
    try bench("Part1", evalPart1);
}
