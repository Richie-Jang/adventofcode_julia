module day4

testinput = "./src/test.txt"
input = "./src/day4.txt"

const GRID = Vector{Vector{Char}}

export part1, part2

function make_grid(testcase::Bool)
    f = testcase ? testinput : input
    grid = GRID()
    for l in eachline(f)
        push!(grid, [v for v in l])
    end
    grid
end

dirs = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]

function get_adjencies(grid::GRID, y::Int, x::Int)::Int
    counter = 0
    for d in dirs
        ny = y + d[1]
        nx = x + d[2]
        if nx <= 0 || nx > length(grid[1]) || ny <= 0 || ny > length(grid)
            continue
        end
        if grid[ny][nx] == '@'
            counter += 1
        end
    end
    return counter
end

function phase_run(grid::GRID)::Tuple{Int,Vector{Tuple{Int,Int}}}
    res = 0
    modifiers = Tuple{Int,Int}[]
    for y in eachindex(grid)
        for x in eachindex(grid[y])
            c = grid[y][x]
            if c == '.'
                continue
            end
            # check count
            if get_adjencies(grid, y, x) <= 3
                res += 1
                push!(modifiers, (y, x))
            end
        end
    end
    res, modifiers
end

function part1(testcase::Bool)
    grid = make_grid(testcase)
    #grid2 = deepcopy(grid)
    res, _ = phase_run(grid)
    println(res)
end

function update_grid(grid::GRID, mods::Vector{Tuple{Int,Int}})
    for m in mods
        grid[m[1]][m[2]] = '.'
    end
end


function part2(testcase::Bool)
    grid = make_grid(testcase)
    counter = 0
    rolls_count = 0
    while true
        v, mods = phase_run(grid)
        if v > 0
            counter += 1
            # update grid
            update_grid(grid, mods)
            println("phase[$counter] : $v")
            rolls_count += v
        else
            break
        end
    end
    println(rolls_count)
end

end # module day4
