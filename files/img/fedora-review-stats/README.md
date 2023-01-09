# Generate the graph using

Run the [fedora-review-justification.py][script] to generate the
`fedora-review-stats.dat` data file.

Generate the graph using:

```
~/.local/bin/termgraph fedora-review-stats.dat --color {blue,yellow,black} --stacked --format "{:.0f}" --width 50
```


[script]: https://gist.github.com/FrostyX/fc677328ef9b26f06a89839fe4adb5cb
