---
layout: post
title: Crooked Rook
lang: en
tags: chess morse gleam elixir
---

In the Lex Fridman Podcast episode #327, Levy Rozman (aka GothamChess) discussed
a scandal alleging chess grandmaster Hans Niemann of cheating during a
tournament through the use of a remotely controlled device inserted
into his backside, receiving the next best move encoded in Morse code
vibrations. And because I am obviously twelve years old, I though it
would be really funny to implement this. By the way, XY is likely as immature as
me, because he beat me to it.

Disclaimer:

I am not endorsing cheating in chess or any other sport, I don't know if the
allegations were true or not and I don't care. I don't know any of the people
involved, and I don't even play chess. This project is just for shits and
giggles, not so that y'all to experience more pleasure during chess tournaments.


## Demo

TODO


## Scope

At our disposal, we have several chess engines capable of beating any human. We
also have a large offering of intimate hardware built on top of open
standards. The most straightforward encoding method is the Morse code, even
though not the most effective in this situation. Chess boards squares go
from a1 to h8, which leaves us with two-thirds of the alpabet unused, making the
code for every character n-times longer than neccessary. However, creating an
optimized encoding is outside of the scope of this project.

Playing one side of the chess board will be a two-man job. The agent in the
field, receiving inteligence through his anal cavity, and the operator behind
the computer monitor, querying a chess engine through the interface we will
create.

Joking aside, I could probably crank out a working solution in Python under an
hour, just by glueing inquirer, stockfish, morse-talk, and buttplug-py
together. But where would be the fun in that. That's why I am going to use this
project to learn a new programming language.


## Chess engines

There are several chess engines to choose from, such as Stockfish, AlphaZero,
Lc0, Shredder, etc. Some of them giving us an option to either run them locally
or spawning an instance through lichess.org.

I randomly picked Stockfish out of the hat because it is an open-source project,
and decided to run it locally. Thankfully, it is packaged in Fedora.

The chess grandmasters average around 2600 Elo rating, and according to Gary
Linscott, Stockfish performs at 3600 Elo. So there is no worry it won't beat our
opponents.

Chess engines are services running in a background (in the same sense as Unix
daemons). They don't have any graphical interfaces or CLI tools for interacting
with them. At least not tools in the conventional sense. Instead, third-party
programs can communicate with chess engines through the Universal Chess
Interface (UCI).

```
$ stockfish
...

uci
id name Stockfish 17
id author the Stockfish developers (see AUTHORS file)
...
uciok

isready
readyok

isready
readyok

ucinewgame

position startpos moves a2a3 h7h6 b2c3

go depth 15
...
bestmove e2e4 ponder c7c5
```

As you can see, Stockfish provides a painfully bad REPL and UCI arms as with a
set of commands that we can use. There is no tab completion, no help, no command
history, no syntax highlighting, no prompt to distinguish between commands and
their input. For easier understading, I rendered the inputs red and their
outputs blue, but in the terminal they are all the same color.

In this session, we started the game, white moved from `a2` to `a3`, black moved
from `h7` to `h6`, then again white moved from `b2` to `c3`. Stockfish then
recommends black to move from `c7` to `c5` and expect white to retaliate with
`c7` to `c5`.


## Gleam, Elixir, and the BEAM

TODO

## Morse code

TODO

## Hardware

TODO


https://github.com/magmax/python-inquirer
https://github.com/buttplugio/buttplug-py
https://pypi.org/project/stockfish/
https://github.com/morse-talk/morse-talk
https://www.youtube.com/watch?v=iSMpTmibeDw
https://lichess.org/api
