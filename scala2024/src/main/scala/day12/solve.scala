package day12

val dirs = Vector((0,1),(1,0),(0,-1),(-1,0))

def loadData(istest: Boolean = true, part: Int = 1): Vector[String] = {
    var f = if istest then "./src/main/scala/day12/test.txt" else "./src/main/scala/day12/input.txt"
    if part == 2 && istest then 
        f = "./src/main/scala/day12/test2.txt" 
    val br = io.Source.fromFile(f)
    val res = br.getLines.toVector
    br.close()
    res
}

import scala.collection.mutable as m

def countRegionsPerimeter(data: Vector[String]): Long = {
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

// part2
// my idea is counting corner
def countSides(data: Vector[String]): Long = {
    val (h,w) = data.length -> data.head.length
    val visits = m.Set.empty[(Int,Int)]

    def dfs(sx: Int, sy: Int, c: Char, acc: m.Set[(Int,Int)]): Unit = {
        if sx < 0 || sx >= w || sy < 0 || sy >= h then return
        if data(sy)(sx) != c then return
        if visits.contains((sy,sx)) then return
        visits += sy -> sx
        acc += sy -> sx
        for d <- dirs do {
            val (ny, nx) = (sy + d._1, sx + d._2)
            dfs(nx, ny, c, acc)
        }        
    }

    /**
      * half position from edge { corner } changes
      *      
      */
    def getSides(rg: m.Set[(Int,Int)]): Int = {
        var res = 0
        val corSet = m.Set.empty[(Double, Double)]
        val cors = Array((-0.5, -0.5), (-0.5, 0.5), (0.5, -0.5), (0.5, 0.5))

        // grid point => corner positions { 0.5 }
        def corners(y: Double, x: Double): Array[(Double, Double)] = {
            cors.map{ g =>
                (g._1 + y, g._2 + x) }
        }

        var mset = Set.empty[((Int,Int))]

        // corners...
        val corner_candidates = 
            rg.flatMap{r => corners(r._1.toDouble, r._2.toDouble) }
        
        
        var result = 0
        for (cy,cx) <- corner_candidates do {
            // corners to corners again ==> It changes grid points now
            val config = corners(cy,cx).map(a => a._1.toInt -> a._2.toInt).map(a => rg.contains(a))
            val trueCount = config.count(a => a)
            trueCount match {
                //  | 
                // _ * 
                case 1 => result += 1
                //   |
                //  _ * _
                //   | |
                case 3 => result += 1
                case 2 if config.sameElements(Array(true,false,false,true)) || config.sameElements(Array(false, true, true, false)) => 
                    result += 2
                case _ => ()          
            }
        }
        result
    }

    var result = 0L
    var diagonalSet = Set.empty[(Int,Int)]

    for 
        y <- data.indices
        x <- data.head.indices
    do {
        val c = data(y)(x)
        if !visits.contains((y,x)) then {
            val acc = m.Set.empty[(Int,Int)]
            val digs = m.Set.empty[(Int,Int)]
            dfs(x,y,c,acc)
            val regionCount = acc.size
            val sides = getSides(acc)
            println(s"$c -> $regionCount * $sides = ${regionCount * sides}")
            result += regionCount * sides
        }            
    }
    result
}

@main def solve12Part1(): Unit = {
    val data = loadData(false)
    println(s"part1 : ${countRegionsPerimeter(data)}")
}

@main def solve12Part2(): Unit = {
    val data = loadData(false,2)
    println(countSides(data))
}