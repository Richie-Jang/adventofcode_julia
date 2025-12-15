package day12

import scala.collection.mutable as mut

type Region = Vector[(Int, Int)]

def cardinalPositions(x: Int, y: Int): List[(Int, Int)] =
    List((x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1))

def neighborPositions(x: Int, y: Int): List[(Int, Int)] =
    (x - 1 to x + 1).flatMap { ix =>
        (y - 1 to y + 1).flatMap { iy =>
            Option.when(ix != x || iy != y)(ix -> iy)
        }
    }.toList

extension (region: Region) {
    def asPlantMap: PlantMap = {
        val mx = region.maxBy(_._1)._1
        val my = region.maxBy(_._2)._2
        val res = mut.ArrayBuffer.fill(my + 1, mx + 1)('.')
        region.foreach { (x, y) =>
            res(y)(x) = '#'
        }
        PlantMap(res.map(_.mkString("", "", "")).toVector)
    }

    def inflate: Region = {
        region.flatMap((x,y) => List((x*2,y*2), (x*2+1,y*2), (x*2, y*2+1), (x*2+1, y*2+1)))
    }

    def area: Int = region.size
    def sides: Int = {
        val bigRegion = region.inflate
        println(s"region: $region")
        println(s"big: $bigRegion")
        val regionMap = bigRegion.asPlantMap
        println(regionMap.plants.mkString("\n"))
        val gg = bigRegion.count {(x,y) => 
            val nc = regionMap.optionalNeighbors(x,y).count(_.contains('#'))
            println(s"($x,$y) : $nc")
            nc match {
                case 3 | 4 | 7 => true
                case _ => false
            }    
        }        
        println(s"found sides : $gg")
        gg
    }
}

case class PlantMap(plants: Vector[String]) {
    val height = plants.length
    val width = plants.head.length

    def apply(x: Int, y: Int): Char = plants(y)(x)

    def isDefinedAt(x: Int, y: Int): Boolean =
        x >= 0 && x < width && y >= 0 && y < height

    def get(x: Int, y: Int): Option[Char] =
        Option.when(isDefinedAt(x, y))(apply(x, y))

    def indices: Region = {
        (for
            y <- 0 until height
            x <- 0 until width
        yield (x, y)).toVector
    }

    def optionalCardinalNeighbors(x: Int, y: Int): List[Option[Char]] =
        cardinalPositions(x, y).map(get)

    def optionalNeighbors(x: Int, y: Int): List[Option[Char]] =
        neighborPositions(x, y).map(get)

    def floodFill(x: Int, y: Int): Region = {
        val q = mut.Queue.empty[(Int,Int)]
        val c = apply(x,y)
        val res = mut.ListBuffer.empty[(Int,Int)]
        q.enqueue(x -> y)
        while q.nonEmpty do {
            val n = q.dequeue()
            if get(n._1, n._2).contains(c) && !res.contains(n) then
                res.prepend(n)
                q.addAll(cardinalPositions(n._1, n._2))
        }
        res.toVector
    }

    def regions: List[Region] = 
        List.unfold[Region, Vector[(Int,Int)]](this.indices) { acc => 
            acc.headOption.map { head =>
                val points = floodFill(head._1, head._2)
                (points, acc.diff(points))    
            }    
        }
}

def parse(str: Iterator[String]): PlantMap = 
    PlantMap(str.toVector)

@main def part2Another(): Unit = {
    //val plants = parse(io.Source.fromFile("./src/main/scala/day12/input.txt").getLines)
    val plants = parse(io.Source.fromFile("./src/main/scala/day12/test2.txt").getLines)
    println(plants.regions.map(r => r.area * r.sides).sum)
}
