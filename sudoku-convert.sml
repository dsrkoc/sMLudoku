(* Converts between raw board type (list of strings) and types that
 * solver works with *)

(* use "sudoku-types.sml"; *)

signature SUDOKU_CONV =
sig
    type cell
    type board
    val toCells : string list -> board
end

structure SudokuConv : SUDOKU_CONV =
struct

datatype value = datatype SudokuTypes.value
datatype cell  = datatype SudokuTypes.cell
type board = SudokuTypes.board

(* converts a string to a list of tokens;
   e.g. "1 - 2" -> ["1", "-", "2"]
   string -> string list *)
val str2tokens = String.tokens (fn c => c = #" ")

(* converts a list of string to a list of tokens;
   e.g. strsToTokens ["1 - 2", "2 3 4"] -> [["1", "-", "2"], ["2", "3", "4"]]
   string list -> string list list *)
val strsToTokens = List.map str2tokens

(* converts a list of tokens to a list of cells
   e.g. ["1", "2", "-"] -> [Val One, Val Two, Empty]
   string list -> cell list *)
val tokens2cells = List.map SudokuTypes.to_value

(* converts a list of strings of tokens to a list of list of cells
 * e.g. ["1 2", "- 3"] -> [[Val One, Val Two], [Empty, Val Three]]
 *
 * string list -> cell list list *)
fun toCells strs = List.map tokens2cells (strsToTokens strs)

end
