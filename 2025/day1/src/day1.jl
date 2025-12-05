module day1

testcase = """L68
L30
R48
L5
R60
L55
L1
L99
R14
L82"""

@enum Dir LEFT RIGHT

function parseinputstr(inp::String)
    dirs = Vector{Tuple{Dir,Int}}()
    for i in split(inp, "\n")
        ii = strip(i)
        if ii == ""
            continue
        end
        if ii[1] == 'L'
            push!(dirs, (LEFT, parse(Int, ii[2:end])))
        elseif ii[1] == 'R'
            push!(dirs, (RIGHT, parse(Int, ii[2:end])))
        end
    end
    dirs
end

function parseinputfile(f::String)
    dirs = Vector{Tuple{Dir,Int}}()
    for i in eachline(f)
        ii = strip(i)
        if ii == ""
            continue
        end
        if ii[1] == 'L'
            push!(dirs, (LEFT, parse(Int, ii[2:end])))
        elseif ii[1] == 'R'
            push!(dirs, (RIGHT, parse(Int, ii[2:end])))
        end
    end
    dirs
end

function part2(usetestcase::Bool)
    data = usetestcase ? parseinputstr(testcase) : parseinputfile("./src/data.txt")

    startpoint = 50
    nextpoint = 0
    keycount = 0
    for (d, v) in data
        if d == LEFT
            nextpoint = startpoint - v
        else
            nextpoint = startpoint + v
        end

        cur1 = fld(startpoint, 100)
        next1 = fld(nextpoint, 100)
        cross = abs(next1 - cur1)
        keycount += cross
        startpoint = mod(nextpoint, 100)
    end

    println("Key count: $keycount")
end

function part1(usetestcase::Bool)
    data = usetestcase ? parseinputstr(testcase) : parseinputfile("./src/data.txt")

    keycount = 0
    function correctpoint(v::Int)
        if 0 <= v < 100
            if v == 0
                keycount += 1
            end
            return v
        end
        if v < 0
            correctpoint(v + 100)
        else
            correctpoint(v - 100)
        end
    end

    startpoint = 50
    for (d, v) in data
        if d == LEFT
            startpoint -= v
        elseif d == RIGHT
            startpoint += v
        end
        startpoint = correctpoint(startpoint)
        println("$d $v applied: $startpoint")
    end

    println("Key count: $keycount")
end

end # module day1
