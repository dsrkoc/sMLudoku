(* Solves the sudoku *)

(* use "sudoku-types.sml"; *)

signature SUDOKU_SOLVER =
sig
    type cell
    type board
    exception DimensionError of int
    val solutions : board -> board list
end

structure SudokuSolver : SUDOKU_SOLVER =
struct

exception DimensionError of int

datatype value = datatype SudokuTypes.value
datatype cell  = datatype SudokuTypes.cell
type board = SudokuTypes.board

(* returns n if n in interval [0, 8], else raises DimensionError
   'a -> 'a *)
fun chkDim n = if n >= 0 andalso n < 9 then n else raise DimensionError n

(* returns sublist of xs, dropping first i elements, and taking first j elements
   of the remaining list
   'a list -> i -> j -> 'a list *)
fun sublist xs i j = List.take (List.drop (xs, i), j)

(* returns board's element on the given coordinates (x, y)
   board -> int -> int -> elem *)
fun getElem (board, x, y) = List.nth (List.nth (board, y), x)

(* returns a board's row, y being the row number (0-8)
   board -> int -> 'a list *)
fun getRow board y = List.nth (board, chkDim y)

(* returns a board's column, x being the column number (0-8)
   board -> 'a -> 'a list *)
fun getCol board x = List.foldr (fn (xs, acc) => List.nth (xs, chkDim x) :: acc) nil board

(* returns the sudoku square, i being square's ordinal number (0-8)
   board -> int -> 'a list *)
fun getSqr board i =
    let val x' = (chkDim i) mod 3
        val x0 = x' * 3 (* x coord of the first value *)
        val y' = i div 3
        val y0 = y' * 3 (* y coord of the first value *)
        val rows = sublist board y0 3
        val cmap = List.concat o (List.map (fn row => sublist row x0 3))
    in cmap rows
    end

(* converts coordinates to square's ordinal number
   int * int -> int *)
fun sqrOrd (x, y) =
    let val x' = x div 3
        val y' = y div 3
    in x' + 2 * y' + y' end

(* returns a new board with `e` placed instead of element (x, y)
   board -> int -> int -> element -> board *)
fun updated board x y e =
    (* We need two very similar functions, one to iterate over
       lists of lists (board), one to iterate over board's inner
       lists. The parameter `f` is added to abstract away the
       differences between the two functions, so the function
       `upd` can be used in both cases. *)
    let fun upd (xs, i, f) =
            if i = 0
            then f (hd xs) :: tl xs
            else hd xs :: upd (tl xs, i - 1, f)
    in upd (board, y, fn ys => upd (ys, x, fn _ => e))
    end

val elems = [Val One, Val Two, Val Three, Val Four, Val Five, Val Six, Val Seven, Val Eight, Val Nine]

(* type node = value list *)

(* returns the next pair of coordinates, cycles in the range 0..8;
   e.g. (3,0) => (4,0)
        (8,0) => (0,1)
        (4,1) => (5,1)
        (8,8) => (0,0)
   int * int -> int * int *)
fun next (x, y) =
    let val x' = (x + 1) mod 9
        val y' = if x' = 0 then (y + 1) mod 9 else y
    in (x', y') end

(* returns the list of elements that are valid for given coordinates and the board
   board * int * int -> elem list *)
fun findElems (board, x, y) =
    let fun notEq a b = a <> b
        fun newElem e =
            let val notEqAll = List.all (notEq e)
            in
                notEqAll (getRow board y) andalso
                notEqAll (getCol board x) andalso
                notEqAll (getSqr board (sqrOrd (x, y)))
            end
    in List.filter newElem elems
    end

(* should return `board list` with all the boards that are properly filled
   board * int * int -> board list *)

fun solutions board =
    let fun lastElem (8, 8) = true
          | lastElem _ = false
        fun loop (board, x, y) =
            let val e = getElem (board, x, y)
                val (x', y') = next (x, y)
                val updBoard = updated board x y
                fun proc (e', acc) = loop (updBoard e', x', y') @ acc
            in case e
                of Empty => List.foldl proc [] (findElems (board, x, y))
                 | Val _ => if lastElem (x, y)
                            then [board]
                            else loop (board, x', y')
            end
    in loop (board, 0, 0)
    end

end

(* algoritam:
   trebali bi za svaki element naći listu mogućih vrijednosti (onih koje se ne nalaze
   u zadanom retku, stupcu i kvadratu igrače ploče) i onda krenuti na sljedeći element
   i to za svaku od nađenih vrijednosti. Taj sljedeći element dobije igraču ploču koja
   već sadrži i vrijednost prethodnog koraka (elementa). Ako za neki element ne postoji
   ispravna vrijednost ta grana ne ide dalje.

   Očito se radi o nekakvoj stablastoj strukturi i to na neki način lijenoj jer bi
   inače mogla prilično narasti? Kako onda znati koje je rješenje pravo?

   Ako dođemo do kraja ploče to je očito pravo rješenje, tada bi mogli vratiti npr.
   SOME board. U slučaju da do kraja ne dođemo možemo vratiti NONE - i što smo time
   dobili? *)

(* how does the board look like?

   e.g.

   [[4 8 -   - 5 6   - - 2],
    [- - 6   - 2 -   5 - -],
    [5 7 -   9 - -   3 4 6],

    [- 4 -   - - -   8 - -],
    [8 - -   - 9 -   - - 4],
    [- - 5   - - -   - 7 -],

    [7 2 4   - - 1   - 6 3],
    [- - 9   - 4 -   1 - -],
    [1 - -   7 6 -   - 2 5]]

*)
