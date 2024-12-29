---
layout: post
title: Cheating in chess via remotely controlled toys
lang: en
tags: chess morse gleam elixir
---

In the Lex Fridman Podcast [episode #327][episode-327], Levy Rozman (aka
[GothamChess][GothamChess]) explained a scandal, alleging chess grandmaster Hans
Niemann of cheating at a tournament. Supposedly it was done through a remotely
controlled device inserted into his backside, allowing him to receive the next
best move encoded in Morse code vibrations. And because I am obviously twelve
years old, I thought it would be really funny to implement this. By the way,
[Ron Sijm][RonSijm] is likely as immature as me, because he
[beat me to it][buttfish].

Disclaimer: I am not endorsing cheating in chess or any other sport, I don't
know if the allegations were true or not, and to be honest, I don't care. I don't know any of
the people involved, and I don't even play chess. This project is just for shits
and giggles, not so that y'all can experience more pleasure during chess
tournaments.


## Two-minute demo

This post is too long and you will probably not read it. So here is a fun demo
of the final product.

<div class="text-center img-row row">
<iframe width="784" height="441" src="https://www.youtube.com/embed/HAxBOoBoVTM?si=iuqvAYfn11vl1ffi" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
</div>


## Scope of the project

At our disposal, we have several chess engines capable of beating any human. We
also have a large offering of intimate hardware built on top of open
standards. The most straightforward way to encode chess moves is the Morse code,
even though it is not the most effective choice in this situation. Squares on
chess boards go from `a1` to `h8`, which leaves us with two-thirds of the
alphabet unused, making the code for every character n-times (I am bad at math)
longer than necessary. However, creating an optimized encoding is outside
the scope of this project.

Playing one side of the chess board will be a two-man job. The agent in the
field, receiving intelligence through his anal cavity, and the operator behind
the computer monitor, querying a chess engine through the interface we will
create.

Joking aside, I could probably crank out a working solution in Python under an
hour just by gluing [inquirer][inquirer], [stockfish][python-stockfish],
[morse-talk][morse-talk], and [buttplug-py][buttplugpy] together. But where
would be the fun in that. That's why I am going to learn a new programming
language on this project.


## Chess engines

There are several chess engines to choose from, such as [Stockfish][stockfish],
[AlphaZero][alphazero], [Lc0][lc0], [Shredder][shredder], etc. Some of them
giving us an option to run them locally or spawning an instance
[through lichess.org][lichess-api]. I randomly picked Stockfish out of the hat
because it is an open-source project, and it is easy to run locally.

Chess grandmasters average around 2600 Elo rating, and according to Gary
Linscott, [Stockfish performs at 3600 Elo][stockfish-elo]. Don't worry that it
won't beat our opponents.

To keep things simple, we can say that chess engines are services running in a
background (and liken them to Unix daemons). They don't have any graphical
interfaces or CLI tools for interacting with them. At least not tools in the
conventional sense. Instead, third-party programs can communicate with chess
engines through the [Universal Chess Interface][uci] (UCI).

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
set of usable commands. There is no tab completion, no help, no command
history, no syntax highlighting, no prompt to distinguish between commands and
their output. For easier understanding, I rendered the inputs red and their
outputs blue, but in the terminal they are all the same color.

In this session, we started the game, white moved from `a2` to `a3`, black moved
from `h7` to `h6`, then again white moved from `b2` to `c3`. Stockfish then
recommends black to move from `c7` to `c5` and expect white to retaliate with
`c7` to `c5`.


## Gleam, Elixir, and the BEAM

One of my goals for this project was to learn [Gleam][gleam], which is a new
addition to the [BEAM family of languages][beam-languages], preceded by
[Erlang][erlang] and [Elixir][elixir]. The main purpose of these languages is to
be used for building massively distributed, high-availability systems. So I will
be the first one to admit that this project doesn't exactly fit the
use-case. Who knows, maybe I plan to build some distributed system in the future
and treat this project as a means to learn the languages.

The [BEAM][beam] is a virtual machine for running Erlang bytecode in the same sense
that JVM is a virtual machine for Java, and .NET is a ~~virtual machine~~
platform for C#. And just as Java, Clojure and Scala compile to the JVM
bytecode, C#, Visual Basic, and F# compile to the [.NET bytecode][cil], Erlang,
Elixir, and Gleam compile to the BEAM bytecode. Allowing us to share code
across the related languages.

The main part of this project will be written in Gleam, but we will use Elixir
interop for some peripherals. Starting with one of them right now. To control
Stockfish we can use [Elixir ports][elixir-ports], which is the best abstraction
for interacting with STDIN-based programs that I've ever seen.

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

