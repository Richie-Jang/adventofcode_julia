module main

import os

fn part1_solve(data []string) int {
	mut result := 0
	adj := [[-1, 0], [1, 0], [0, -1], [0, 1], [1, 1], [1, -1],
		[-1, 1], [-1, -1]]
	for y in 0 .. data.len {
		for x in 0 .. data[y].len {
			cur := data[y][x]
			if cur.ascii_str() == '.' {
				continue
			}
			mut count := 0
			for xy in adj.map([x + it[0], y + it[1]]) {
				if xy[0] < 0 || xy[0] >= data[y].len || xy[1] < 0 || xy[1] >= data.len {
					continue
				}
				if data[xy[1]][xy[0]].ascii_str() == '@' {
					count += 1
				}
			}
			if count < 4 {
				result += 1
			}
		}
	}
	return result
}

type I2 = [2]int
type Arr2D = [][]u8

fn part2_solve(data []string) int {
	mut result := 0
	mut changes := []I2{cap: 10}

	xlen := data[0].len
	ylen := data.len
	mut grid := Arr2D{len: ylen}

	for y in 0 .. ylen {
		grid[y] = []u8{len: xlen}
		for x in 0 .. xlen {
			grid[y][x] = data[y][x]
		}
	}

	adj := [[-1, 0], [1, 0], [0, -1], [0, 1], [1, 1], [1, -1],
		[-1, 1], [-1, -1]]

	for {
		for y in 0 .. data.len {
			for x in 0 .. data[y].len {
				cur := grid[y][x]
				if cur.ascii_str() == '.' {
					continue
				}
				mut count := 0
				for xy in adj.map([x + it[0], y + it[1]]) {
					if xy[0] < 0 || xy[0] >= xlen || xy[1] < 0 || xy[1] >= ylen {
						continue
					}
					if grid[xy[1]][xy[0]].ascii_str() == '@' {
						count += 1
					}
				}
				if count < 4 {
					changes << [x, y]!
				}
			}
		}

		if changes.len == 0 {
			break
		} else {
			// update
			result += changes.len
			for change in changes {
				grid[change[1]][change[0]] = u8('.'[0])
			}
			changes = []
		}
	}

	return result
}

fn main() {
	istest := false
	infile := if istest { 'test.txt' } else { 'input.txt' }
	lines := os.read_lines(infile) or { panic(err) }

	println('part1 solve : ${part1_solve(lines)}')
	println('part2 solve : ${part2_solve(lines)}')
}
