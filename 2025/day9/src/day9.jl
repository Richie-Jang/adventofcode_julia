module day9

using DataStructures

function loaddata(istest::Bool)
    f = istest ? "./src/test.txt" : "./src/input.txt"
    parse_line(s::String) = map(x -> parse(Int, x), split(s, ",")) |> x -> (x[1], x[2])
    return [parse_line(l) for l in eachline(f)]
end

function part1(istest::Bool=true)
    data = loaddata(istest)
    area = 0
    for i in 1:length(data)-1
        for j in i+1:length(data)
            p1 = data[i]
            p2 = data[j]
            w1, h2 = abs(p1[1] - p2[1]) + 1, abs(p1[2] - p2[2]) + 1
            if area < w1 * h2
                area = w1 * h2
            end
        end
    end
    println(area)
end

"""
    inside green (1) filled
"""
function floodfill_outside(grid::Vector{Vector{Int}})
    outsides = Set(
        [(0, 1),
        (0, length(grid[1])),
        (length(grid) + 1, 1), (length(grid) + 1, length(grid[1]))])

    que = Queue{Tuple{Int,Int}}()
    enqueue!(que, (0, 1))
    enqueue!(que, (0, length(grid[1])))
    enqueue!(que, (length(grid) + 1, 1))
    enqueue!(que, (length(grid) + 1, length(grid[1])))

    dirs = [(-1, 0), (1, 0), (0, -1), (0, 1)]

    while !isempty(que)
        cx, cy = dequeue!(que)
        for (dx, dy) in dirs
            nx, ny = cx + dx, cy + dy
            if 1 <= nx <= length(grid) && 1 <= ny <= length(grid[1])
                if grid[nx][ny] > 0
                    continue
                end
                if (nx, ny) in outsides
                    continue
                end
                push!(outsides, (nx, ny))
                enqueue!(que, (nx, ny))
            end
        end
    end

    for x in eachindex(grid)
        for y in eachindex(grid[1])
            if (x, y) ∉ outsides
                if grid[x][y] == 0
                    grid[x][y] = 1
                end
            end
        end
    end
end

function is_valid(grid::Vector{Vector{Int}}, cx1::Int, cy1::Int, cx2::Int, cy2::Int)
    gcount = 0
    for cx in cx1:cx2
        for cy in cy1:cy2
            if grid[cx][cy] > 0
                gcount += 1
            end
        end
    end
    vx = abs(cx1 - cx2) + 1
    vy = abs(cy1 - cy2) + 1
    area = vx * vy
    return gcount == area
end

function part2(istest::Bool=true)
    points = loaddata(istest)
    xs = unique([x for (x, _) in points])
    ys = unique([y for (_, y) in points])
    sort!(xs)
    sort!(ys)

    compute_newindex(v::Int) = (v - 1) * 2 + 1

    grid = [fill(0, length(ys) * 2 - 1) for _ in 1:(length(xs)*2-1)]

    for ((x1, y1), (x2, y2)) in zip(points, [points[2:end]; points[1]])
        cx1, cx2 = sort([compute_newindex(findfirst(==(x1), xs)), compute_newindex(findfirst(==(x2), xs))])
        cy1, cy2 = sort([compute_newindex(findfirst(==(y1), ys)), compute_newindex(findfirst(==(y2), ys))])
        for cx in cx1:cx2
            for cy in cy1:cy2
                grid[cx][cy] += 1
            end
        end
    end

    # floodfilled
    floodfill_outside(grid)

    println(join(grid, "\n"))

    max_area = 0

    for py in 1:length(points)-1
        for px in py+1:length(points)
            p1 = points[px]
            p2 = points[py]
            cx1, cx2 = sort([compute_newindex(findfirst(==(p1[1]), xs)), compute_newindex(findfirst(==(p2[1]), xs))])
            cy1, cy2 = sort([compute_newindex(findfirst(==(p1[2]), ys)), compute_newindex(findfirst(==(p2[2]), ys))])
            if is_valid(grid, cx1, cy1, cx2, cy2)
                vx = abs(p1[1] - p2[1]) + 1
                vy = abs(p1[2] - p2[2]) + 1
                max_area = max(max_area, vx * vy)
            end
        end
    end

    println(max_area)
end

export part1, part2

end # module day9
