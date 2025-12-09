module day8

struct Point
    idx::Int
    x::Int
    y::Int
    z::Int
end

function loaddata(istest::Bool)::Vector{Point}
    f = istest ? "./src/test.txt" : "./src/input.txt"
    data = Vector{Point}()
    idx = 1
    for l in eachline(f)
        a = parse.(Int, split(l, ","))
        push!(data, Point(idx, a[1], a[2], a[3]))
        idx += 1
    end
    data
end

function dist(a::Point, b::Point)::Float64
    return sqrt((a.x - b.x)^2 + (a.y - b.y)^2 + (a.z - b.z)^2)
end

function disjoint(data::Vector{Point}, edges::Vector{Tuple{Point,Point,Float64}}, limitcount::Int=10)
    # setup parents
    parents = fill(1, length(data))
    for i in eachindex(parents)
        parents[i] = i
    end

    function find(i::Int)::Int
        root = parents[i]
        if i == root
            return i
        end
        parents[i] = find(root)
        return parents[i]
    end

    function makeunion(i::Int, j::Int)
        rooti = find(i)
        rootj = find(j)
        if rooti != rootj
            parents[rootj] = rooti
            return true
        end
        return false
    end

    function checkingcircuits()
        countindividual = 0
        countgroup = Dict{Int,Set{Int}}()
        for i in reverse(eachindex(parents))
            root = find(i)
            if root == i
                if haskey(countgroup, i)
                    push!(countgroup[i], i)
                else
                    countindividual += 1
                end
            else
                set = get(countgroup, root, Set{Int}())
                push!(set, i)
                countgroup[root] = set
            end
        end
        println("single: $countindividual group: $(countgroup)")
        sorted = sort(map(x -> length(x), collect(values(countgroup))), rev=true)
        prod(sorted[1:3])
    end

    connections = 0
    for edge in edges
        makeunion(edge[1].idx, edge[2].idx)
        connections += 1
        if connections == limitcount
            break
        end
    end
    checkingcircuits()
end

function part1(istest::Bool=true)
    data = loaddata(istest)
    closets = Vector{Tuple{Point,Point,Float64}}()
    for i in 1:length(data)-1
        for j in i+1:length(data)
            d = dist(data[i], data[j])
            if data[i].idx < data[j].idx
                push!(closets, (data[i], data[j], d))
            else
                push!(closets, (data[j], data[i], d))
            end
        end
    end

    sort!(closets, by=x -> x[3])
    lm = istest ? 10 : 1000
    disjoint(data, closets, lm)
end

function disjoint2(data::Vector{Point}, edges::Vector{Tuple{Point,Point,Float64}})
    # setup parents
    parents = fill(1, length(data))
    for i in eachindex(parents)
        parents[i] = i
    end

    function find(i::Int)::Int
        root = parents[i]
        if i == root
            return i
        end
        parents[i] = find(root)
        return parents[i]
    end

    function makeunion(i::Int, j::Int)
        rooti = find(i)
        rootj = find(j)
        if rooti != rootj
            parents[rootj] = rooti
            return true
        end
        return false
    end

    checkingparents() = begin
        d = Dict{Int,Int}()
        for i in eachindex(parents)
            r = find(i)
            if haskey(d, r)
                d[r] += 1
            else
                d[r] = 1
            end
        end
        if length(d) > 2
            return false, -1, 0
        end
        dd = collect(d)
        sort!(dd, by=x -> x[2])
        true, dd[1][1], dd[2][1]
    end

    cons = 0
    for edge in edges
        done, small, big = checkingparents()
        if done
            a1 = find(edge[1].idx)
            a2 = find(edge[2].idx)
            if a1 == small && a2 == big || a1 == big && a2 == small
                println(edge)
                println(edge[1].x * edge[2].x)
                break
            end
        end
        makeunion(edge[1].idx, edge[2].idx)
        cons += 1
    end

end

function part2(istest::Bool=true)
    data = loaddata(istest)
    closets = Vector{Tuple{Point,Point,Float64}}()
    for i in 1:length(data)-1
        for j in i+1:length(data)
            d = dist(data[i], data[j])
            if data[i].idx < data[j].idx
                push!(closets, (data[i], data[j], d))
            else
                push!(closets, (data[j], data[i], d))
            end
        end
    end
    sort!(closets, by=x -> x[3])
    disjoint2(data, closets)
end

export part1, part2

end # module day8
