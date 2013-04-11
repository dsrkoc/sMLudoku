sMLudoku
========

Sudoku solver written in Standard ML.

### On the Quality and Efficiency of Written Code

Note that this solver is by no means efficient, nor optimised. Rather, I made
it as an exercise in learning SML. Furthermore, I didn't try to implement any
existing algorithm, but wrote it in the moment of inspiration. This may be the
reason behind the solver's sluggish performance.

Since this is the product of the learning process, the code itself is probably
not quite idiomatic SML, nor is it written in the most suitable way for such a
problem.

How to Run
----------

sMLudoku accepts puzzles from a file, or from the standard input. One can solve
the puzzle using the Standard ML of New Jersey's REPL like this:

    $ sml
    Standard ML of New Jersey v110.75 [built: Sun Jan 13 00:27:10 2013]
    - CM.make "sMLudoku.cm";
    [autoloading]
    ...
    [New bindings added.]
    val it = true : bool
    -
    - (* Run.fromStdIn (); (* loads a puzzle from the standard input *) *)
    - Run.fromFile "sudoku-puzzle.txt"; (* loads a puzzle from a file *)
    ==> total time: 3346ms
    ==> number of solutions: 1
        solution:

    | 1 2 6 | 3 9 5 | 7 8 4 |
    | 3 5 9 | 8 4 7 | 1 6 2 |
    | 8 7 4 | 6 2 1 | 9 5 3 |

    | 9 8 5 | 4 1 6 | 2 3 7 |
    | 6 3 1 | 9 7 2 | 8 4 5 |
    | 2 4 7 | 5 3 8 | 6 9 1 |

    | 7 6 3 | 1 8 4 | 5 2 9 |
    | 4 1 8 | 2 5 9 | 3 7 6 |
    | 5 9 2 | 7 6 3 | 4 1 8 |

    val it = () : unit

### Input File Format

When supplying the puzzle as a file, *sMLudoku* expects the file to be formatted
in a certain way. Here are the rules:

* each cell is separated by one or more spaces
* each row (nine cells) is in its own line, making a total of nine rows/lines
* empty cell can be written as `.`, or `-`

A file representing unsolved sudoku puzzle may look like this:

    1 2 .  3 . .  . . 4
    3 5 .  . . .  1 . .
    . . 4  . . .  . . .
    . . 5  4 . .  2 . .
    6 . .  . 7 .  . . .
    . . .  . . 8  . 9 .
    . . 3  1 . .  5 . .
    . . .  . . 9  . 7 .
    . . .  . 6 .  . . 8

