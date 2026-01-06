package day17

var A = 0L
var B = 0L
var C = 0L

var outputs = Vector.empty[Long]
var curInstructionPoint = -1L

case class Operand(v: Long) {
    def value: Long = v match {
        case 0 | 1 | 2 | 3 => v
        case 4             => A
        case 5             => B
        case 6             => C
        case _             => throw Exception(s"NG operand $v")
    }
    def showType: String = v match {
        case 0 | 1 | 2 | 3 => "literal"
        case _             => "register"
    }
}

def exOpCode(opcode: Int, operand: Operand): Unit =
    opcode match {
        // A = A >> operand
        case 0 => A = A >> operand.value
        case 1 => B = B ^ operand.v
        case 2 => B = operand.value % 8
        case 3 =>
            if A == 0 then ()
            else {
                curInstructionPoint = operand.v
            }
        case 4 => B = B ^ C
        case 5 =>
            outputs :+= operand.value % 8
            println(s"${outputs.mkString(",")}")
        case 6 => B = A >> operand.value
        case _ => C = A >> operand.value
    }
    println(
      s"status registers : $opcode => $operand (${operand.value}) ===> ${A}, ${B}, ${C}"
    )

def init(): Unit = {
    A = 0L
    B = 0L
    C = 0L
    outputs = Vector.empty[Long]
}

def parse(f: String): Array[Int] = {
    var res = Array.empty[Int]
    scala.util.Using.resource(io.Source.fromFile(f)) { br =>
        val ls = br.getLines
        var status = 0
        for l <- ls do {
            if l == "" then status = 3
            else {
                status match {
                    case 0 => A = l.split(": ")(1).toLong; status += 1
                    case 1 => B = l.split(": ")(1).toLong; status += 1
                    case 2 => C = l.split(": ")(1).toLong; status += 1
                    case 3 => res = l.split(": ")(1).split(",").map(_.toInt)
                }
            }
        }
    }
    res
}

def loop(cur: Int, prgs: Array[Int]): Unit = {
    if cur >= prgs.length then return
    val (a, b) = prgs(cur) -> prgs(cur + 1)
    exOpCode(a, Operand(b))

    if curInstructionPoint >= 0 then
        val gg = curInstructionPoint.toInt
        curInstructionPoint = -1L
        loop(gg, prgs)
    else loop(cur + 2, prgs)
}

@main def part1(): Unit = {
    val isTest = true
    val f =
        if isTest then "./src/main/scala/day17/test.txt"
        else "./src/main/scala/day17/input.txt"

    init()
    val prgs = parse(f)
    loop(0, prgs)
}
