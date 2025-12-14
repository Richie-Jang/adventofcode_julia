package day12

val dirs = Vector((0,1),(1,0),(0,-1),(-1,0))

def loadData(istest: Boolean = true): Vector[String] = {
    val f = if istest then "./src/main/scala/day12/test.txt" else "./src/main/scala/day12/input.txt"
    val br = io.Source.fromFile(f)
    val res = br.getLines.toVector
    br.close()
    res
}

import scala.collection.mutable as m

def searchRegions(data: Vector[String]): Long = {
    val h = data.length
    val w = data.head.length
    val visited = m.Set.empty[(Int,Int)]

    def dfs(sx: Int, sy: Int, c: Char, vs: m.Set[(Int,Int)]): Unit = {
        if sx < 0 || sx >= w || sy < 0 || sy >= h then return
        if data(sy)(sx) != c then return
        if visited.contains((sy,sx)) then return
        visited += sy -> sx
        vs += sy -> sx
        for dr <- dirs do
            dfs(sx + dr._1, sy + dr._2, c, vs)
    }

    def computePerimeter(vs: m.Set[(Int,Int)]): Int = {
        var res = 0

        @inline def isBoundary(y: Int, x: Int, c: Char): Boolean =
            x < 0 || x >= w || y < 0 || y >= h || c != data(y)(x)

        for v <- vs do {
            val c = data(v._1)(v._2)
            for dr <- dirs do {
                val ny = v._1 + dr._1
                val nx = v._2 + dr._2
                if isBoundary(ny,nx,c) then res += 1
            }
        }
        res
    }

    var result = 0L

    for 
        y <- data.indices
        x <- data.head.indices
    do {
        if !visited.contains((y,x)) then 
            val c = data(y)(x)
            val vs = m.Set.empty[(Int,Int)]
            dfs(x,y,c,vs)
            val area = vs.size
            val perimeter = computePerimeter(vs)
            println(s"$c area : $area , perimeter : $perimeter")
            result += area * perimeter
    }

    result
}

@main def solve12Part1(): Unit = {
    val data = loadData(false)
    println(s"part1 : ${searchRegions(data)}")
}

@main def solve12Part2(): Unit = {

}