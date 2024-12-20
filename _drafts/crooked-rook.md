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

One of my goals for this project was to learn Gleam, which is a new addition to
the BEAM family of languages, preceeded by Erlang and Elixir. The main purpose
of these languages is to be used for building massively distributed,
high-availability systems. So I will be the first one to admit that this project
doesn't exactly fit the use-case. Who knows, maybe I plan to build some
distributed system in the future and use this project to learn the languages.

The BEAM is a virtual machine for running Erlang bytecode in the same sense
that JVM is a virtual machine for Java, and .NET is a ~virtual machine~ platform
for C#. And just as Java, Clojure and Scala compile to the JVM bytecode, C#,
Visual Basic, and F# compile to the .NET bytecode, Erlang, Elixir, and Gleam
compile to the BEAM bytecode. Allowing us to share code accross languages.

The main part of this project will be written in Gleam but we will use Elixir
interop for some peripherals. Starting with one of them right now.

To control Stockfish we can use Elixir ports, which is the best interface for
interacting with STDIN-based programs that I've ever seen.

```elixir
defmodule Stockfish do
  def new_game do
    port = Port.open({:spawn, "stockfish"}, [:binary])
    Port.command(port, "uci\n")
    Port.command(port, "isready\n")
    Port.command(port, "ucinewgame\n")
    port
  end
end
```

We can start our game this easily. At the, we are returning the port, so we can
pass it to other functions. To implement a `move` funciton for example.

```elixir
defmodule Stockfish do
  ...

  def move(game, position, history) do
    moves =
      history
      |> Enum.concat([position])
      |> Enum.join(" ")
    Port.command(game, "position startpos moves #{moves}\n")
  end
end
```

You wouldn't believe how easy it is to use this from Gleam through
externals. Since Gleam is statically typed, we need to tell it the shape of our
Elixir functions.

```
import gleam/erlang/port.{type Port}

@external(erlang, "Elixir.Stockfish", "new_game")
fn new_game() -> Port

@external(erlang, "Elixir.Stockfish", "move")
fn move(game: Port, position: String, history: List(String)) -> Nil
```

For illustrative purposes, we are going to avoid the domain specific type
masturbation and stick with strings and lists. In the actual implementation,
we'll likely want to avoid exposing the `Port` directly, and create custom types
for `Position` and `History`.

TODO position is not the ideal name. It would be better to use move but thats
the name of our function.

Now we can use them in Gleam.

```
TODO better code with pipes
let game = Game(new_game(), [], white)
move(game.port, position, game.history)
```

## Morse code

There were available several packages for encoding and decoding Morse code but I
decided to write my own called Morsey. I don't expect any rapid development of
the Morse code alphabet, causing this reinvention of the wheel to be the final
blow to my personal life, putting me on a hamster wheel of perpetual maintenance
of my Open Source software. And look, we already got a star from the one and
only Hayleigh Thompson.

```gleam
import gleam/io
import morsey

let text = "Hello world!"
case morsey.encode(text) {
  Ok(symbols) ->
    io.println("Morse code for " <> text <> " is " <> morsey.to_string(symbols))
  Error(morsey.InvalidCharacter(char)) ->
    io.println_error("Invalid character: " <> char)
}

// And the output will be:
// .... . .-.. .-.. --- / .-- --- .-. .-.. -.. -.-.--
```

We can see several Gleam features in this example. It doesn't have exceptions
but works with errors as values. It also leans heavily towards pattern
matching. There isn't if-else statement in the language. The pattern matching is
also exhaustive, otherwise I would definitelly forget to handle the error
case. I love all of these features. The one I quite dislike is that for the sake
of simplicity, Gleam doesn't support string formatting.


## Hardware

TODO

## Websockets

TODO


https://github.com/magmax/python-inquirer
https://github.com/buttplugio/buttplug-py
https://pypi.org/project/stockfish/
https://github.com/morse-talk/morse-talk
https://www.youtube.com/watch?v=iSMpTmibeDw
https://lichess.org/api
https://en.wikipedia.org/wiki/Common_Intermediate_Language
https://tour.gleam.run/advanced-features/externals/
https://github.com/hayleigh-dot-dev
