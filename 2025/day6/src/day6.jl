module day6

function setuptable(istest::Bool = true)::Tuple{Vector{Vector{Int}}, Vector{Int}}
    f = istest ? "./src/test.txt" : "./src/day6.txt"
    res = Vector{Vector{Int}}() 
    res2 = Int[]
    for l in eachline(f)
        if l == "" 
            continue 
        end
        s = split(l, " ", keepempty = false)
        if s[1] == "+" || s[1] == "*"
            # sign
            res2 = map(x -> x == "+" ? 1 : 2, s) 
            break
        end
        push!(res, map(x -> parse(Int, x), s))
    end
    res,res2
end

function part1(istest::Bool = true)
    vals, signs = setuptable(istest)
    xlen = length(vals[1])
    sums = zeros(Int, xlen)

    @inline add_sum(idx, v, sign, isset) = begin
        if isset 
            sums[idx] = v
            return
        end
        if sign == 1 
            sums[idx] += v
        else
            sums[idx] *= v 
        end
    end

    for i in 1:xlen
        si = signs[i]
        for j in eachindex(vals)
            add_sum(i, vals[j][i], si, j == 1)
        end
    end
    println(sums)
    sum(sums)
end

function setuptable2(istest::Bool)
    f = istest ? "./src/test.txt" : "./src/day6.txt"
    res = Vector{String}()
    # sign, pos
    res2 = Vector{Tuple{Int, Int}}()
    for l in eachline(f)
        if l == "" 
            continue 
        end

        if l[1] == '*'
            # sign handle
            for i in eachindex(l)
                if l[i] == ' '
                    continue
                end
                push!(res2, (l[i] == '+' ? 1 : 2, i))
            end
            break
        end

        push!(res, l)
    end
    res, res2
end

# signs updated pos to range
# endpos ==> firstline end pos
# ret: Range array
function convertsigns(signs, endpos)::Vector{UnitRange{Int}}
    res = []
    # reversed
    for i in eachindex(signs) 
        sign, pos = signs[i]
        push!(res, pos:endpos)
        endpos = pos-2
    end
    res
end

function get_nums(vals, rg)
    res = Int[]
    for x in reverse(rg)
        nums = Char[]
        for y in eachindex(vals)
            c = vals[y][x]
            if c == ' ' continue end
            push!(nums, c)
        end
        push!(res, parse(Int, join(nums)))
    end
    res
end

#max value length is 4
function part2(istest::Bool = true)
    vals, signs = setuptable2(istest)
    # need reversed
    signs = reverse(signs)
    signposdata = convertsigns(signs, length(vals[1]))

    println(signs)
    println(signposdata)

    compute_values(vs, sign) = begin
        if sign == 1 
            sum(vs)
        else
            prod(vs)
        end
    end

    res = 0
    for (idx, rg) in enumerate(signposdata)
        vs = get_nums(vals, rg)
        sign = signs[idx][1]
        res += compute_values(vs, sign)
    end
    res
end

export part1, part2

end # module day6
