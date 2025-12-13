open System
open System.IO

let files =
    [| @"d:\StudyProgramming\adventofcode\2025\day8\src\test.txt"
       @"d:\StudyProgramming\adventofcode\2025\day8\src\input.txt" |]

type Point = { idx: int; x: int; y: int; z: int }

let loadData istest =
    let f = if istest then files[0] else files[1]

    let parse_line (i: int) (s: string) =
        s.Split([| ',' |])
        |> Array.map int
        |> fun a ->
            { idx = i
              x = a.[0]
              y = a.[1]
              z = a.[2] }

    File.ReadAllLines(f) |> Seq.mapi parse_line |> Seq.toArray

let computeDistance (a: Point) b =
    let x = float (a.x - b.x)
    let y = float (a.y - b.y)
    let z = float (a.z - b.z)
    sqrt (x * x + y * y + z * z)

let makeClosets (data: Point[]) =
    [| for i in 0 .. data.Length - 1 do
           for j in i + 1 .. data.Length - 1 do
               let d = computeDistance data.[i] data.[j]
               yield (data.[i], data.[j], d) |]
    |> Array.sortBy (fun (_, _, a) -> a)

let disJointHandle (data: Point[]) (closets: (Point * Point * float)[]) (ckcount: int) =
    // check union
    let parents = Array.init (data.Length) id
    printfn "init: %A" parents

    let rec find (idx: int) =
        let nidx = parents[idx]

        if nidx = idx then
            idx
        else
            let nidx2 = find nidx
            parents[idx] <- nidx2
            nidx2

    let union (a: int) (b: int) =
        let fa = find a
        let fb = find b

        if fa = fb then
            false
        else
            parents[fb] <- fa
            true

    let rec makeShortConnections count =
        if count = ckcount then
            ()
        else
            let p1, p2, dist = closets[count]
            union p1.idx p2.idx |> ignore
            makeShortConnections (count + 1)

    let collectParents () =
        for i in 0 .. data.Length - 1 do
            parents[i] <- find i

        let arr = Array.countBy id parents |> Array.sortBy (fun (_, b) -> b) |> Array.rev
        printfn "%A" arr
        arr
    //let

    makeShortConnections 0
    let arr = collectParents ()
    arr |> Array.take 3 |> Array.map snd |> Array.fold (fun st i -> i * st) 1

let solvePart1 istest =
    let data = loadData istest
    let closets = makeClosets data
    let checkcount = if istest then 10 else 1000
    disJointHandle data closets checkcount
