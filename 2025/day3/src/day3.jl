module day3

function findmax2digits(s::String)::Int
    ds = str_to_ints(s)
    mvalue = 0

    @inline getfirstdigit() = mvalue ÷ 10

    for i = 1:length(ds)-1
        g = getfirstdigit()
        if ds[i] < g
            continue
        end
        for j = i+1:length(ds)
            m = ds[i] * 10 + ds[j]
            if mvalue < m
                mvalue = m
            end
        end
    end
    return mvalue
end

function str_to_ints(s::String)::Vector{Int}
    return map(x -> Int(x - '0'), collect(s))
end

function findlargestnumber(s::Vector{Int}, count::Int=12)::Vector{Int}
    len = length(s)
    #calculate position with count
    poss = [len - i + 1 for i in count:-1:1]
    curpos = 1
    res = Int[]
    for p in poss
        maxv, newpos = findmax(s[curpos:p])
        # npos is relatived value.. need to compute original positioon
        curpos = newpos + curpos
        push!(res, maxv)
    end
    return res
end

function convert_int_from_vector(v::Vector{Int})::Int
    return parse(Int, join(v, ""))
end

export part1, part2

function part1(istestcase)
    f = istestcase ? "./src/test.txt" : "./src/day3.txt"
    fs = [findmax2digits(l) for l in eachline(f) if l != ""]
    println(join(fs, ","))
    return sum(fs)
end

function part2(istestcase::Bool)
    f = istestcase ? "./src/test.txt" : "./src/day3.txt"
    fs = [str_to_ints(i) for i in eachline(f) if i != ""]
    ns = [convert_int_from_vector(findlargestnumber(i)) for i in fs]
    sum(ns)
end

end # module day3
