+++
title = "This Week I Discovered: Tmux"
author = ["Krishan Wyse"]
publishDate = 2018-01-21T00:00:00+00:00
tags = ["twid", "tools"]
categories = ["twid"]
draft = false
+++

Tmux seems like a natural progression from last week's [Vim Minimalism](/posts/twid-vim-minimalism), right?
It's associated with the typical Vim power user setup. I remember playing with
it back when I first started using Vim as well. The problem I had was _why_. Vim
already has panes, what many other applications would call split windows. And if
you use a tiling window manager like [i3](https://i3wm.org/), you have panes at the application level
as well.

[Tmux](https://github.com/tmux/tmux/wiki) fills in the middle ground, operating at the shell session level. When you
launch `tmux` in a shell session, it will spin up the tmux _server_, launch the
_client_, and put you in a _session_ with one _window_ and one _pane_. You can
spawn as many sessions as you want, detaching and re-attaching among them. They
are independent of each other. Each window belongs to a session and acts similar
to tabs in other applications. Each pane belongs to a window a controls a
particular part of the screen. Like sessions, you can spawn as many windows and
panes as you wish, rearrange them, and move them to other sessions and windows
respectively.

Why is this useful? Organisation. A key difference between my first trial with
tmux some years ago and this past week is that I now have a job and work more in
the shell. Yes, you can achieve this with a tiling window manager, or even
inside terminals themselves. Both [iTerm2](https://www.iterm2.com/) on OS X and [Terminator](https://gnometerminator.blogspot.co.uk/p/introduction.html) support panes
and tabs. But tmux is cross-platform, and configuration portability is a big
boon if you work on multiple machines.


## Making it work for you {#making-it-work-for-you}

And configurable it is! Read through the man page and you'll see all the
possibilities. Look online and you'll see all the people taking advantage of
that. Perhaps too far sometimes. Vanilla tmux can be unwieldy, but with only a
few modifications it can feel very comfortable.

The most obvious modification is to change the prefix key. This is the key you
need to tap before most tmux keyboard shortcuts, to prevent conflicts with child
processes. By default it's mapped to `Ctrl-B`. Many recommend mapping it to
`Ctrl-A`, which matches the prefix key for [GNU Screen](https://www.gnu.org/software/screen/), a much older terminal
multiplexer. I don't recommend this because it conflicts with Vim's number
incrementation. Maybe that's okay because it's not the most common of
keystrokes, but [`Ctrl-S` is free](http://vim.wikia.com/wiki/Unused%5Fkeys)! Given it's just one more key over I think this
binding makes far more sense. Time will tell.

If you're playing around with your config, adding a mapping that calls
`source-file` with your config as an argument is invaluable so that you can
quickly test out changes. Adding more vi-like pane-selection mappings is useful,
as is more vi-like copy-mode behaviour like explained [here](https://sanctum.geek.nz/arabesque/vi-mode-in-tmux/).  A particularly
great mapping is window reordering. I'm surprised this isn't in more configs
online because it's insanely good! I found it in [this answer on superuser](https://superuser.com/a/552493), but
tweaked it so that it supports repeated keys and forces you to use the prefix
key.

```tmux
bind-key -r S-Left swap-window -t -
bind-key -r S-Right swap-window -t +
```

Otherwise I try to keep other mappings and remappings to a minimum. Many suggest
to remap the window split commands, like remapping a horizontal split from
`<prefix>%` to `<prefix>|`, but I find the visual association unnecessary. I've
only been using tmux for a week and have already gotten used to the default.

In a similar vain, I've kept my status bar minimal. It only contains the session
name and the window list. The current window is highlighted and activity in an
inactive window causes the window index display to change colour. It's clean and
out of the way.

The remainder of my config is specifying consistent colours across the status
bar, pane borders, pane information display and clock. Yes, you can press
`<prefix> T` to get a full-pane clock display! Another reason it doesn't need to
be in the status bar. Enabling `renumber-windows` is useful if you have large
sessions with short-lived windows. Changing `base-index` and `pane-base-index`
to 1 will make it easier to select them with the number keys, rather than
reaching over for `0`. I've also set the status bar to appear to top because it
can get pretty cluttered down south when vim is also running.


## Notice your habits {#notice-your-habits}

Keegan Lowenstein wrote a great [blog post](https://blog.bugsnag.com/tmux-and-vim/) on Vim integration with tmux. One the
tools he mentioned is [vimux](https://github.com/benmills/vimux), a Vim plugin that allows you to interact with tmux
from inside Vim. This is next on my list of things to play around with. Vim
already has pretty good shell integration, so I'm sceptical, but his example of
the edit-test-repeat loop and how vimux can help with it is pretty convincing.

If you have a similar workflow that is as common, then by all means you should
make it easier to perform. Tools like vimux can help, as can a better
understanding of tmux. Maybe down the road you notice it would be great to
always have on-screen vision on the output of a particular shell process. Tmux
supports this out of the box and you can easily add that to the status bar.

The week wasn't entirely smooth sailing. I've had trouble getting user-defined
options working. These are options that are prefixed with `@`. I want to keep my
colour scheme consistent in the file so declaring a custom option would be
ideal. It could also be interesting to only show the status bar when the prefix
key is pressed, and make it vanish again when the subsequent key is
pressed. This seems pretty difficult with tmux alone, but I'm sure it's possible
through shell scripting.  After all, the status bar can be toggled in this way.

It can pay off in the long run to keep the configs for new tools small to begin
with. Only use what you know will give you benefit and add more as time goes by
and you discover new things. It's much easier to maintain when you've added
every line for a reason!

_Closing tip_: use `<prefix> Z`! This _zooms_ the active pane to take up the
full size of its containing window. Use the same binding to revert the original
layout. It's great for temporarily getting the big picture if you're working on
a smaller screen.