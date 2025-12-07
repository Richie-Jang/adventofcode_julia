package main

import (
	"bufio"
	"fmt"
	"math"
	"os"
	"strconv"
	"strings"

	"github.com/samber/lo"
)

func check_line(vs []int) bool {
	checkers := []int{}
	for i := range vs {
		diff := vs[i+1] - vs[i]
		checkers = append(checkers, diff)
		if i == len(vs)-2 {
			break
		}
	}

	// checkes contains only 1, 2, 3 and plus or minus
	signcheck := lo.If(checkers[0] >= 0, 1).Else(-1)
	return lo.EveryBy(checkers, func(i int) bool {
		vv := int(math.Abs(float64(i)))
		if vv <= 3 {
			return signcheck > 0 && i > 0 || signcheck < 0 && i < 0
		}
		return false
	})
}

// part1 solution
func main() {
	testcase := false
	if len(os.Args) > 1 {
		testcase = true
	}

	f := lo.If(testcase, "test.txt").Else("day2.txt")
	r, err := os.Open(f)
	if err != nil {
		panic(err)
	}
	defer r.Close()
	br := bufio.NewScanner(r)

	res := 0

	for br.Scan() {
		t := strings.TrimSpace(br.Text())
		vs := lo.Map(strings.Split(t, " "), func(s string, i int) int {
			v, _ := strconv.Atoi(s)
			return v
		})

		if check_line(vs) {
			fmt.Println(vs, " true")
			res++
		}
	}

	fmt.Println(res)
}
