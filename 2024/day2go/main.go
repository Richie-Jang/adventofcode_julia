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

func check_line_part2_ex(vs []int) bool {

	isvalid := func(arr []int) bool {
		diff := 0
		prevdiff := 0
		for i := range arr {
			pv := arr[i]
			nv := arr[i+1]
			diff = nv - pv
			if diff == 0 {
				return false
			}

			if diff > 3 || diff < -3 {
				return false
			}
			if i == 0 {
				prevdiff = diff
				continue
			}
			if prevdiff*diff < 0 {
				return false
			}
			prevdiff = diff
			if i == len(arr)-2 {
				break
			}
		}
		return true
	}

	// spread condition vs
	allvs := [][]int{}
	allvs = append(allvs, vs)
	for i := range vs {
		nvs := []int{}
		for j := 0; j < len(vs); j++ {
			if i == j {
				continue
			}
			nvs = append(nvs, vs[j])
		}
		allvs = append(allvs, nvs)
	}
	for _, arr := range allvs {
		if isvalid(arr) {
			return true
		}
	}
	return false
}

// real hard coding...
func check_line_part2(vs []int) bool {
	checkers := []int{}
	for i := range vs {
		diff := vs[i+1] - vs[i]
		checkers = append(checkers, diff)
		if i == len(vs)-2 {
			break
		}
	}

	fmt.Println("start check:", vs, "->", checkers)

	isvalid := func(arr []int) bool {
		fmt.Println("final check arr: ", arr)
		diff := 0
		prevdiff := 0
		for i := range arr {
			pv := arr[i]
			nv := arr[i+1]
			diff = nv - pv
			if diff == 0 {
				return false
			}
			if diff > 3 || diff < -3 {
				return false
			}
			if i == 0 {
				prevdiff = diff
				continue
			}
			if prevdiff*diff < 0 {
				return false
			}
			prevdiff = diff
			if i == len(arr)-2 {
				break
			}
		}
		return true
	}

	// remove same numbers
	newvs := make([]int, len(vs))
	copy(newvs, vs)

	posval, negval := 0, 0
	for _, v := range checkers {
		if v > 0 {
			posval++
		} else if v < 0 {
			negval++
		}
	}

	fmt.Println("posval:", posval, "negval:", negval, "len:", len(checkers))

	if posval+negval < len(checkers) {
		zeroCount := len(checkers) - (posval + negval)
		fmt.Println("zero found. ", zeroCount)
		if zeroCount > 1 {
			return false
		} else if zeroCount == 1 {
			_, pos, _ := lo.FindIndexOf(checkers, func(item int) bool {
				return item == 0
			})
			newvs = append(vs[:pos], vs[pos+1:]...)
			return isvalid(newvs)
		}
	} else {
		if posval > negval && negval == 1 {
			fmt.Println("remove neg 1 value")
			_, pos, _ := lo.FindIndexOf(checkers, func(item int) bool {
				return item < 0
			})
			newvs = append(vs[:pos+1], vs[pos+2:]...)
			return isvalid(newvs)
		} else if negval > posval && posval == 1 {
			fmt.Println("remove pos 1 value")
			_, pos, _ := lo.FindIndexOf(checkers, func(item int) bool {
				return item > 0
			})
			newvs = append(vs[:pos+1], vs[pos+2:]...)
			return isvalid(newvs)
		}

		// up down check
		check4over := lo.CountBy(checkers, func(v int) bool {
			return v >= 4 || v <= -4
		})
		if check4over > 1 {
			fmt.Println("found over abs(4) value 2 more")
			return false
		} else if check4over == 1 {
			_, pos, _ := lo.FindIndexOf(checkers, func(item int) bool {
				return item >= 4 || item <= -4
			})
			fmt.Println("remove abs over 4 value at pos:", pos+1)
			newvs = append(vs[:pos+1], vs[pos+2:]...)
			return isvalid(newvs)
		}

	}

	return isvalid(newvs)

}

// part1 solution
// part2 solution
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

	part1 := 0
	part2 := 0

	/*
		XNOR := func(a, b bool) bool {
			return (a && b) || (!a && !b)
		}*/

	for br.Scan() {
		t := strings.TrimSpace(br.Text())
		vs := lo.Map(strings.Split(t, " "), func(s string, i int) int {
			v, _ := strconv.Atoi(s)
			return v
		})

		part1res := check_line(vs)
		part2res := check_line_part2_ex(vs)
		if part1res {
			part1++
		}

		if part2res {
			part2++
		}
	}

	fmt.Println("part1: ", part1)
	fmt.Println("part2: ", part2)
}
