---
layout: post
title: Cheating in chess via remotely controlled toys
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

This post is too long and you will probably not read it. So here is a fun demo
of the final product.

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

```gleam
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

```gleam
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

On paper, hardware should've been the easy part. There is an exhaustive list of
supported manufacturers and devices supported by the buttplug.io project, so I
randomly picked one that was possible to buy in Czech Republic. It paired with
my phone within seconds, so I started celebrating an easy victory. Just to waste
the rest of the day trying to pair the device with my computer.

Here is the ten-thousand foot view.

A toy communicates with your computer via Bluetooth LE. Some manufacturers
require [pairing before use][pairing], some don't. You don't use the system
Bluetooth manager to connect to the device. Clients like
[buttplug-py][buttplugpy], [buttplug-js][buttplugjs], etc, don't control the toy
directly. They only communicate with a server like [intiface-engine][engine] via
websockets. The server then does the heavy lifting.

You can run the server like this:

```
$ cargo install intiface-engine
$ ~/.cargo/bin/intiface-engine --websocket-port 12345 --use-bluetooth-le
```


## Websockets

In the previous chapter I linked many officially supported client libraries,
providing a high degree of abstraciton. However, there were any for our BEAM
family of languages, so I had to raw-dog the websocket communication. It's
almost embarrasing but after 15 years of programming, I have never used
websockets, so this was my first exposure.

An example session can look like this.
(It only shows messages sent from the client to the server. The responses were
ommitted.)

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
[bummer][bummer]. Its usage is farily simple.

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

It is leaking some internals. The users probably don't even want to know what
communication protocol is being used and it should be treated as an
implementation detail. This calls for more custom types.

Also, websockets is a bi-directional protocol but `bummer` is currently
unidirectional. It was really easy to send messages to the server but due to the
Gleam + Elixir interop, I couldn't figure out how to properly handle messages
from the server. I started running out of time, so this remains unfinished. PRs
are more then welcome.

## Tying it all together

Throughout this blog post, we've seen code snippets showing how to communicate
with Stockfish, how to convert text to Morse code, and how control intimate toys
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

This and all the rest is available in my FrostyX/crooked-rook repository.


## A room for improvement

This being a fun little project to keep myself busy over the holidays, having no
real use-case, and providing zero value to anyone, had to be cut short. Codes
for Morse code letters are too long, one could come up with much more effective
encoding. Additionally, there is no need to encode the whole move
(e.g. `a2a3`). An experienced chess player can infer the starting position from
the end position. These two combined would result in significantly shorter
messages.

The other limitation is having a human relay between the player and the chess
engine. I am sure there are AI models capable of seeing a chess board and
recognising all the figures and their positions. The whole system could be
autonomous with the exception of the human player.

Sounds like a pt.2 next holiday?



https://github.com/magmax/python-inquirer
https://github.com/buttplugio/buttplug-py
https://pypi.org/project/stockfish/
https://github.com/morse-talk/morse-talk
https://www.youtube.com/watch?v=iSMpTmibeDw
https://lichess.org/api
https://en.wikipedia.org/wiki/Common_Intermediate_Language
https://tour.gleam.run/advanced-features/externals/
https://github.com/hayleigh-dot-dev


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
