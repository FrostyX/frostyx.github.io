---
layout: post
title: Light - when xbacklight doesn't work
lang: en
categories: fedora
---

Do you have any issues with controlling backlight on your laptop? Try `light`!

I've recently upgraded my laptop from F24 to F26, checked new Gnome features, killed it and switched to [Qtile](http://www.qtile.org/) like I always do. Everything worked, so I moved to another things. Later that day I've put my laptop to my nightstand and went to bed. After a while of scrolling down the facebook page I decided to sleep, repeatedly pressed the function button to turn the backlight off, but nothing happened. WTF? Maybe I haven't committed my key bindings with `xbacklight`, so they got lost during the reinstall? Nah, they are here. Well maybe I can just restart the Qtile session. Nah, still doesn't work ... It took only a little while for me to ... get off the bed, take my laptop and while cursing, sit back to the desk.


Long story short, I figured out, that `xbacklight` was the problem.

    [jkadlcik@chromie ~]$ xbacklight
    No outputs have backlight property

Never encounter this error before so I googled it. From results you might learn that [it is completely normal](https://askubuntu.com/questions/715306/xbacklight-no-outputs-have-backlight-property-no-sys-class-backlight-folder) and you *just* need to symlink something with cryptic name in `/sys/devices` and add some lines to `/etc/X11/xorg.conf`. Eh, I don't want to do that? Besides, I don't have a `xorg.conf` for like half a decade. Also you can find an opened [bug report](https://bugzilla.redhat.com/show_bug.cgi?id=1354662) from 2016, so waiting for fix might take a while.

Then I finally found a [blog post](https://cialu.net/brightness-control-not-work-i3wm/) describing solution that I liked most. It suggest using a handy little tool called [light](http://haikarainen.github.io/light/) as a `xbacklight` alternative. It worked like a magic!

## Installation

The only problem was, that light has not been packaged for Fedora yet. Since I was so happy about the tool, I decided to do my part and package it. Now you can easily install it from Copr by

    dnf copr enable frostyx/light
    dnf install light

There is also a pending [package review](https://bugzilla.redhat.com/show_bug.cgi?id=1481416) so you might be able to install it directly from Fedora repositories soon.

## Usage

<pre class="prettyprint">
# Increasing brightness
xbacklight -inc 10
light -A 10

# Decreasing brightness
xbacklight -dec 10
light -U 10
</pre>
