(* terminology:
 *  - cell  : can be empty, or have value 1-9
 *  - row   : the row of three cells
 *  - square: three rows, total of nine cells
 *  - board : nine squares, 3 x 3
 *
 *  - field : specialization of a generic square with cells
 *  - board : specialization of a generic square with fields?
 *)

signature SUDOKU_TYPES =
sig
    (* datatype value = One | Two | Three | Four | Five | Six | Seven | Eight | Nine *)
    (* datatype cell = Empty | Val of value *)
    type value
    type cell
    type board

    val to_value : string -> cell
    val to_str   : cell -> string

    exception UnsupportedValue of string
end

structure SudokuTypes : SUDOKU_TYPES =
struct

datatype value = One | Two | Three | Four | Five | Six | Seven | Eight | Nine
datatype cell = Empty | Val of value
type board = cell list list

exception UnsupportedValue of string

fun to_value "1" = Val One
  | to_value "2" = Val Two
  | to_value "3" = Val Three
  | to_value "4" = Val Four
  | to_value "5" = Val Five
  | to_value "6" = Val Six
  | to_value "7" = Val Seven
  | to_value "8" = Val Eight
  | to_value "9" = Val Nine
  | to_value ("x" | "-" | ".") = Empty
  | to_value x = raise UnsupportedValue x

fun to_str (Val One)   = "1"
  | to_str (Val Two)   = "2"
  | to_str (Val Three) = "3"
  | to_str (Val Four)  = "4"
  | to_str (Val Five)  = "5"
  | to_str (Val Six)   = "6"
  | to_str (Val Seven) = "7"
  | to_str (Val Eight) = "8"
  | to_str (Val Nine)  = "9"
  | to_str Empty       = "-"

end
