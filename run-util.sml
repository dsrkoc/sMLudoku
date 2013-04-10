signature RUN_UTIL =
sig
  val fromFile  : string -> unit
  val fromStdIn : unit -> unit
end

structure Run :> RUN_UTIL =
struct

fun solve s =
    let val start = Timer.startRealTimer ()
        val res   = SudokuSolver.solutions s
    in (Timer.checkRealTimer start, res) end

fun printSolutions (time, solutions) =
    let val _ = print ("==> total time: " ^ (LargeInt.toString o Time.toMilliseconds) time ^ "ms\n")
    in SudokuInput.prettyprint solutions end

val solveAndPrint = printSolutions o solve o SudokuConv.toCells

val fromFile  = solveAndPrint o SudokuInput.readFromFile
val fromStdIn = solveAndPrint o SudokuInput.read3x3Lines

end
