module day11

using DataStructures
using Memoize

# edge map
function loaddata(istest::Bool, idx::Int=1)
    f = istest ? "./src/test.txt" : "./src/input.txt"
    if istest
        if idx == 1
            f = "./src/test1.txt"
        else
            f = "./src/test2.txt"
        end
    end
    parse_line(s::String) = begin
        ss = split(s, ' ', keepempty=false)
        String(ss[1][1:end-1]) => [String(i) for i in ss[2:end]]
    end
    Dict([parse_line(l) for l in eachline(f) if l != ""])
end

function part1(istest=true)
    d = loaddata(istest)
    # bfs
    q = Queue{String}()
    push!(q, "you")
    count = 0
    while !isempty(q)
        cur = popfirst!(q)
        if cur == "out"
            count += 1
            continue
        end
        if !haskey(d, cur)
            continue
        end
        for n in d[cur]
            push!(q, n)
        end
    end
    count
end

function part2(istest=true)
    dict = loaddata(istest, 2)

    memo = Dict{Tuple{String, Bool, Bool, Int}, Int}()
    function dfs(cur::String, dac, fft::Bool, vs::Vector{String})::Int
        if cur == "out"        
            if dac && fft
                println(vs)
                return 1
            end
            return 0
        end       

        dac2 = cur == "dac" || dac
        fft2 = cur == "fft" || fft

        if haskey(memo, (cur, dac2, fft2, length(vs)))
            return memo[(cur, dac2, fft2, length(vs))]
        end

        nxs = dict[cur] 

        sum = 0        
        for c in nxs
            sum += dfs(c, dac2,fft2, [vs; cur])
        end
        memo[(cur, dac2, fft2, length(vs))] = sum
        sum
    end

    dfs("svr", false, false, String[])
end

export part1, part2

end # module day11
