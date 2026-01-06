module main

import os
import io
import arrays 

fn load_inputdata(istest bool) []string {
	mut res := []string{cap:10}
	filename := if istest { 'test.txt' } else { 'input.txt' }
	mut f := os.open(filename) or { panic(err) }
	defer { f.close() }
	mut reader := io.new_buffered_reader(reader: f)
	defer { reader.free() }
	for {
		res << reader.read_line() or { break } 
	}
	return res
}

fn part1_sub(s string, start_idx int, end_idx int) int {
	v := s[start_idx..end_idx].bytes()
	r := arrays.idx_max(v) or { return -1 } 
	return r + start_idx
}

fn solve_part1(data []string) i64 {
	mut res := i64(0)

	a := '0'
	a[0].ascii_str()
	for d in data {
		l := d.len
		a1 := part1_sub(d, 0, l-1)
		a2 := part1_sub(d, a1+1, l)
		v := (int(d[a1]) - int('0'[0])) * 10 + (int(d[a2]) - int('0'[0]))
		res += v
	}
	return res
}

fn solve_part2(data []string) i64 {
	mut res := i64(0)
	for d in data {
		l := d.len

		mut values := []int{cap: 12}
		mut stpos := 0
		mut endpos := 0

		for i := 11; i >= 0; i-- {
			endpos = l - i
			a1 := part1_sub(d, stpos, endpos)
			if a1 == -1 { panic("no good result") }
			values << int(d[a1]) - int('0'[0])
			stpos = a1 + 1
		}
		res += values.map(|v| v.str()).join('').i64()
	}

	return res
}

pub fn main() {
	istest := false 
	data := load_inputdata(istest)
	println("part1: ${solve_part1(data)}")
	println("part2: ${solve_part2(data)}")
}
