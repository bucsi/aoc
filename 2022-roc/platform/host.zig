const std = @import("std");
const builtin = @import("builtin");
const RocStr = @import("glue").str.RocStr;

const Part = enum(c_int) {
    part1,
    part2,
};

extern fn roc__solutionForHost_1_exposed_generic(*RocStr, Part) void;

pub fn main() u8 {
    const stdout = std.io.getStdOut().writer();
    var result = RocStr.empty();

    var timer = std.time.Timer.start() catch unreachable;
    roc__solutionForHost_1_exposed_generic(&result, Part.part1);
    var took = std.fmt.fmtDuration(timer.read());

    stdout.print("Part1 in {}:\n{s}\n\n", .{ took, result.asSlice() }) catch unreachable;

    timer.reset();
    roc__solutionForHost_1_exposed_generic(&result, Part.part2);
    took = std.fmt.fmtDuration(timer.read());

    stdout.print("Part2 in {}:\n{s}\n", .{ took, result.asSlice() }) catch unreachable;
    return 0;
}

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

export fn roc_alloc(size: usize, alignment: u32) callconv(.C) ?[*]u8 {
    _ = alignment;
    const bytes = allocator.alloc(u8, size) catch return null;
    return bytes.ptr;
}

export fn roc_realloc(ptr: [*]u8, new_size: usize, old_size: usize, alignment: u32) callconv(.C) ?[*]u8 {
    _ = alignment;
    const bytes = ptr[0..old_size];
    const new_bytes = allocator.realloc(bytes, new_size) catch return null;
    return new_bytes.ptr;
}

export fn roc_dealloc(ptr: [*]u8, alignment: u32) callconv(.C) void {
    // Do nothing. Will be freed when the app is closed.
    _ = ptr;
    _ = alignment;
}

export fn roc_memset(dst: [*]u8, value: u8, size: usize) callconv(.C) void {
    return @memset(dst[0..size], value);
}

extern fn shm_open(name: *const i8, oflag: c_int, mode: c_uint) c_int;
extern fn mmap(addr: ?*anyopaque, length: c_uint, prot: c_int, flags: c_int, fd: c_int, offset: c_uint) *anyopaque;
extern fn getppid() c_int;

fn roc_getppid() callconv(.C) c_int {
    return getppid();
}

fn roc_getppid_windows_stub() callconv(.C) c_int {
    return 0;
}

fn roc_shm_open(name: *const i8, oflag: c_int, mode: c_uint) callconv(.C) c_int {
    return shm_open(name, oflag, mode);
}
fn roc_mmap(addr: ?*anyopaque, length: c_uint, prot: c_int, flags: c_int, fd: c_int, offset: c_uint) callconv(.C) *anyopaque {
    return mmap(addr, length, prot, flags, fd, offset);
}

comptime {
    if (builtin.os.tag == .macos or builtin.os.tag == .linux) {
        @export(roc_getppid, .{ .name = "roc_getppid", .linkage = .Strong });
        @export(roc_mmap, .{ .name = "roc_mmap", .linkage = .Strong });
        @export(roc_shm_open, .{ .name = "roc_shm_open", .linkage = .Strong });
    }

    if (builtin.os.tag == .windows) {
        @export(roc_getppid_windows_stub, .{ .name = "roc_getppid", .linkage = .Strong });
    }
}

export fn roc_panic(c_ptr: *anyopaque, tag_id: u32) callconv(.C) void {
    _ = tag_id;

    const stderr = std.io.getStdErr().writer();
    const msg = @as([*:0]const u8, @ptrCast(c_ptr));
    stderr.print("Application crashed with message\n\n    {s}\n\nShutting down\n", .{msg}) catch unreachable;
    std.process.exit(1);
}
