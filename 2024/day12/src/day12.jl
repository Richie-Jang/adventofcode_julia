module day12

using Printf
using DataStructures

#part1
sample1 = """RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE"""

#convert 2d array
function convert_2darray(inp::String)
    return [collect(line) for line in split(inp, "\n")]
end

function bfs(start::Tuple{Int,Int}, grid::Vector{Vector{Char}}, visits::Set{Tuple{Int,Int}}, c::Char)
    queue = Deque{Tuple{Int,Int}}()
    dirs::Vector{Tuple{Int,Int}} = [(0, 1), (0, -1), (1, 0), (-1, 0)]
    cvisits = Set{Tuple{Int,Int}}()
    push!(queue, start)
    while !isempty(queue)
        y, x = popfirst!(queue)
        if (y, x) in cvisits
            continue
        end
        if grid[y][x] != c
            continue
        end
        push!(cvisits, (y, x))
        for d in dirs
            ny = y + d[1]
            nx = x + d[2]
            if ny < 1 || ny > length(grid) || nx < 1 || nx > length(grid[1])
                continue
            end
            push!(queue, (ny, nx))
        end
    end

    #compute perimeter
    perimeter = 0
    for (y, x) in cvisits
        for d in dirs
            ny = y + d[1]
            nx = x + d[2]
            if ny < 1 || ny > length(grid) || nx < 1 || nx > length(grid[1])
                perimeter += 1
                continue
            end
            if (ny, nx) ∉ cvisits
                perimeter += 1
            end
        end
    end

    area = length(cvisits)
    # update visits
    for (y, x) in cvisits
        push!(visits, (y, x))
    end

    println(@sprintf("cur: %c Area: %d Perimeter: %d", c, area, perimeter))
    return area * perimeter
end

function start_check(grid::Vector{Vector{Char}})
    sum = 0
    visits = Set{Tuple{Int,Int}}()
    for y in eachindex(grid)
        for x in eachindex(grid[y])
            if (y, x) ∉ visits
                # bfs
                println(visits)
                sum += bfs((y, x), grid, visits, grid[y][x])
            end
        end
    end

    println(sum)
end

end # module day12