At the, we are returning the port, so we can pass it to other functions. To
implement a `move` function for example.

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
[externals][gleam-externals]. Since Gleam is statically typed, we need to tell
the compiler the shape of our Elixir functions, but that's all.

```gleam
import gleam/erlang/port.{type Port}

@external(erlang, "Elixir.Stockfish", "new_game")
fn new_game() -> Port

@external(erlang, "Elixir.Stockfish", "move")
fn move(game: Port, position: String, history: List(String)) -> Nil
```

For illustrative purposes, we are going to avoid the domain specific type
masturbation and stick with lists and strings. In the actual implementation,
we'll likely want to avoid exposing the `Port` directly, and create custom types
for `Position` and `History`.

Now we can use the functions in Gleam.

```gleam
new_game() |> move("a2a3", [])
```

## Morse code

Several packages for encoding and decoding Morse code were available, but I
decided to write my own called [Morsey][morsey]. I don't expect any rapid
development in the Morse code department, causing this reinvention of the wheel
to be the final blow to my personal life that puts me on a hamster wheel of
perpetual maintenance of my Open Source projects. And look, we already got a
star from the one and only [Hayleigh Thompson][hayleigh].

The source code is available in [FrostyX/morsey][morsey] repository and the
usage looks like this.

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
and instead returns errors as values. It leans heavily towards pattern
matching, there is not even an if-else statement in the language. The pattern
matching is exhaustive, otherwise I would definitely forget to handle the
error case. I love all of these features. The one I quite dislike, however, is
that for the sake of simplicity, Gleam doesn't support string formatting.


## Intimate hardware

On paper, hardware should've been the easy part. There is an
[exhaustive list][supported-devices] of manufacturers and devices supported by
the [buttplug.io][buttplugio] project. I randomly picked some device that was
possible to buy in Czech Republic. It paired with my phone within seconds, so I
started celebrating an easy victory, just to waste the rest of the day trying to
pair the device with my computer.

Here is the ten-thousand foot view. A toy communicates with your computer via Bluetooth LE. Some manufacturers
require [pairing before use][pairing], some don't. You don't use the system
Bluetooth manager to connect to the device. Clients like
[buttplug-py][buttplugpy], [buttplug-js][buttplugjs], [etc][buttplug-libraries],
don't control the toy directly, they only communicate with a server like
[intiface-engine][engine] via websockets. The server then does the heavy
lifting. You can run the server like this:

```
$ cargo install intiface-engine
$ ~/.cargo/bin/intiface-engine --websocket-port 12345 --use-bluetooth-le
```


## Websockets

The previous chapter linked officially supported libraries that provide a
high-level interface to control the devices. However, there weren't any for the
BEAM family of languages, so I had to raw-dog the websocket communication. It's
almost embarrassing that in fifteen years of programming, I have never used
websockets, and this was my first exposure.

An example session can look like this
(It only shows messages sent from the client to the server. The responses were
omitted).

```
$ cargo install websocat
$ ~/.cargo/bin/websocat ws://127.0.0.1:12345/
[{"RequestServerInfo": {"ClientName": "Test Client", "MessageVersion": 1, "Id": 1}}]
[{"RequestDeviceList": {"Id": 2}}]
[{"StartScanning": {"Id": 3}}]
[{"VibrateCmd": {"DeviceIndex": 0, "Speeds": [{"Index": 0, "Speed": 500}], "Id": 4}}]
[{"StopDeviceCmd": {"DeviceIndex": 0, "Id": 5}}]
```

I created a Gleam package with high-level interface around this, called
[Bummer][bummer]. Its usage is fairly simple.

```gleam
import bummer

case bummer.connect("ws://127.0.0.1:12345/") {
  Ok(socket) -> {
    io.println("Connected to intiface-engine websocket")
    io.println("Initiating a test sequence")

    bummer.scan(socket, 5000)
    bummer.vibrate(socket, 500)
    bummer.rotate(socket, 500)

    io.println("Test sequence finished")
  }
  Error(_) ->
    "Cannot connect to intiface-engine websocket. Is it running?"
    |> io.println_error
```

The public API is leaking some internals. The users probably don't even want to
know what communication protocol is being used, and it should be treated as an
implementation detail. This calls for more custom types.

Also, websockets are a bi-directional protocol but `bummer` is currently
unidirectional. It was really easy to send messages to the server but due to the
Gleam + Elixir interop, I couldn't figure out how to properly handle messages
from the server. I started running out of time, so this remains unfinished. PRs
are more then welcome.

## Tying it all together

Throughout this blog post, we've seen code snippets for communicating
with Stockfish, converting text to Morse code, and controlling intimate toys
via websockets. The last missing piece is vibrating a Morse code sequence.

