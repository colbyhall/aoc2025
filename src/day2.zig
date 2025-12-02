const std = @import("std");
const mem = std.mem;

const input = @embedFile("day2_input.txt");

pub fn main() void {
    std.debug.print("{s}\n", .{input});

    var working: [:0]const u8 = input[0..];
    while (working.len > 0) {
        const dash = mem.indexOf(u8, working, "-") orelse unreachable;
        const a = working[0..dash];
        working = working[dash + 1 ..];
        const comma = mem.indexOf(u8, working, ",") orelse working.len - 1;
        const b = working[0..comma];
        working = working[comma + 1 ..];

        std.debug.print("{s}-{s}\n", .{ a, b });
    }
}
