const std = @import("std");

const Backoff = @This();

max_elapsed_time: u64 = 15 * std.time.ns_per_min,
timer: std.time.Timer = undefined,
start_time: u64 = undefined,
stop_time_opt: ?u64 = null,

cur_interval: u64 = 500 * std.time.ns_per_ms,
max_interval: u64 = 60 * std.time.ns_per_s,

max_num_tries_opt: ?u64 = null,
num_tries: u64 = 0,

random_factor: f64 = 0.5,
multiplier: f64 = 1.5,

random: std.rand.Random,

pub fn init(self: *Backoff) !void {
    self.timer = try std.time.Timer.start();
    self.start_time = self.timer.lap();
}

pub fn next(self: *Backoff) ?u64 {
    if (self.max_num_tries_opt) |max_num_tries| {
        if (self.num_tries >= max_num_tries) {
            return null;
        }
        self.num_tries += 1;
    }

    const cur_interval_float: f64 = @floatFromInt(self.cur_interval);
    const elapsed_time = self.timer.read() - self.start_time;
    const next_time: u64 = blk: {
        if (self.random_factor == 0) {
            break :blk self.cur_interval;
        }
        const delta = self.random_factor * cur_interval_float;
        const min_interval = cur_interval_float - delta;
        const max_interval = cur_interval_float + delta;
        break :blk @intFromFloat(min_interval + self.random.float(f64) * (max_interval - min_interval + 1));
    };

    self.cur_interval = if (cur_interval_float < @as(f64, @floatFromInt(self.max_interval)) / self.multiplier)
        @intFromFloat(cur_interval_float * self.multiplier)
    else
        self.max_interval;

    return if (elapsed_time + next_time > self.max_elapsed_time) self.stop_time_opt else next_time;
}

test "basic" {
    var prng = std.rand.DefaultPrng.init(0);

    var backoff = Backoff{
        .max_interval = 5 * std.time.ns_per_s,
        .random = prng.random(),
        .random_factor = 0.1,
        .multiplier = 2.0,
    };

    try backoff.init();

    var expected_array = [_]u64{ 500, 1000, 2000, 4000 } ++ [1]u64{5000} ** 6;
    for (expected_array[0..]) |*expected| {
        expected.* *= std.time.ns_per_ms;
    }

    for (expected_array) |expected| {
        try std.testing.expectEqual(expected, backoff.cur_interval);
        const delta: u64 = @intFromFloat(backoff.random_factor * @as(f64, @floatFromInt(expected)));
        const actual = backoff.next().?;
        try std.testing.expect(actual >= expected - delta and actual <= expected + delta);
    }
}

test "custom_stop_time" {
    var prng = std.rand.DefaultPrng.init(0);

    var backoff = Backoff{
        .max_elapsed_time = std.time.ns_per_us,
        .stop_time_opt = std.time.ns_per_min,
        .random = prng.random(),
    };

    try backoff.init();

    try std.testing.expectEqual(backoff.stop_time_opt, backoff.next());
}

test "custom_max_tries" {
    var prng = std.rand.DefaultPrng.init(0);

    var backoff = Backoff{
        .random = prng.random(),
        .max_num_tries_opt = 17 + prng.random().uintLessThan(u64, 13),
    };

    try backoff.init();

    for (0..backoff.max_num_tries_opt.?) |_| {
        _ = backoff.next().?;
    }

    try std.testing.expectEqual(null, backoff.next());
}

test "interval_bound_overflow" {
    var prng = std.rand.DefaultPrng.init(0);

    var backoff = Backoff{
        .cur_interval = std.math.maxInt(i64) / 2,
        .max_interval = std.math.maxInt(i64),
        .random = prng.random(),
        .multiplier = 2.1,
    };

    try backoff.init();

    _ = backoff.next();

    try std.testing.expectEqual(backoff.max_interval, backoff.cur_interval);
}
