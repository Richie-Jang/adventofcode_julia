module day1

function loaddata(istest::Bool)::Tuple{Vector{Int},Vector{Int}}
    f = istest ? "./src/test.txt" : "./src/day1.txt"
    data1 = Int[]
    data2 = Int[]
    for i in eachline(f)
        if i == ""
            continue
        end
        a = split(i, " ", keepempty=false)
        push!(data1, parse(Int, a[1]))
        push!(data2, parse(Int, a[2]))
    end
    data1, data2
end

function part1(istest::Bool=true)::Int
    data1, data2 = loaddata(istest)
    sort!(data1)
    sort!(data2)
    sum = 0
    for i in eachindex(data1)
        f1 = data1[i]
        f2 = data2[i]
        f3 = abs(f2 - f1)
        print("$f3  ")
        sum += f3
    end
    println()
    sum
end

function part2(istest::Bool=true)::Int
    d1, d2 = loaddata(istest)
    # change count dict from d2
    countdict = Dict{Int,Int}()
    for i in d2
        if haskey(countdict, i)
            countdict[i] += 1
        else
            countdict[i] = 1
        end
    end

    sum = 0
    # for loop check d1 item in dict
    for i in d1
        rightv = get(countdict, i, 0)
        sum += i * rightv
    end
    sum
end

export part1, part2

end # module day1
