---
layout: post
title: Software tips for nerds
lang: en
tags: desktop fedora vim vimwiki software
---

This article should rather be called _What software I started using in 2019_ but I just didn't like that title. It is going to be the first post in a yearly series on this topic.

Admittedly, I have unconventional preferences on the user interface of applications, that I use daily. It manifests itself in a strong Vim modal editing addiction, tiling window manager and not having a mouse on my desk. I figured, that this series might be useful for other weirdos like me. Also, it will be fun to look back and see the year by year progression.

<div class="text-center img-row row">
  <a href="/files/img/2019-desktop.png">
    <img src="/files/img/2019-desktop-thumb.png" alt="" />
  </a>
  <p>
    See <a href="https://www.reddit.com/r/unixporn/">/r/unixporn</a> if you are aroused by these kinds of pictures.
  </p>
</div>

My daily driver is Lenovo X1 Carbon, that I use almost exclusively for DevOps tasks. It has only 13" display so I usually go one maximized application per workspace. This is very conveniently achievable by using a tiling window manager, in my case [Qtile][qtile].

Now, what changed in 2019? Quite a lot ...


## Vim for everything

I use Vim for almost a decade now, which is probably the longest I've sticked to some application. During that time, I repeatedly tried to use it as an IDE but inevitably failed each time. Let's remember [eclim][eclim] as my [Java IDE][my-java-ide]. I work almost exclusively on projects written in Python, which can be beautifully done in Vim but because of a gap in my skills, I was reliant on [PyCharm][pycharm]. Thankfully, not anymore.

My biggest issue was misusing tabs instead of buffers and poor navigation within projects. Reality check, do you open one file per tab? This is a common practice in other text editors, but please know that this is not the purpose of tabs in Vim and you should be using buffers instead. Please, give them a chance and read [Buffers, buffers, buffers][buffers].

Regarding project navigation, have you ever tried `shift shift` search in PyCharm or other JetBrains IDE? It's exactly that thing, that you wouldn't even imagine but after using it for the first time, you don't understand how you lived without. What it does is, that [it interactively fuzzy-finds files and tags][shift-shift] (classes, functions, etc) that matches your input, so you can easily open them. In my opinion, this unquestionably defeats any other way of project navigation like using a file manager, [NerdTree][nerdtree], or `find` in the command line.

Fortunately, both of these problems can be solved by [fzf.vim][fzf-vim], which quickly became one of my most favorite Vim plugins. Please read [this section about fzf plugin][fzf-blog].


I am forever grateful to [Ian Langworth][statico] for writing [VIM AFTER 11 YEARS][vim-after-11-years], [EVERYTHING I MISSED IN "VIM AFTER 11 YEARS"][everything-i-missed-in-vim-after-11-years] and [VIM AFTER 15 YEARS][vim-after-15-years] articles. If you are a Vim user, those are an absolute must-read.


## Urxvt

Although I spend a considerable amount of my work time in a terminal, I couldn't care less what terminal emulator I use. The majority of them support the exact same features and in the end, you are just sitting there and typing commands into a black screen.

After migrating from PyCharm to Vim, my time spent in the terminal increased even more. Thinking about it, I use terminal and web browser. That's it. Up until this point, I've been using `gnome-terminal` because it comes preinstalled with Fedora. While it is a perfectly fine piece of software, for me, it's customizability sucks. I just don't want to configure my core tools by clicking in a settings window. It has limitations, it is harder to manage in git, and so on.

Ultimately, the last straw that made me abandon `gnome-terminal` was its inability to use third-party color schemes. Among many others, there is a great project called [base16][base16] which defines palettes of colors for creating beautiful schemes and then provides configurations for countless applications. For most applications, the process is very simple. Put a color scheme file into an expected directory, then edit the config file and specify, which scheme you want to use. Unfortunately, it doesn't work that way for `gnome-terminal`. You need to run a hundred-line bash script and possibly do other shenanigans and hope for the best.

Currently, my terminal emulator of choice is [Urxvt][Urxvt] (aka `rxvt-unicode`). Here comes my sales pitch - Urxvt is an old, ugly-looking application with a horrible user interface. How about that? Joking aside, [it looks terrifying at first sight][urxvt-default-screenshot]. However, it can be easily configured through `~/.Xresources` and with very little effort, it looks as beautiful as the terminal can get.

<div class="text-center img-row row">
  <img src="/files/img/urxvt.png" alt="" />
  <p>Color scripts from <a href="https://github.com/stark/Color-Scripts">stark/Color-Scripts</a></p>
</div>


## Tmux

[Tmux][tmux] is a terminal multiplexer, tmux is a replacement for [GNU Screen][screen], tmux is steroids for your terminal, tmux is the greatest thing since free porn. You. Want. Tmux!

It allows you to:

- horizontally or vertically split the terminal window
- run a command, close the terminal window, and then attach to back to it when needed
- throw your mouse to trash
- add support for tabs, scrolling, searching, and everything that may be missing in lightweight terminal emulators

