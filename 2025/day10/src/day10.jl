module day10

include("trial1.jl")
include("trial2.jl")

function part1(istest = true)
    solvepart1(istest)
end

function part2(istest = true)
    data = loaddata(istest, 1)
    adjust_joltage(data[1])
end

export part1, part2

end # module day10
