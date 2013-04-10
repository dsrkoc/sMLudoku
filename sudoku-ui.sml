(*
 * Module for user interaction.
 *
 * Reads sequence of characters from the standard input
 * that describe the initial setup of the board.
 *
 * Writes the solution to the standard output.
 *)

signature SUDOKU_INPUT =
sig
    type cell
    type board

    type boardRaw (* the raw representation of the sudoku board in its initial state *)

    exception InvalidInput of string (* thrown in case of invalid input *)
    
    (* reads 3 times 3 lines from the standard input,
       returns a sudoku board in its raw representation *)
    val read3x3Lines : unit -> string (* list *) list (* NOTE: or should it be e.g. TextIO.instream -> boardRaw ? *)

    val readFromFile : string -> string list (* NOTE: this should be transformed into string list list (boardRaw) *)

    val prettyprint  : board list -> unit
end

structure SudokuInput :(*>*) SUDOKU_INPUT = (* transparent ascription for now, to be changed to opaque *)
struct

datatype value = datatype SudokuTypes.value (* ok with `type value = SudokuTypes.value` too *)
datatype cell  = datatype SudokuTypes.cell
type board = SudokuTypes.board

type boardRaw = string list list

exception InvalidInput of string

(* reads a line from input stream and discards non-printable chars (e.g. "\n")
   instream -> string option *)
fun readLine strIn = Option.mapPartial String.fromString (TextIO.inputLine strIn)
                                       
(* reads a line from standard input *)
fun readLineStdIn () = readLine TextIO.stdIn
                                
(* reads as much lines from standard input as there are units in a list argument
   unit list -> string option list *)
val mapRead = List.map readLineStdIn

val feed3Lines = [(), (), ()]
                     
(* reads three lines from the standard input
   unit -> string option list *)
fun readThreeLines () = mapRead feed3Lines

(* pulls string from the option, raises exception if NONE found
   string option list -> string list *)
fun unbox xs = List.map (fn s =>
                            case s of
                                NONE => raise InvalidInput "Empty line"
                              | SOME ss => ss)
                        xs

(* prints a row separator and returns v
   'a -> 'a *)
fun printAndReturn v = v before print "------------------------\n"
                           
(* reads three times three lines from the standard input
   unit -> string list list, zapravo ...
   unit -> string list (concat added) *)
fun read3x3Lines () = List.concat (List.map (unbox o readThreeLines o printAndReturn) feed3Lines)

(* reads content of a given file, the file should contain the sudoku board
   in its starting state and raw form;
   string -> string list list *)
fun readFromFile fname =
    let fun readRaw fstream =
            case TextIO.inputLine fstream of
                NONE   => []
              | SOME s => String.fromString s :: readRaw fstream
        val read = unbox o readRaw
    in read (TextIO.openIn fname) end

(* outputs the number of boards and the content of the first board in the list
   board list -> unit *)
fun prettyprint boards =
    let val _ = print ("==> number of solutions: " ^ Int.toString (List.length boards) ^ "\n")
        val _ = print  "    first solution: \n\n"
        val p = print o SudokuTypes.to_str o List.nth
        fun pp (l, i) = (print " " ; p (l, i))
        fun print3 xs = (pp (xs, 0) ; pp (xs, 1) ; pp (xs, 2) ; print " |" ; List.drop (xs, 3))
        val printRow = print3 o print3 o print3
        val pr = printRow o List.nth
        fun ppr (l, i) = (print "|" ; pr (l, i) ; print "\n")
        fun print3Rows xs = (ppr (xs, 0) ; ppr (xs, 1) ; ppr (xs, 2) ; print "\n" ; List.drop (xs, 3))
        val printAll = print3Rows o print3Rows o print3Rows
    (* in List.app (fn row => printRow row ; print "\n") b *)
    in ignore ((printAll o hd) boards)
    end

end
