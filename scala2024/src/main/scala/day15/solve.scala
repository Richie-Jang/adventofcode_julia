package day15

import scala.collection.mutable as mut

type Grid = Vector[Array[Char]]

// global
var grid: Grid = Vector.empty

/** * ret: commands, robot pos global grid is updated
  */
def loadData(istest: Boolean = true): (String, (Int, Int)) = {
    val f =
        if istest then "./src/main/scala/day15/test.txt"
        else "./src/main/scala/day15/input.txt"
    val buf = mut.ArrayBuffer.empty[Array[Char]]
    val coms = mut.ArrayBuffer.empty[String]
    var isfirst = true
    var (px, py) = 0 -> 0

    for l <- io.Source.fromFile(f).getLines() do {
        if l == "" then isfirst = false
        else if isfirst then
            if l.contains("@") then
                py = buf.length
                px = l.indexOf('@')
            //
            buf.addOne(l.toCharArray)
        else coms.addOne(l)
    }
    grid = buf.toVector
    (coms.mkString(""), px -> py)
}

/** update grid by operator @ret: new robot pos */
def robotOper(com: Char, rbpos: (Int, Int)): (Int, Int) = {

    def moveLeft(
        y: Int,
        x: Int,
        needToMoves: List[Int],
        cur: (Int, Int)
    ): (Int, Int) = {
        val g = grid(y)(x)
        if g == '#' then return cur
        if g == '.' then {
            needToMoves.map(a => a - 1).foreach { b =>
                grid(y)(b) = 'O'
            }

            grid(rbpos._1)(rbpos._2) = '.'
            return (cur._1, cur._2 - 1)
        }
        moveLeft(y, x - 1, x :: needToMoves, cur)
    }

    def moveRight(
        y: Int,
        x: Int,
        needToMoves: List[Int],
        cur: (Int, Int)
    ): (Int, Int) = {
        val g = grid(y)(x)
        if g == '#' then return cur
        if g == '.' then {
            needToMoves.map(a => a + 1).foreach { b =>
                grid(y)(b) = 'O'
            }
            grid(rbpos._1)(rbpos._2) = '.'
            return (cur._1, cur._2 + 1)
        }
        moveRight(y, x + 1, x :: needToMoves, cur)
    }

    def moveUp(
        y: Int,
        x: Int,
        needToMoves: List[Int],
        cur: (Int, Int)
    ): (Int, Int) = {
        val g = grid(y)(x)
        if g == '#' then return cur
        if g == '.' then {
            needToMoves.map(a => a - 1).foreach { b =>
                grid(b)(x) = 'O'
            }
            grid(rbpos._1)(rbpos._2) = '.'
            return (cur._1 - 1, cur._2)
        }
        moveUp(y - 1, x, y :: needToMoves, cur)
    }

    def moveDown(
        y: Int,
        x: Int,
        needToMoves: List[Int],
        cur: (Int, Int)
    ): (Int, Int) = {
        val g = grid(y)(x)
        if g == '#' then return cur
        if g == '.' then {
            needToMoves.map(a => a + 1).foreach { b =>
                grid(b)(x) = 'O'
            }
            grid(rbpos._1)(rbpos._2) = '.'
            return (cur._1 + 1, cur._2)
        }
        moveDown(y + 1, x, y :: needToMoves, cur)
    }
    com match {
        case '^' => moveUp(rbpos._1 - 1, rbpos._2, List.empty, rbpos)
        case 'v' => moveDown(rbpos._1 + 1, rbpos._2, List.empty, rbpos)
        case '<' => moveLeft(rbpos._1, rbpos._2 - 1, List.empty, rbpos)
        case '>' => moveRight(rbpos._1, rbpos._2 + 1, List.empty, rbpos)
    }
}

def printGrid(com: Char): Unit = {
    println(s"Move $com : ")
    for y <- grid.indices do {
        println(grid(y).mkString(""))
    }
}

@main def part1(): Unit = {
    val istest = false
    val (commands, robot) = loadData(istest)
    val lastrobot = commands.foldLeft(robot) { (st, c) =>
        val v = robotOper(c, st)
        grid(v._1)(v._2) = '@'
        if istest then printGrid(c)
        v
    }
    // cal
    var sum = 0L
    for y <- grid.indices do {
        for x <- grid(y).indices do {
            if grid(y)(x) == 'O' then {
                sum += y * 100 + x
            }
        }
    }
    println(sum)
}
