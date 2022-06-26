# Ruby Tic-Tac-Toe

Tic-Tac-Toe project from [Odin Project](https://www.theodinproject.com/lessons/ruby-tic-tac-toe)

[![Run on Repl.it](https://repl.it/badge/github/KTohara/ruby_tictactoe)](https://replit.com/@KenTohara/rubytictactoe)

## Features

* Dynamic grid size - Goes up to 10x10
* Muliple player support - Up to 8 players
* Stats display - shows a simple display with a win tally
* Multiple player types:
  - Human
  - Computer - will choose to block or win
  - Super Computer - will always win or draw. Available only on 3x3 grid due to optimization constraints

## Thoughts

Who knew Tic-Tac-Toe AI could be so complicated!

I started this project with a simple AI, which only could choose a move whether it should take a winning move, a blocking move, or a random move.

Afterwards, I tried implementing the Super CPU AI with a data structure. It works, but it turns out that there's a whole lot of possible board combinations. The algorithm simply takes way too long on anything that's bigger than a 3x3 grid.

Hopefully I can grasp Minimax, Negamax, and Alpha Beta Pruning at some point to fully optimize this.