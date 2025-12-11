
# reference other guy solution for studying new tech.
struct Machine
    lights::Int
    buttons::Vector{Int}
    jolts::Vector{Int}
end

function convert_lightstr_int(lstr::String)::Int    
    res = 0
    for (i,c) in enumerate(lstr)
        if c == '#'
            res |= 1 << (i-1)
        end
    end
    res
end

function convert_buttonstr_intarr(bstr::String)::Vector{Int}
    ss = split(bstr, [' ', '(', ')'], keepempty = false)
    res = Int[]
    for s in ss
        res1 = 0
        iarr = map(x -> parse(Int, x),split(s, ','))
        for i in iarr
            res1 |= 1 << i
        end
        push!(res, res1)
    end
    res
end

function loaddata2(istest::Bool)
    f = istest ? "./src/test.txt" : "./src/input.txt"
    reg = r"\[([.#]+)\]\s+(.+)\{(.+)\}"
    res = Machine[]
    for l in eachline(f)
        m = match(reg, l)
        lval = convert_lightstr_int(String(m[1]))
        bs = convert_buttonstr_intarr(String(strip(m[2])))
        js = map(x -> parse(Int, x), split(strip(m[3]), ',', keepempty=false))
        push!(res, Machine(lval, bs, js))
    end
    res
end

using DataStructures

function bfs(mc::Machine)
    que = Deque{Int}()
    push!(que, 0)
    # curlights -> (beforelight, count)
    distances = Dict{Int, Tuple{Int, Int}}()
    distances[0] = (0, 0)
    goal = mc.lights
    while !isempty(que)
        cur = popfirst!(que)
        d = distances[cur][2]
        if cur == goal
            return d 
        end
        for n in [i ⊻ cur for i in mc.buttons]
            if !haskey(distances, n)
                distances[n] = (cur, d + 1)
                push!(que, n)
            end
        end
    end    
    -1
end

function solvepart1(istest::Bool = true)
    sum([bfs(mc) for mc in loaddata2(istest)])
end

function solvepart2(istest::Bool = true)

end