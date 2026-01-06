module main

import os
import strconv

enum Dir {
	left
	right
}

struct Move {
	dir Dir
	count int
}

fn read_input(f string) []Move {
	mut moves := []Move{cap:30}
	for _, l in os.read_lines(f) or { panic("wrong file input $f")}{
		d := l[0].ascii_str()
		dist := strconv.atoi(l[1..]) or { panic(err) }
		if d == 'L' {
			moves << Move{dir: .left, count: dist }
		} else if d == 'R' {
			moves << Move{dir: .right, count: dist}
		}
	}
	return moves
}

fn modulo(a int, b int) int {
	return (a % b + b) % b
}

fn solve_part1(moves []Move) int {
	mut cur := 50
	mut res := 0
	for _, move in moves {
		match move.dir {
			.left {
				cur = modulo(cur - move.count, 100)
			} else {
				cur = modulo(cur + move.count, 100)
			}
		}
		if cur == 0 {
			res += 1
		}
	}
	return res
}

fn solve_part2(moves []Move) int{
	mut cur := 50
	mut res := 0
	for _, move in moves {
		clicks_to_reachzero := if move.dir == .left {
			if cur == 0 { 100 } else { cur }
		} else {
			100 - cur
		}
		round_trips := (move.count - clicks_to_reachzero) / 100

		pass_zero_atleast_once := move.count >= clicks_to_reachzero
		res += if pass_zero_atleast_once { round_trips + 1 } else { 0 }

		ncur := cur + if move.dir == .left { -1 } else { 1 } * move.count
		cur = modulo(ncur, 100)
	}
	return res
}

pub fn main() {
	mut istest := false
	inputfile := if istest { "test.txt" } else {"input.txt"}

	moves := read_input(inputfile)
	println("solve_part1: ${solve_part1(moves)}")
	println("solve_part2: ${solve_part2(moves)}")
}
