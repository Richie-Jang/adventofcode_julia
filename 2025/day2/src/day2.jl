module day2

testfile = raw"./src/test.txt"
inputfile = raw"./src/day2.txt"

function make_range_arr(f::AbstractString)::Vector{UnitRange{Int}}
    res = UnitRange{Int}[]
    for i in eachline(f)
        if i == ""
            continue
        end
        ss = split(i, ",")
        for s in ss
            if s == ""
                continue
            end
            v = split(s, "-")
            push!(res, UnitRange(parse(Int, v[1]), parse(Int, v[2])))
        end
    end
    res
end

function solution1(data::Vector{UnitRange{Int}})
    res = 0
    for i in data
        for j in i
            s = string(j)
            len = length(s)
            if len % 2 != 0
                continue
            end
            half = len ÷ 2
            firstnum = s[1:half]
            secondnum = s[half+1:end]
            if firstnum == secondnum
                res += j
            end
        end
    end
    res
end

function get_divisors(i::Int)::Vector{Int}
    r = trunc(sqrt(i))
    r2 = [j for j = 1:r if i % j == 0]
    res = Int[]
    for j in r2
        if j == 1
            push!(res, j)
            continue
        end
        k = i ÷ j
        push!(res, j)
        push!(res, k)
    end
    sort(res, rev=true)
end

function check_num_with_divisors(s::String, ds::Vector{Int}, idx::Int)::Bool
    if idx == 0
        return false
    end
    d = ds[idx]
    strs = collect(Iterators.partition(s, d))
    if length(strs) <= 1
        return false
    end
    for i = 1:length(strs)-1
        if strs[i] != strs[i+1]
            return check_num_with_divisors(s, ds, idx - 1)
        end
    end
    return true
end

function solution2(data::Vector{UnitRange{Int}})::Int
    res = 0
    for r in data
        for j in r
            s = string(j)
            ds = get_divisors(length(s))
            if check_num_with_divisors(s, ds, length(ds))
                res += j
                println("$r : $j")
            end
        end
    end
    res
end

function part1(istestcase::Bool)
    f = istestcase ? testfile : inputfile
    solution1(make_range_arr(f))
end

function part2(istestcase::Bool)
    f = istestcase ? testfile : inputfile
    solution2(make_range_arr(f))
end

export part1, part2

end # module day2
