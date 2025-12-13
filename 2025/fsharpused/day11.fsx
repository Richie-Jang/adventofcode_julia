open System
open System.IO
open System.Collections.Generic

let filepaths = [|
    @"D:\StudyProgramming\adventofcode\2025\day11\src\test1.txt";
    @"D:\StudyProgramming\adventofcode\2025\day11\src\test2.txt";
    @"D:\StudyProgramming\adventofcode\2025\day11\src\input.txt";
|]


let loadData (istest: bool) (part: int) =
    let f = 
        if istest && part = 1 then filepaths[0]
        elif istest && part = 2 then filepaths[1]
        else filepaths[2]

    let parse_line (s: string) =
        s.Split()
        |> fun v -> 
            let l = v[0].Length
            v[0][0..l-2], v[1..]

    File.ReadLines(f)
    |> Seq.map parse_line
    |> Map.ofSeq

let solvePart1 istest =
    let data = loadData istest 1

    let rec dfs (cur: string) =
        if cur = "out" then
            1
        elif data.ContainsKey(cur) |> not then
            raise <| Exception($"{cur} is not existed in key")
        else            
            data[cur]
            |> Array.map(fun a -> dfs a)
            |> Array.sum
    //

    dfs "you"


let solvePart2 istest =
    let data = loadData istest 2
    let memo = Dictionary<(string*bool*bool*int),int64>()
    let rec dfs cur dac fft (visits: string list) =
        if cur = "out" then
            if dac && fft then 
                printfn "%A" visits
                1L 
            else 0L
        elif data.ContainsKey(cur) |> not then
            raise <| Exception($"{cur} is not existed in key")
        elif memo.ContainsKey((cur, dac, fft, visits.Length)) then
            memo[(cur, dac, fft, visits.Length)]
        else
            let dac2 = dac || cur = "dac"
            let fft2 = fft || cur = "fft"            
            let nsum = 
                data[cur]            
                |> Array.map(fun a ->
                    dfs a dac2 fft2 (cur :: visits)
                )
                |> Array.sum
            memo.Add((cur, dac, fft, visits.Length), nsum)
            nsum
        //
    //
    dfs "svr" false false []


