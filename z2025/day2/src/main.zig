const std = @import("std");
const Io = std.Io;
const Alloc = std.mem.Allocator;
var gpa: Alloc = undefined;

pub fn main() !void {
    // In order to allocate memory we must construct an `Allocator` instance.
    var debug_allocator: std.heap.DebugAllocator(.{}) = .init;
    defer {
        std.debug.assert(debug_allocator.deinit() == .ok);
    } // This checks for leaks.

    const dalloc = debug_allocator.allocator();
    var arena = std.heap.ArenaAllocator.init(dalloc);
    defer arena.deinit();
    gpa = arena.allocator();

    // In order to do I/O operations we must construct an `Io` instance.
    var threaded: std.Io.Threaded = .init(gpa, .{});
    defer threaded.deinit();
    const io = threaded.io();

    // file loading

    var file = try std.Io.Dir.cwd().openFile(io, "input.txt", .{});
    defer file.close(io);
    var file_buffer: [4096]u8 = undefined;
    var f = file.reader(io, &file_buffer);
    const ri: *std.Io.Reader = &f.interface;

    var contents = std.ArrayList(Range).empty;
    defer contents.deinit(gpa);
    while (try ri.takeDelimiter(',')) |l| {
        const ll = std.mem.trimEnd(u8, l, " \r\n");
        if (std.mem.eql(u8, ll, "")) continue;
        var iter = std.mem.splitScalar(u8, ll, '-');
        const a1 = iter.next().?;
        const a2 = iter.next().?;
        const b1 = try std.fmt.parseInt(i64, a1, 10);
        const b2 = try std.fmt.parseInt(i64, a2, 10);
        try contents.append(gpa, .{ .st = b1, .ed = b2 });
    }

    try solve_part1(contents.items);
    try solve_part2(contents.items);
}

const Range = struct {
    st: i64,
    ed: i64,
};

fn check_value_part1(v: usize) !bool {
    var buf: [32]u8 = undefined;
    var vstr = try std.fmt.bufPrint(&buf, "{}", .{v});
    const l = vstr.len;
    if (@rem(l, 2) != 0) {
        return false;
    }
    const half = @divTrunc(l, 2);
    const a1 = vstr[0..half];
    const a2 = vstr[half..];
    const res = std.mem.eql(u8, a1, a2);
    return res;
}

fn check_rec(vs: []u8, l: usize, count: usize) !bool {
    if (count == 0) {
        return false;
    }
    if (l % count != 0) {
        return check_rec(vs, l, count - 1);
    }
    const ll = l / count;

    if (ll == 1) {
        for (0..l - 1) |i| {
            if (vs[i] != vs[i + 1]) {
                return false;
            }
        }
        return true;
    }

    var strs = std.ArrayList([]u8).empty;
    defer strs.deinit(gpa);
    for (0..ll) |c| {
        try strs.append(gpa, vs[c * count .. (c + 1) * count]);
    }
    for (0..ll - 1) |c| {
        if (!std.mem.eql(u8, strs.items[c], strs.items[c + 1])) {
            return check_rec(vs, l, count - 1);
        }
    }
    return true;
}

fn check_value_part2(v: usize) !bool {
    var buf: [32]u8 = undefined;
    var vstr = try std.fmt.bufPrint(&buf, "{}", .{v});
    const l = vstr.len;
    if (l <= 1) {
        return false;
    }
    return try check_rec(vstr, l, l / 2);
}

fn solve_part2(cots: []Range) !void {
    var res: i64 = 0;
    for (cots) |c| {
        for (@intCast(c.st)..@intCast(c.ed + 1)) |cc| {
            if (try check_value_part2(cc)) {
                res += @intCast(cc);
            }
        }
    }
    std.debug.print("part2 : {d}\n", .{res});
}

fn solve_part1(cots: []Range) !void {
    var res: i64 = 0;
    for (cots) |c| {
        for (@intCast(c.st)..@intCast(c.ed + 1)) |cc| {
            if (try check_value_part1(cc)) {
                res += @intCast(cc);
            }
        }
    }
    std.debug.print("part1 : {d}\n", .{res});
}
