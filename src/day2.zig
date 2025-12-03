const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;
const heap = std.heap;
const FixedBufferAllocator = heap.FixedBufferAllocator;
const Allocator = mem.Allocator;

const input = @embedFile("day2_input.txt");

pub fn main() !void {
    std.debug.print("{s}\n", .{input});

    var buffer: [512]u8 = undefined;
    var fba = FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();

    var part1: usize = 0;
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
            const max_size = @divTrunc(number.len, 2);
            const first = number[0..max_size];
            const second = number[max_size..];

            if (mem.eql(u8, first, second)) {
                part1 += value;
            }
        }
    }

    std.debug.print("Part 1: {}\n", .{part1});
}