```gleam
fn vibrate(socket: bummer.Connection, morse: morsey.Sequence) -> Nil {
  // International Morse Code
  // 1. The length of a dot is one unit.
  // 2. A dash is three units.
  // 3. The space between parts of the same letter is one unit.
  // 4. The space between letters is three units.
  // 5. The space between words is seven units.
  let interval = 200
  case morse {
    [] -> Nil
    [first, ..rest] -> {
      case first {
        morsey.Dot -> bummer.vibrate(socket, interval)
        morsey.Comma -> bummer.vibrate(socket, interval * 3)
        morsey.Space -> sleep(interval * 3)
        morsey.Break -> sleep(interval * 7)
        morsey.Invalid(_) -> Nil
      }
      vibrate(socket, rest)
    }
  }
}
```

All code is available in my [FrostyX/crooked-rook][crooked-rook] repository.


## A room for improvement

This being a fun little project to keep myself busy over the holidays, having no
real use-case, and providing zero value to anyone, it had to be cut short. Codes
for letters in the Morse alphabet are too long. One could come up with much more
effective encoding. Additionally, there is no need to encode the whole move
(e.g. `a2a3`). An experienced chess player can infer the starting position
(`a2`) from the end position (`a3`). These two combined improvements would
result in significantly shorter
messages.

The other limitation is having a human relay between the player and the chess
engine. I am sure there are AI models capable of observing a chess board and
recognizing all the figures and their positions. The whole system could be
autonomous with the exception of the human player.

Sounds like a pt.2 next holiday?


[episode-327]: https://www.youtube.com/watch?v=iSMpTmibeDw&t=8743s
[GothamChess]: https://www.youtube.com/gothamchess
[buttfish]: https://github.com/RonSijm/ButtFish
[RonSijm]: https://github.com/RonSijm
[inquirer]: https://github.com/magmax/python-inquirer
[python-stockfish]: https://pypi.org/project/stockfish/
[morse-talk]: https://github.com/morse-talk/morse-talk
[stockfish]: https://stockfishchess.org/
[alphazero]: https://en.wikipedia.org/wiki/AlphaZero
[lc0]: https://lczero.org/
[shredder]: https://www.shredderchess.com/
[lichess-api]: https://lichess.org/api
[stockfish-elo]: https://youtu.be/CdFLEfRr3Qk?t=70
[uci]: https://en.wikipedia.org/wiki/Universal_Chess_Interface
[gleam]: https://gleam.run/
[beam]: https://en.wikipedia.org/wiki/BEAM_(Erlang_virtual_machine)
[beam-languages]: https://en.wikipedia.org/wiki/BEAM_(Erlang_virtual_machine)#BEAM_Languages
[erlang]: https://www.erlang.org/
[elixir]: https://elixir-lang.org/
[cil]: https://en.wikipedia.org/wiki/Common_Intermediate_Language
[elixir-ports]: https://hexdocs.pm/elixir/Port.html
[gleam-externals]: https://tour.gleam.run/advanced-features/externals/
[morsey]: https://github.com/FrostyX/morsey
[hayleigh]: https://github.com/hayleigh-dot-dev
[supported-devices]: https://iostindex.com/?filter0Availability=Available,DIY&filter1Connection=Digital
[buttplug-libraries]: https://github.com/buttplugio/awesome-buttplug?tab=readme-ov-file#development-and-libraries
[bummer]: https://github.com/FrostyX/bummer
[crooked-rook]: https://github.com/FrostyX/crooked-rook
[buttplugio]: https://buttplug.io/
[buttplugpy]: https://github.com/Siege-Wizard/buttplug-py
[buttplugjs]: https://github.com/buttplugio/buttplug-js
[engine]: https://github.com/intiface/intiface-engine
[spec]: https://docs.buttplug.io/docs/spec/
[supported-dongles]: https://docs.intiface.com/docs/intiface-central/hardware/bluetooth/#what-type-of-bluetooth-dongle-should-i-use
[pairing]: https://faq.docs.buttplug.io/hardware/bluetooth.html#when-should-i-pair-my-device-with-my-operating-system
[pairing-reset]: https://faq.docs.buttplug.io/hardware/satisfyer.html#how-do-i-connect-my-satisfyer-device-to-a-desktop-laptop
[disabling-adapters]: https://unix.stackexchange.com/questions/314373/permanently-disable-built-in-bluetooth-and-use-usb/617215#617215
[libraries]: https://github.com/buttplugio/awesome-buttplug?tab=readme-ov-file#development-and-libraries
[supported-devices]: https://iostindex.com/?filter0Availability=Available,DIY&filter1Connection=Digital
