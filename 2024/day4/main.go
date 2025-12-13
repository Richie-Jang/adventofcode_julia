package main

import (
	"bufio"
	"fmt"
	"os"

	"github.com/samber/lo"
)

var (
	istest   bool
	searcher = map[int]byte{0: 'X', 1: 'M', 2: 'A', 3: 'S'}
	dirs     = [][]int{
		{1, 0},
		{0, 1},
		{-1, 0},
		{0, -1},
		{1, 1},
		{1, -1},
		{-1, 1},
		{-1, -1},
	}
)

func loadData() []string {
	f := lo.If(istest, "test.txt").Else("input.txt")
	r, _ := os.Open(f)
	defer r.Close()

	br := bufio.NewScanner(r)
	res := []string{}
	for br.Scan() {
		res = append(res, br.Text())
	}
	return res
}

// pos : XMAS
func searchXMAS(data []string, cx, cy int, dx, dy int, pos int) bool {
	if pos == 4 {
		return true
	}

	if cx < 0 || cx >= len(data[0]) || cy < 0 || cy >= len(data) {
		return false
	}

	if c, ok := searcher[pos]; !ok || data[cy][cx] != c {
		return false
	}

	return searchXMAS(data, cx+dx, cy+dy, dx, dy, pos+1)
}

func solvePart1(data []string) int {
	sum := 0
	for y := range data {
		for x := range data[y] {
			for _, dir := range dirs {
				if searchXMAS(data, x, y, dir[0], dir[1], 0) {
					sum++
				}
			}
		}
	}
	return sum
}

func checkM(data []string, cx, cy int) bool {
	cx1, cy1 := cx+2, cy+2
	if cx1 < 0 || cx1 >= len(data[0]) || cy1 < 0 || cy1 >= len(data) {
		return false
	}
	if data[cy+1][cx+1] != 'A' {
		return false
	}
	if data[cy][cx1] == 'M' && data[cy1][cx] == 'S' && data[cy1][cx1] == 'S' {
		return true
	}
	if data[cy][cx1] == 'S' && data[cy1][cx] == 'M' && data[cy1][cx1] == 'S' {
		return true
	}
	return false
}

func checkS(data []string, cx, cy int) bool {
	cx1, cy1 := cx+2, cy+2
	if cx1 < 0 || cx1 >= len(data[0]) || cy1 < 0 || cy1 >= len(data) {
		return false
	}
	if data[cy+1][cx+1] != 'A' {
		return false
	}
	if data[cy][cx1] == 'M' && data[cy1][cx] == 'S' && data[cy1][cx1] == 'M' {
		return true
	}
	if data[cy][cx1] == 'S' && data[cy1][cx] == 'M' && data[cy1][cx1] == 'M' {
		return true
	}
	return false
}
func solvePart2(data []string) int {
	///  M.S | M.M | S.S | S.M
	///  .A. | .A. | .A. | .A.
	///  M.S | S.S | M.M | S.M

	sum := 0
	for y := range data {
		for x := range data[0] {
			if data[y][x] == 'M' && checkM(data, x, y) {
				sum++
				continue
			}
			if data[y][x] == 'S' && checkS(data, x, y) {
				sum++
				continue
			}
		}
	}
	return sum
}

func main() {
	istest = false
	data := loadData()

	fmt.Println("part1: ", solvePart1(data))
	fmt.Println("part2: ", solvePart2(data))
}
