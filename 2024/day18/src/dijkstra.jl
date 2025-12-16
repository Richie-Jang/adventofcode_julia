using DataStructures

const Edges = Vector{Pair{Int,Int}}

function testdijkstra()
    adjs = Dict{Int,Edges}()
    # setup
    adjs[1] = [2 => 2, 4 => 1, 3 => 5]
    adjs[2] = [1 => 2, 4 => 2, 3 => 3]
    adjs[3] = [2 => 3, 1 => 5, 4 => 3, 5 => 1, 6 => 5]
    adjs[4] = [1 => 1, 2 => 2, 3 => 3, 5 => 1]
    adjs[5] = [4 => 1, 3 => 1, 6 => 2]
    adjs[6] = [5 => 2, 3 => 5]

    # start 1 => end 6
    # Node, Weight
    pq = PriorityQueue{Int,Int}()
    pq[1] = 0
    visits = Set{Int}([1])
    while !isempty(pq)
        n, w = popfirst!(pq)
        if n == 6
            return w
        end
        for (nn, ww) in adjs[n]
            if nn in visits
                continue
            end
            ndist = w + ww
            if haskey(pq, nn)
                olddist = pq[nn]
                if olddist <= ndist
                    continue
                end
                pq[nn] = ndist
                continue
            end
            pq[nn] = ndist
            push!(visits, nn)
        end
    end
    return typemax(Int)
end