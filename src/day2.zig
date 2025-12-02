const std = @import("std");

const input = @embedFile("day2_input.txt");

pub fn main() void {
    std.debug.print("{s}\n", .{input});
}
