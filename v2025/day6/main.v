module main

import os
import arrays
import strconv

fn solve_part1(lines []string) i64 {
	mut data := [][]int{}	
	for l in lines[0..(lines.len)-1] { 
		inp := l.split(" ").filter(it != "").map(it.int())
		data << inp
	}
	signs := lines.last().split(" ").filter(it != "")
	mut result := i64(0)
	count := data[0].len
	for i in 0..count {
		sign := signs[i]
		mut myarr := []i64{}
		for j in 0..data.len {
			myarr << data[j][i]					
		}
		sum := 
		match sign {
			'+' {
				arrays.fold(myarr, 0, |acc, k| acc+k)
			}
			'*' {
				arrays.fold(myarr, i64(1), |acc, k| acc*k)
			}
			else {
				panic("error: can not be another sign $sign")
			}
		}
		result += sum
	}
	return result 
}

fn make_pos_list(s string, pos int, mut acc [][2]int) [][2]int {
	if pos >= s.len {
		acc.last()[1] = pos
		return acc
	}
	p := s[pos].ascii_str()
	if p == ' ' {
		return make_pos_list(s, pos+1, mut acc)
	}
	if pos > 0 {
		acc.last()[1] = pos-1
	}
	acc << [pos, 0]!
	return make_pos_list(s, pos+1, mut acc)
}

fn solve_part2(lines []string) i64 {
	signs := lines.last()	
	mut poslist := [][2]int{}
	// range exclusive
	poslist = make_pos_list(signs, 0, mut poslist)
	mut signmap := map[int]u8{}
	for p in poslist {
		signmap[p[0]] = signs[p[0]]
	}

	mut table := [][]string{}
	for l in lines[..lines.len-1]{
		mut arr := []string{}
		for p in poslist {
			st := p[0]
			ed := p[1]
			arr << l[st..ed]
		}	
		table << arr
	}

	mut result := i64(0)

	for i := table[0].len-1; i >= 0; i-- {
		mut arr := []string{}
		for j := 0; j < table.len; j++ {
			arr << table[j][i]
		}
		lastlen := arr.last().len
		signpos_start := poslist[i][0]
		sign := signmap[signpos_start]
		mut sum := if sign == '+'[0] { i64(0) } else {i64(1) }
		for k := lastlen-1; k >= 0; k-- {
			mut vals := []u8{}
			for h := 0; h < arr.len; h++ {
				if arr[h][k] != ' '[0]{
					vals << arr[h][k]
				}
			}
			v := vals.filter(it != ' '[0]).bytestr()
			vi := strconv.parse_int(v, 10, 64) or { panic(err) }
			if sign == '+'[0] {
				sum += vi
			} else {
				sum *= vi
			}
		}

		result += sum
	}	

	return result
}

pub fn main() {
	istest := false
	filename := if istest { "test.txt" } else { "input.txt" }
	lines := os.read_lines(filename) or { panic(err ) }
	println("part1: ${solve_part1(lines)}")	
	println("part2: ${solve_part2(lines)}")
}
