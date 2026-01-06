module main

import os
import io
import strconv

struct Range {
	st   i64
	ed   i64
	diff int
}

fn create_range(s1 string, s2 string) Range {
	a1 := strconv.parse_int(s1, 10, 64) or { panic(err) }
	a2 := strconv.parse_int(s2, 10, 64) or { panic(err) }
	d1 := int(a2 - a1)
	return Range{a1, a2, d1}
}

fn read_input(f string) []Range {
	mut ff := os.open(f) or { panic(err) }
	defer { ff.close() }
	mut reader := io.new_buffered_reader(reader: ff)
	defer { reader.free() }
	mut res := []Range{cap: 10}
	for {
		l := reader.read_line() or { break }
		l2 := l.split(',').filter(it != '')
		for l3 in l2 {
			p := l3.split('-')
			res << create_range(p[0], p[1])
		}
	}
	return res
}

fn check_double_chars(v i64) bool {
	va := v.str()
	l := va.len
	if l % 2 != 0 {
		return false
	}
	half := l / 2
	f1 := va[0..half]
	f2 := va[half..]
	return f1 == f2
}

// only even case
fn rec(vs string, count int) bool {
	if count == 0 {
		return false
	}

	r := vs.len % count
	if r != 0 {
		return rec(vs, count - 1)
	}

	need_count := vs.len / count
	mut items := []string{len: need_count}
	defer {
		items.clear()
	}
	for i := 0; i < need_count; i++ {
		items[i] = vs[i * count..(i + 1) * count]
	}
	if items.all(it == items[0]) {
		return true
	}
	return rec(vs, count - 1)
}

fn check_multiple(v i64) bool {
	vstr := v.str()
	if vstr.len <= 1 {
		return false
	}
	return rec(vstr, vstr.len / 2)
}

fn solve_part2(rgs []Range) i64 {
	mut sum := i64(0)
	for r in rgs {
		for i := r.st; i <= r.ed; i++ {
			if check_multiple(i) {
				// println(i)
				sum += i
			}
		}
	}
	return sum
}

pub fn main() {
	istest := false
	file_name := if istest { 'test.txt' } else { 'input.txt' }
	ranges := read_input(file_name)
	mut sum := i64(0)
	for r in ranges {
		for i := r.st; i <= r.ed; i++ {
			if check_double_chars(i) {
				sum += i
			}
		}
	}
	println('part1 - Sum: ${sum}')
	println('part2 - Sum: ${solve_part2(ranges)}')
}
