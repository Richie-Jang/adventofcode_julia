package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

type Turn struct {
	d     int
	count int
}

func mod(a, b int) int {
	if a == 0 {
		return 0
	}
	c := a % b
	if c < 0 {
		return c + b
	}
	return c
}

func getLoadData() []Turn {
	f := "data.txt"
	//f := "test.txt"
	r, er := os.Open(f)
	if er != nil {
		panic(er)
	}
	defer r.Close()
	br := bufio.NewScanner(r)
	res := []Turn{}
	for br.Scan() {
		t := br.Text()
		if t == "" {
			continue
		}
		d := 1
		if t[0] == 'L' {
			d = -1
		}
		count, _ := strconv.Atoi(t[1:])
		res = append(res, Turn{d, count})
	}
	return res
}

func solvePart2(turns []Turn) int {
	pointer := 50
	res := 0
	for _, t := range turns {
		clicksToZero := 0
		if t.d == -1 {
			if pointer == 0 {
				pointer = 100
			}
			clicksToZero = pointer
		} else {
			clicksToZero = 100 - pointer
		}
		howmanyturns := (t.count - clicksToZero) / 100
		passZeroOnce := t.count >= clicksToZero
		if passZeroOnce {
			res++
		}
		res += howmanyturns
		pointer = mod(pointer+(t.d*t.count), 100)
	}
	return res
}

// for part2
func main() {
	turns := getLoadData()
	fmt.Println(solvePart2(turns))
}
