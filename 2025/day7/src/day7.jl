module day7

function triangle(n::Int)
    p = Vector{Vector{Int}}()
    for r in 1:n
        tmp = fill(1, r)
        for c in 2:r-1
            tmp[c] = p[r-1][c-1] + p[r-1][c]
        end
        push!(p, tmp)
        println("row $r: ", p)
    end
    p
end

function loaddata(istest::Bool)::Vector{Vector{Char}}
    f = istest ? "./src/test.txt" : "./src/input.txt"
    grid = Vector{Vector{Char}}()
    for l in eachline(f)
        push!(grid, collect(l))
    end
    grid
end

function searchstartpos(grid::Vector{Vector{Char}})::Tuple{Int,Int}
    x = findfirst(==('S'), grid[1])
    (1, x)
end

function part1(istest::Bool=true)
    grid = loaddata(istest)
    ylen = length(grid)
    sy, sx = searchstartpos(grid)
    res1 = Set{Tuple{Int,Int}}() 
    function recbeam(x::Int, y::Int)
        if y > ylen 
            return
        end
        g = grid[y][x]
        if (x,y) in res1
            return
        end
        if g == '.' 
            recbeam(x, y+1)
        end
        if g == '^'
            push!(res1, (x,y))
            recbeam(x-1,y)
            recbeam(x+1,y)            
        end
    end 

    recbeam(sx, sy+1)
    length(res1)
end

function part1BFS(istest::Bool=true)
    grid = loaddata(istest)
    ylen = length(grid)
    sy, sx = searchstartpos(grid)
    queue = Vector{Tuple{Int,Int}}()
    seen = Set{Tuple{Int,Int}}()    
    push!(queue, (sx, sy+1))
    part1res = 0
    while length(queue) > 0
        g = popfirst!(queue)
        if g[2] > ylen
            continue
        end
        if g in seen 
            continue
        end
        push!(seen, g)
        x, y = g
        if grid[y][x] == '.'
            push!(queue, (x, y+1))
            continue
        end
        if grid[y][x] == '^'
            part1res += 1
            push!(queue, (x-1,y))
            push!(queue, (x+1, y))
        end
    end
    part1res
end

using Memoize

function part2rec(istest::Bool=true)
    grid = loaddata(istest)
    ylen = length(grid)
    sy, sx = searchstartpos(grid)

    memdict = Dict{Tuple{Int,Int},Int}()
    function recbeam(x::Int, y::Int)
        if y > ylen 
            return 1
        end
        if haskey(memdict, (x,y))
            return memdict[(x,y)]
        end
        g = grid[y][x]
        if g == '.' 
            memdict[(x,y)] = recbeam(x, y+1)
            return memdict[(x,y)]
        end
        if g == '^'
            memdict[(x,y)] = recbeam(x-1,y) + recbeam(x+1,y)
            return memdict[(x,y)]
        end
    end 
    res2 = recbeam(sx, sy+1)
    println(memdict)
    res2, memdict
end

function part2(istest::Bool=true)
    grid = loaddata(istest)
    timelines = [zeros(Int,length(grid[1])) for i in 1:length(grid)]
    for y in eachindex(grid)
        for x in eachindex(grid[y])
            if y >= length(grid) 
                continue
            end
            if grid[y][x] == 'S'
                timelines[y][x] = 1        
            end
            if grid[y][x] == '|' || grid[y][x] == 'S'
                if grid[y+1][x] == '^'
                    grid[y+1][x-1] = '|'
                    timelines[y+1][x-1] = timelines[y+1][x-1] + timelines[y][x]
                    grid[y+1][x+1] = '|'
                    timelines[y+1][x+1] = timelines[y+1][x+1] + timelines[y][x]
                else
                    grid[y+1][x] = '|'
                    timelines[y+1][x] = timelines[y+1][x] + timelines[y][x]
                end
            end
        end
    end
    sum(timelines[length(grid)])
end

export part1, part2

end # module day7
