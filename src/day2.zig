const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;
const heap = std.heap;
const FixedBufferAllocator = heap.FixedBufferAllocator;
const Allocator = mem.Allocator;

const input = @embedFile("day2_input.txt");

pub fn main() !void {
    var buffer: [512]u8 = undefined;
    var fba = FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();

    var part1: usize = 0;
    var part2: usize = 0;
    var working: [:0]const u8 = input[0..];
    while (working.len > 0) {
        const dash = mem.indexOf(u8, working, "-") orelse unreachable;
        const a = working[0..dash];
        working = working[dash + 1 ..];
        const comma = mem.indexOf(u8, working, ",") orelse working.len - 1;
        const b = working[0..comma];
        working = working[comma + 1 ..];

        const min = try fmt.parseInt(usize, a, 10);
        const max = try fmt.parseInt(usize, b, 10);
        for (min..max + 1) |value| {
            defer fba.reset();

            const number = try fmt.allocPrint(allocator, "{}", .{value});
            if (try evalPart1(number)) {
                part1 += value;
            }
            if (try evalPart2(number)) {
                part2 += value;
            }
        }
    }

    std.debug.print("Part 1: {}\nPart 2: {}\n", .{ part1, part2 });
}

fn evalPart1(number: []const u8) !bool {
    const max_size = @divTrunc(number.len, 2);
    const a = number[0..max_size];
    const b = number[max_size..];

    return mem.eql(u8, a, b);
}

fn evalPart2(number: []const u8) !bool {
    const max_size = @divTrunc(number.len, 2);
    outer: for (1..max_size + 1) |size| {
        if (@mod(number.len, size) != 0) {
            continue :outer;
        }

        const max_checks = @divTrunc(number.len, size) - 1;
        for (0..max_checks) |index| {
            const current = index * size;
            const a = number[current .. current + size];
            const next = current + size;
            const b = number[next .. next + size];

            if (!mem.eql(u8, a, b)) {
                continue :outer;
            }
        }

        return true;
    }
    return false;
}
