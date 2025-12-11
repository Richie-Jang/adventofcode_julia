
using Combinatorics

struct Indicator
    lights::Vector{Bool}
    buttons::Vector{Vector{Int}}
    joltages::Vector{Int}
end

"""
added: indexnum for julia
"""
function loaddata(istest::Bool, added = 0)::Vector{Indicator}
    f = istest ? "./src/test.txt" : "./src/input.txt"
    res = Indicator[] 
    reg = r"\[(.+)\]\s+(.+)\{(.+)\}"
    for l in eachline(f)
        m = match(reg, l)
        l1 = [x =='#' for x in m[1]]
        l2 = begin 
            aa = split(m[2], [' ', '(', ')'], keepempty = false)
            rrr = Vector{Vector{Int}}()
            for a in aa
                b = map(x -> parse(Int, x)+added, split(strip(a), ','))
                push!(rrr, b)
            end
            rrr
        end
        l3 = map(x -> parse(Int, x) + added, split(m[3], ',', keepempty = false))
        push!(res, Indicator(l1, l2, l3))
    end
    res
end

function check_min_possible(ind::Indicator)::Int
    function merged(vs::Vector{Vector{Int}})::Vector{Int}
        buttons = fill(0, 20)
        for v in vs
            for a in v
                buttons[a+1] += 1
            end
        end
        for i in eachindex(buttons)
            buttons[i] = buttons[i] % 2
        end
        #println("$vs merged $buttons")
        buttons
    end

    min_possible = length(ind.buttons) ^ 2 
    for vs in combinations(ind.buttons)            
        l = length(vs)
        if l > min_possible continue end
        v = merged(vs)
        checked = true
        for k in eachindex(ind.lights)
            k2 = v[k] == 1
            if ind.lights[k] != k2
                checked = false 
                break
            end
        end
        if checked 
            println("FOUND $vs")
            min_possible = min(min_possible, length(vs))
        end
    end
    min_possible
end

function adjust_joltage(ind::Indicator)::Int
    j = ind.joltages
    bts = ind.buttons
    countval = sum(j)

    function loop(vs::Vector{Int}, idx::Int, count::Int, acc::Vector{Int})
        if j == vs
            println("FOUND : $vs $idx $count $acc")
            if countval > count
                countval = count 
            end
            return
        end
        if countval < count 
            return 
        end

        #println("$vs $idx $count $acc")

        if idx > length(bts)
            idx = 1
        end
        for ii in idx:length(bts)
            isok = true
            for k in bts[ii]
                vs[k] += 1
            end
            for iii in eachindex(j)
                if vs[iii] > j[iii]
                    isok = false
                    break
                end
            end
            if !isok
                for k in bts[ii]
                    vs[k] -= 1
                end
                continue 
            end
            loop(vs, idx+1, count+1, vcat(acc, ii))
            for k in bts[ii]
                vs[k] -= 1
            end
        end
    end
    loop(fill(0, length(j)), 1, 0, Int[])
    countval
end