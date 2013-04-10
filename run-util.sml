signature RUN_UTIL =
sig
  val fromFile  : string -> unit
  val fromStdIn : unit -> unit
end

structure Run :> RUN_UTIL =
struct

val fromFile  = SudokuInput.prettyprint o SudokuSolver.solutions o SudokuConv.toCells o SudokuInput.readFromFile
val fromStdIn = SudokuInput.prettyprint o SudokuSolver.solutions o SudokuConv.toCells o SudokuInput.read3x3Lines

end
