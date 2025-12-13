package main

import (
	"bufio"
	"bytes"
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"

	"github.com/samber/lo"
)

var (
	istest = true
)

// for part1
func getValidInput(s string) []string {
	r := regexp.MustCompile(`mul\(\d+,\d+\)`)
	return r.FindAllString(s, -1)
}

type T2Int = lo.Tuple2[int, int]

func getValidInputPart2(s string) []string {
	r := regexp.MustCompile(`mul\(\d+,\d+\)`)
	rdo := regexp.MustCompile(`do\(\)`)
	rdont := regexp.MustCompile(`don't\(\)`)

	vals := lo.Map(r.FindAllStringIndex(s, -1),
		func(item []int, _ int) lo.Tuple3[int, int, string] {
			return lo.T3(item[0], item[1], s[item[0]:item[1]])
		})

	// change sets
	dos := lo.Map(rdo.FindAllStringIndex(s, -1),
		func(item []int, _ int) int {
			return item[0]
		})

	donts := lo.Map(rdont.FindAllStringIndex(s, -1),
		func(item []int, _ int) int {
			return item[0]
		})

	//set
	domap := make(map[int]any)
	dontmap := make(map[int]any)

	for _, i := range dos {
		domap[i] = nil
	}

	for _, i := range donts {
		dontmap[i] = nil
	}

	res := []string{}
	valpos := 0
	isok := true
	l := len(s)
	pos := 0
	for pos < l {
		if valpos >= len(vals) {
			break
		}
		_, ok := dontmap[pos]
		if ok {
			isok = false
		}
		_, ok = domap[pos]
		if ok {
			isok = true
		}

		startp, endp := vals[valpos].A, vals[valpos].B

		if pos >= startp && pos < endp {
			if isok {
				res = append(res, vals[valpos].C)
			}
			valpos++
		}

		pos++
	}
	return res
}

func loadData(ispart1 bool) []string {
	f := lo.If(istest, "test.txt").Else("input.txt")
	r, _ := os.Open(f)
	defer r.Close()
	res1 := []string{}
	if ispart1 {
		br := bufio.NewScanner(r)
		for br.Scan() {
			t := strings.TrimSpace(br.Text())
			if t == "" {
				continue
			}
			res1 = append(res1, getValidInput(t)...)
		}
	}

	if !ispart1 {
		br := bufio.NewScanner(r)
		buf := bytes.Buffer{}
		for br.Scan() {
			buf.WriteString(br.Text())
		}
		res1 = append(res1, getValidInputPart2(buf.String())...)
	}

	return res1
}

func toInt(s string) int {
	i, _ := strconv.Atoi(s)
	return i
}

// part1
func solvePart1() {
	data := loadData(true)
	r := regexp.MustCompile(`\((\d+),(\d+)\)`)
	sum := 0
	for _, v := range data {
		ms := r.FindStringSubmatch(v)
		sum += toInt(ms[1]) * toInt(ms[2])
	}
	fmt.Println("part1: ", sum)
}

func solvePart2() {
	data := loadData(false)
	r := regexp.MustCompile(`\((\d+),(\d+)\)`)
	sum := 0
	for _, v := range data {
		m := r.FindStringSubmatch(v)
		a1 := toInt(m[1])
		a2 := toInt(m[2])
		sum += a1 * a2
	}
	fmt.Println("part2: ", sum)
}

// part2
func main() {
	istest = false
	solvePart1()
	solvePart2()
}
