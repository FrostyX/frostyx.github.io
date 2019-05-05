---
layout: post
title: Vimwiki diary template
lang: en
categories: fedora vim vimwiki diary org GTD
---

Vimwiki is a plugin for managing personal wiki in your Vim environment. It provides a simple way to organize notes and create links between them, manage todo lists, write a diary and have many other useful features. In this article, we are going to focus solely on the diary and how to make its usage much smoother.

Don't think of a diary in the conventional sense as a notebook that someone opens every night in bed and writes "My dear diary, why am I still alone?" to a new page while crying and eating ice cream. Of course, this is a valid way to use a diary, but there is much more to it. Technically, the diary in Vimwiki is a set of files named `YYYY-MM-DD.wiki` stored in the `~/vimwiki/diary/` directory. It is not at all concerned with their content, so it can be whatever fits your needs. Personally, I prefer to separate each page in my diary into multiple sections. First, I have my daily checklist, which is a set of actions that I have to do on a daily basis but tend to forget them, then having a section with things, that I have to do on that specific day and lastly having some space for taking quick notes, that will be categorized and written down in greater context later.

The problem with Vimwiki is, that it always creates diary pages empty. There was an [RFE requesting entry templates](https://github.com/vimwiki/vimwiki/issues/622), but it was in my opinion prematurely closed, suggesting [ultisnips](https://github.com/SirVer/ultisnips) as a way to go. I don't like this solution at all, so fortunately, there is a better option, that was originally recommended to me by [@brennen](https://code.p1k3.com/gitea/brennen). I made some minor improvements, but he is the one who truly deserves the credit. So, how to make templates for vim wiki diary pages?

<div class="text-center img">
  <a href="/files/img/vimwiki-diary-template/vimwiki-diary-template.gif">
    <img src="/files/img/vimwiki-diary-template/5.png" alt="" />
  </a>
  <p>This is an animated gif, click on it! Please ... it was a lot of work.</p>
</div>

First, we need to create a script that prints the desired template to the standard output. Why script and not just having a template content in a text file? That's because for each day we want to at least generate its date to the title. Use what programing language you prefer. It can look like this.

<pre class="prettyprint lang-py">
#!/usr/bin/python
import datetime

template = """# {date}

## Daily checklist

* [ ] Take a vitamin C
* [ ] Eat your daily carrot!

## Todo

## Notes"""

rendered = template.format(date=datetime.date.today())
print(rendered)
</pre>

Save the script as `~/.vim/bin/generate-vimwiki-diary-template`. Don't forget to make it executable.

	chmod +x ~/.vim/bin/generate-vimwiki-diary-template

Now, we need to configure Vim to use it when creating diary pages. This requires no additional plugin. Just put this line in your `~/.vimrc`.

	au BufNewFile ~/vimwiki/diary/*.md :silent 0r !~/.vim/bin/generate-vimwiki-diary-template

If needed, change the `~/vimwiki/diary/*.md` to an appropriate format, depending on whether you use `.wiki` or `.md`. And that's really all of it, please come to chat on `#vimwiki` at [freenode.net](https://freenode.net/) and let us know, what do you think!
