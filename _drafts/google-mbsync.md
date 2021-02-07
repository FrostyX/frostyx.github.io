---
layout: post
title: Synchronize 2FA Gmail with mbsync
lang: en
tags: fedora emacs mbsync email gmail howto
---

In comparison to graphical email clients configuring the terminal ones
can be an unexpectedly painful experience. Not the client
configuration itself but rather the synchronization with
server. Personally I spent twenty hours getting my mail into Emacs
(and previously into Mutt), and everything that you would expect to be
a problem was just fine. The only thing that presented a real
challenge was getting the freaking synchronization with Gmail
working. Let me share my findings to ease you the pain a little.


## The obligatory intro on email clients

If you use, or ever tried to use some of the mainstream email clients
such as [Thunar][thunar], [Evolution][evolution], [Geary][geary], etc,
or some of the mobile phone clients (I am not a mobile phone nerd, so
I don't know which ones. I just have some Gmail _thingy_ there), you
might formed an idea what an email client is supposed to do - download
your messages, index them, filter them, let you interactively work
with them. And of course allowing to send messages as well. There is
nothing groundbreaking about this, right? That's just how email works
and therefore what email clients are supposed to do.

Command-line (or rather text-based) email clients does much less and
delegate a lot of work to a series of other small tools (aka the
[Unix philosophy][unix-philosophy]).

Typically, we have a separate program for simply downloading the mail
from server. There is a many options such as `mbsync` from
[isync][isync] package, [OfflineIMAP][offlineimap],
[getmail][getmail], etc. Its only job is to download the mail and save
it (one message per file) to your disk. This alone has some benefits
and can be used e.g. for backing-up your emails in case the mail
provider shuts down its busines. And while you can certainly open your
messages in `vim` and read their content, it is not what we are after.

Optionally, it's up to us to configure spam filter either on the
server-side (e.g. in Gmail settings) or on client by using
[procmail][procmail], [Bogofilter][bogofilter], or
[SpamAssasin][spamassasin].

The next building block is indexing. This is generally not true for
everybody but after many years of being subscribed to countless of
mailing lists, many of us have between tens of thousands and hunders
of thousands messages in our inbox. Directory-based storages just aint
gonna cut it, we need some kind of database with indexes. For this we
can use tools like [Mu][mu], or [Notmuch][notmuch-reindex].

Finally, we are getting to the fun part, which is diplaying, reading
and interacting with email. This is the most discussed and
tutorial-covered link in the chain. And while exciting, and hacker-ish
looking on screenshots, the configuration revolves mainly about color
schemes and key bindings, which is quite intuitive and also not that
big of a deal when using some default settings. Anyway, we can use the
following frontends - [Mu4e][mu4e], [Notmuch][notmuch], [Mutt][mutt],
[NeoMutt][neomutt], [Gnus][gnus], [Alpine][apline], and probably a
bunch of less known clients. One would expect, that for sending email,
we would utilize some specialized tool (and we certainly can) but
usually, it is handled by the frontend program.

As you noticed, there is a lot of interchangeable utilities, some of
them optional, some of them even more optional. The categories I
presented are not distinct and some tools overlap accross multiple of
them. Its up to you to put those lego blocks together and build your
own email setup.

Today we are going to talk about the very first category, which is
downloading the email messages to your computer. We are going to
utilize `mbsync` command, and we are going to set it up for you
enterprise 2FA gmail account. Since the result is bunch of files
in a directory, and every cool blog post should have a screenshot of
something, I am going to jump a few steps forward and show you how the
end-game might look like, once you open the mail (that if you finish
reading this article and manage to successfully download the mail first).

<div class="text-center img-row row">
  <a href="/files/img/rougier-mu4e.png">
    <img src="/files/img/rougier-mu4e-thumb.png"
		 alt="Mu4e configuration by @rougier" />
  </a>
  <p>
	This is not my configuration. This beautiful screenshot is taken from
	<a href="https://github.com/rougier/mu4e-dashboard">rougier/mu4e-dashboard</a>
	repository.
  </p>
</div>


## Normal email

First, please install the `isync` package, so we get this out of our
way. Use the package manager provided by your linux distribution, on
Fedora I would do

```shell
dnf install isync
```

Configuring multiple accounts in `mbsync` is trivial, and Gmail IMAP
is a mess, so I would recommend setting up an account from a different
provider (if you have this option) first, to learn how `mbsync`
works. Create the following configuration file `~/.mbsyncrc` and
insert the following settings.

```ssh
IMAPStore foo-remote
Host imap.foo.com
SSLType IMAPS
User frostyx@foo.com
Pass supercomplicatedpassword

MaildirStore foo-local
Path ~/Mail/foo/
Inbox ~/Mail/foo/INBOX
Subfolders Verbatim

Channel foo
Master :foo-remote:
Slave :foo-local:
Create Both
Expunge Both
Patterns * !spam
SyncState *
```

A more complicated version of this snippet can be found on
[ArchWiki][archwiki-mbsync], and it is also described on a counless of
blogs ([1][mbsync-blog-1], [2][mbsync-blog-2], [3][mbsync-blog-3],
[4][mbsync-blog-4], ...), so I am not going to describe the settings
here. I would by paraphrasing the [manpage][mbsync-manpage] anyway.
Let's just vaguely say, that first section describes how to log-in
into the email account provided by some third-party. The second
section describes where and how to store the downloaded messages on
our computer. The last section configures what should be synchronized
between those two, he said while pretending that he understands it.

Replace all `foo` symbols in the snippet by some short name of your
email account, e.g. `personal`, `work`, `test`, and properly set the
`Host`, `User`, and `Pass` values in the first section. Then you
should be able to successfully run the following command

```shell
# use the short email name you chose before
mbsync -V foo
```

There is not going to be any successful mesasge in that output, so
don't be surprised. Seeing a bunch of `Opening` and `Synchronizing...`
means that it works fine. To make sure see the mail directory

```shell
ls -1 ~/Mail
```

Now because we don't want to store our super secret email passowrds in
plaintext, we want to put it into some keychain and let `mbsync` how
to get it. Don't even think about using `gpg` command, thats more
complicated than rocket science. Use [pass][pass] instead!

```shell
# Initialize the keychain, you will run this just once in your life
pass init <gpg-id or email>

# Insert the password for your email account
pass insert email/frostyx@foo.com

# And print it to the termial to make sure it was stored properly
pass email/frostyx@foo.com
```

This is all that you need to know about `pass` (but it has some cool
features such as storing passwords to git, that is worh checking
out). Now, remove the `Pass` line from our `~/.mbsyncrc` config and
use this one instead.

```ssh
PassCmd "pass email/frostyx@foo.com"
```

Make sure that `mbsync -V foo` still works, even with the password
form keychain.


## Gmail IMAP sucks

Before moving to Gmail configuration, I would like to make a
disclaimer - Gmail IMAP support has limitations, idiosyncrasies, and
more sciencetifically, it just sucks. Please have patience.

- Each tag is represented as a folder and messages with multiple tags
  will be downloaded multiple times, into each folder
- The [daily download limit is 2500 MB][gmail-limit], so it may take a
  several days for you to initially download your mail.
- Your Gmail password **will not work**, An
  [App Password][app-password] is required

All lof these can be workarounded and/or solved. Its just something to
keep in mind.


## Gmaill with plain password

Armored with a bulletproof patience and unending determination, we
shall continue to `mbsync` configuration for Gmail. Now, if you think
"maybe I should try personal Gmail account without 2FA, it is going to
be easier. I don't know how would I put those one-time passwords in my
config anyway", please smother the idea in this instant. It is not
possible. Please repeat after me, it is not possible. I refused to
believe it, tried over and over, failed miserably, over and over, and
ended up [configuring 2FA][gmail-2fa] anyway. Please save yourself the
time and pain.

Log-in to your [Gmail][gmail] account and click to your profile
picture in the top-right. Then continue to "Manage your Google
Account". In the left menu, click on "Security". Turn on the 2-Step
Verification.

<div class="text-center img-row row">
  <a href="/files/img/gmail-2fa.png">
    <img src="/files/img/gmail-2fa.png"
		 alt="Gmail 2FA setting" />
  </a>
</div>

Now we need to generate an [App Password][app-password]. Click on "App
passwords" and you will be redirected to this.

<div class="text-center img-row row">
  <a href="/files/img/gmail-app-passwords.png">
    <img src="/files/img/gmail-app-passwords.png"
		 alt="Gmail App passwords" />
  </a>
</div>

To create a new password click on "Select app" and change it to "Other
(Custom name)", and name it however you want.


<div class="text-center img-row row">
  <a href="/files/img/gmail-app-passwords-create.png">
    <img src="/files/img/gmail-app-passwords-create.png"
		 alt="Create a new Gmail App password" />
  </a>
</div>

Copy the generated password from the yellow stripe. This is the only
time you will be able to see it. After closing this page, you won't be
able to display it again, so please copy-paste it somewhere and we
will put it to the keyring in a minute.


## Gmail with 2FA



[thunar]: #
[evolution]: #
[geary]: #
[unix-philosophy]: #
[isync]: #
[offlineimap]: #
[getmail]: https://wiki.archlinux.org/index.php/Getmail
[mu]: https://www.djcbsoftware.nl/code/mu/mu4e/Indexing-your-messages.html
[notmuch-reindex]: https://notmuchmail.org/manpages/notmuch-reindex-1/
[procmail]: #
[bogofilter]: #
[spamassasin]: #
[archwiki-mbsync]: https://wiki.archlinux.org/index.php/Isync#Configuring
[mbsync-manpage]: https://isync.sourceforge.io/mbsync.html
[mbsync-blog-1]: https://people.kernel.org/mcgrof/replacing-offlineimap-with-mbsync
[mbsync-blog-2]: https://rakhim.org/fastmail-setup-with-emacs-mu4e-and-mbsync-on-macos/
[mbsync-blog-3]: https://gist.github.com/chandraratnam/f00ab7d4a5298830f692021964fdb99f
[mbsync-blog-4]: https://jherrlin.github.io/posts/emacs-mu4e/
[pass]: https://www.passwordstore.org/
[gmail-limit]: https://support.google.com/a/answer/1071518?hl=en
[app-password]: https://support.google.com/mail/answer/185833?hl=en
[gmail]: #
[gmail-2fa]: https://support.google.com/accounts/answer/185839
