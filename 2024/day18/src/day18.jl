module day18

using DataStructures

include("dijkstra.jl")

istest = true

const Point = Tuple{Int,Int}

# load as blcoks
function loadData(istest::Bool, takenum::Int)::Tuple{Vector{Point},Tuple{Int,Int}}
    f = istest ? "./src/test.txt" : "./src/input.txt"
    points = Point[]
    ex, ey = 0, 0
    for i in eachline(f)
        x, y = split(i, ",") |> x -> parse.(Int, x) |> y -> (y[1] + 1, y[2] + 1)
        push!(points, (x, y))
        if ex < x
            ex = x
        end
        if ey < y
            ey = y
        end
    end
    if takenum < 0
        return points, (ex, ey)
    end
    r = collect(Iterators.take(points, takenum))
    r, (ex, ey)
end

function bfs(bks::Set{Point}, sx, sy, ex, ey::Int)
    q = PriorityQueue{Point,Int}()
    enqueue!(q, (sx, sy), 0)
    visits = Dict{Point,Int}()
    visits[(sx, sy)] = 0
    while !isempty(q)
        px, py = dequeue!(q)
        dist = visits[(px, py)]
        if px == ex && py == ey
            return dist
        end
        for (dx, dy) in [(0, 1), (1, 0), (0, -1), (-1, 0)]
            nx, ny = px + dx, py + dy
            if nx < 1 || ny < 1 || nx > ex || ny > ey
                continue
            end

            if (nx, ny) in bks
                continue
            end

            if haskey(visits, (nx, ny))
                olddist = visits[(nx, ny)]
                if olddist <= dist + 1
                    continue
                end
                dist = olddist
                delete!(q, (nx, ny))
            end
            visits[(nx, ny)] = dist + 1
            enqueue!(q, (nx, ny), dist + 1)
        end
    end
    return 0
end

function bfs2(bks::Set{Point}, sx, sy, ex, ey::Int)
    dirs = [(0, 1), (1, 0), (0, -1), (-1, 0)]
    q = PriorityQueue{Point,Int}()
    push!(q, (sx, sy) => 0)
    visits = Set{Point}()
    push!(visits, (sx, sy))
    while !isempty(q)
        (px, py), dist = popfirst!(q)
        if px == ex && py == ey
            return dist
        end
        for (dx, dy) in dirs
            nx, ny = px + dx, py + dy
            if nx < 1 || ny < 1 || nx > ex || ny > ey
                continue
            end

            if (nx, ny) in bks
                continue
            end

            if (nx, ny) in visits
                continue
            end

            push!(visits, (nx, ny))
            push!(q, (nx, ny) => dist + 1)
        end
    end
    return -1
end

function part1(istest=true)
    tn = istest ? 12 : 1024
    blks, (ex, ey) = loadData(istest, tn)
    println("$ex, $ey")
    println("$blks")
    bfs2(Set(blks), 1, 1, ex, ey)
end

function part2(istest=true)
    tn = istest ? 12 : 1024
    blks, (ex, ey) = loadData(istest, -1)
    res = 0
    while true
        ss = Set(Iterators.take(blks, tn))
        v = bfs2(ss, 1, 1, ex, ey)
        println("$tn: $v")
        if v == -1
            res = tn
            break
        end
        tn += 1
    end
    blks[res] |> x -> (x[1] - 1, x[2] - 1)
end

export part1, part2, testdijkstra

end # module day18
