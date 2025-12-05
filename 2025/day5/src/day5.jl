module day5

function loaddata(istestcase::Bool; sorted::Bool=true)
    f = istestcase ? "./src/test.txt" : "./src/day5.txt"
    rgs = UnitRange{Int}[]
    ids = Int[]
    isrgs = true
    for l in eachline(f)
        if l == ""
            isrgs = false
            continue
        end
        if isrgs
            s = split(l, "-")
            push!(rgs, parse(Int, s[1]):parse(Int, s[2]))
        else
            push!(ids, parse(Int, l))
        end
    end
    if sorted 
        sort(rgs, by = x -> x[1]), sort(ids)
    else
        rgs, ids
    end
end


function part1(istestcase::Bool=true)
    rgs, ids = loaddata(istestcase)

    freshcount = 0

    function check_id(id::Int, rg::UnitRange{Int})
        if first(rg) > id || last(rg) < id
            return false
        end
        return true    
    end

    checkedidx = 1

    for id in ids
        for i in checkedidx:length(rgs) 
            rg = rgs[i]
            if check_id(id, rg)
                checkedidx = i
                freshcount += 1
                break
            end
        end
    end

    freshcount
end

function part2(istestcase::Bool=true)
    rgs, _ = loaddata(istestcase)
    
    function get_count(r::UnitRange{Int})::Int
        return last(r) - first(r) + 1
    end

    # 1-5 (5)
    # 5-8 (4)
    # total: 1-8 (8)
    # interset : 5-5 (1)
    # new count = 5 + 4 - 1 = 8

    count = get_count(rgs[1])
    len = length(rgs)
    prevlast = last(rgs[1])
    for i in 2:len
        r = rgs[i]
        f,e = first(r), last(r)
        ccount = get_count(r)
        if e <= prevlast
            # fully contained
            continue
        end
        if f <= prevlast
            # partial overlap
            overlap = prevlast - f + 1
            count += ccount - overlap
        else
            # no overlap
            count += ccount
        end
        prevlast = e
    end
    count
end


export part1, part2
end # module day5
