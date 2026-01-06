const std = @import("std");
const Io = std.Io;
const assert = std.debug.assert;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const splitScalar = std.mem.splitScalar;

const Dir = enum {
    Left,
    Right,
};

const Cmd = struct {
    dir: Dir,
    steps: i32,
};

fn input_file_reading(f: []const u8, io: Io, gpa: Allocator) ![]Cmd {
    var file = try Io.Dir.cwd().openFile(io, f, .{});
    defer file.close(io);
    var buf: [1024]u8 = undefined;
    var reader = file.reader(io, &buf);
    var r = &reader.interface;
    var res = ArrayList(Cmd).empty;
    while (try r.takeDelimiter('\n')) |line| {
        const d = if (line[0] == 'L') Dir.Left else Dir.Right;
        const dd = std.mem.trimEnd(u8, line[1..], "\r ");
        const steps = try std.fmt.parseInt(i32, dd, 10);
        try res.append(gpa, .{ .dir = d, .steps = steps });
    }
    return res.toOwnedSlice(gpa);
}

fn solve_part1(cmds: []const Cmd) i32 {
    var res: i32 = 0;
    var start: i32 = 50;
    for (cmds) |cmd| {
        const v = switch (cmd.dir) {
            .Left => -1 * cmd.steps,
            .Right => cmd.steps,
        };
        start = @mod(start + v, 100);
        if (start == 0) {
            res += 1;
        }
    }
    return res;
}

fn solve_part2(cmds: []const Cmd) i64 {
    var res: i64 = 0;
    var start: i64 = 50;
    for (cmds) |cmd| {
        const v = switch (cmd.dir) {
            .Left => -1 * cmd.steps,
            .Right => cmd.steps,
        };
        const value_need_zero: i64 = switch (cmd.dir) {
            .Left => if (start == 0) 100 else start,
            else => 100 - start,
        };

        const zeroturned = cmd.steps >= value_need_zero;
        if (zeroturned) {
            res += 1;
            res += @divFloor(cmd.steps - value_need_zero, 100);
        }
        start = @mod(start + v, 100);
    }
    return res;
}

pub fn main() !void {
    var debug_allocator = std.heap.DebugAllocator(.{}).init;
    defer assert(debug_allocator.deinit() == .ok);
    var allocator: std.heap.ArenaAllocator = .init(debug_allocator.allocator());
    defer allocator.deinit();
    const gpa = allocator.allocator();
    var th: std.Io.Threaded = .init(gpa, .{});
    defer th.deinit();
    const io = th.io();
    const cmds = try input_file_reading("input.txt", io, gpa);
    defer gpa.free(cmds);
    std.debug.print("{}\n", .{solve_part1(cmds)});
    std.debug.print("{}\n", .{solve_part2(cmds)});
}
