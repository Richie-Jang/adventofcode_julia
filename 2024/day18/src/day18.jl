module day18

using DataStructures

istest = true

# load as blcoks
function loadData(istest::Bool, takenum::Int)::Tuple{Set{Tuple{Int,Int}},Tuple{Int,Int}}
    f = istest ? "./src/test.txt" : "./src/input.txt"
    points = Tuple{Int,Int}[]
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
    r = Set(Iterators.take(points, takenum))
    r, (ex, ey)
end

function bfs(bks::Set{Tuple{Int,Int}}, sx, sy, ex, ey::Int)
    q = PriorityQueue{Tuple{Int,Int},Int}()
    enqueue!(q, (sx, sy), 0)
    visits = Dict{Tuple{Int,Int},Int}()
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

function part1(istest=true)
    tn = istest ? 12 : 1024
    blks, (ex, ey) = loadData(istest, tn)
    println("$ex, $ey")
    println("$blks")
    bfs(blks, 1, 1, ex, ey)
end

export part1

end # module day18