Recommended read - [Boost Your Productivity In The Terminal With tmux][tmux-how-to]


## Weechat

The IRC protocol supports only plain-text communication. Sharing images, videos or audio can't be done directly, but rather by uploading it _somewhere_ and embedding a link. That being said, there is no reason to not use a terminal client. I've finally migrated from [HexChat][hexchat] (and previously [XChat][xchat]) to [Weechat][weechat].

<div class="text-center img-row row">
  <img src="/files/img/weechat.png" alt="" />
  <p>
    My weechat configuration looks quite chaotic in a small window like this.
	It is optimized for fullscreen.
  </p>
</div>


## Newsboat

RSS is a well-known method for subscribing news feeds from various websites. It appears to be stupidly simple to use and it is the most effective way to keep an eye on interesting articles. So why I haven't been able to use it? My typical pattern was - Why don't I use RSS? Then installing a client, subscribing some feeds, being happy, then forgetting that I have an RSS client. And then going back to step one.

[Newsboat][newsboat] with a panel indicator seems to do the trick for me.

<div class="text-center img-row row">
  <img src="/files/img/newsboat.png" alt="" />
  <p>
    Check out <a href="https://blog.samalik.com/">Adam Šamalík's blog</a>
  </p>
</div>


## Vimwiki

What is your current system of taking notes and managing to-do lists? Or do you even? For the longest time, my approach was to remember everything. Surprisingly enough, it worked fine throughout high school, college and all my previous jobs. However now, as I am growing older and my responsibilities increase, the beloved _"if I don't remember it, it wasn't that important"_ philosophy is just not sufficient anymore. Also, repeatedly excusing myself during a work meeting, that I forgot to do something, was just unprofessional.

Well, where to keep notes and to-do lists? There is a gazillion of tools for desktops, smartphones, and everything. Apparently, they are even still making sketchbooks. Like ... from paper. Who would know? Anyway, I had some criteria.

1. In my team, we have week-long sprints, so I want to track tasks for that period. While I want to write detailed information about them, as well as fragmenting them into sub-tasks, I am not interested in specifying attributes such as explicit deadlines, locations, projects, etc.
2. There may be tasks, that need to be done some specific day, so it would be useful to have also a page for each day.
3. No mouse! Tools that require me to click on buttons to create tasks, or dragging them with a mouse to reorder is a hard no-go. This is not negotiable.


I've been using [Joplin][joplin] for some time. It allows you to simply create _notebooks_ and _notes_ within them. Each _note_ is a markdown page and you can do whatever you want in it. Joplin was serving its purpose, but I didn't really enjoy using it. First, it is written in Javascript and bundled with [Electron][electron], so it is kinda slow and clumsy. I was also missing my Vim key bindings (it has Vim mode now, so it shouldn't be a problem anymore), and finally, it used a different color scheme than the rest of my system. Which, simply speaking, bothered me. This could have probably been solved by using its CLI interface, but then I discovered and migrated to [Vimwiki][vimwiki].

I would say, it has the same exact features, but it is a Vim plugin.

<div class="text-center img-row row">
  <img src="/files/img/vimwiki.png" alt="" />
  <p>Notes and long term ideas on the left, weekly plan on the right</p>
</div>




[qtile]: http://www.qtile.org/
[eclim]: http://eclim.org/
[my-java-ide]: http://www.abclinuxu.cz/desktopy/frostyx-20131207
[pycharm]: https://www.jetbrains.com/pycharm/
[buffers]: https://statico.github.io/vim3.html#buffers-buffers-buffers
[nerdtree]: https://github.com/preservim/nerdtree
[fzf-vim]: https://github.com/junegunn/fzf.vim
[fzf-blog]: https://statico.github.io/vim3.html#fzf
[shift-shift]: https://s3.amazonaws.com/media-p.slid.es/uploads/eliorboukhobza/images/959142/searcheverywhere.gif
[statico]: https://github.com/statico
[vim-after-11-years]: https://statico.github.io/vim.html
[everything-i-missed-in-vim-after-11-years]: https://statico.github.io/vim2.html
[vim-after-15-years]: https://statico.github.io/vim3.html
[joplin]: https://joplinapp.org/
[electron]: https://electronjs.org/
[vimwiki]: https://github.com/vimwiki/vimwiki
[base16]: https://github.com/chriskempson/base16
[urxvt]: http://software.schmorp.de/pkg/rxvt-unicode.html
[urxvt-default-screenshot]: https://i0.wp.com/www.linuxlinks.com/wp-content/uploads/2018/01/Screenshot-urxvt.jpg?resize=768%2C535&ssl=1
[tmux]: https://github.com/tmux/tmux/wiki
[tmux-how-to]: https://thevaluable.dev/tmux-boost-productivity-terminal/
[screen]: https://www.gnu.org/software/screen/
[hexchat]: https://hexchat.github.io/
[xchat]: http://xchat.org/
[weechat]: https://weechat.org/
[newsboat]: https://newsboat.org/
