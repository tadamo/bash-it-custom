#!/usr/bin/env bash

if [ -f ~/.dircolors/dircolors.ansi-dark ]; then
   #eval $(dircolors -b ~/.dircolors/dircolors.ansi-dark)
   eval $(TERM=xterm-256color bash -c 'gdircolors -b ~/.dircolors/dircolors.ansi-dark')
elif [ -f ~tadamo/.dircolors/dircolors.ansi-dark ]; then
   #eval $(dircolors -b ~tadamo/.dircolors/dircolors.ansi-dark)
   eval $(TERM=xterm-256color bash -c 'gdircolors -b ~tadamo/.dircolors/dircolors.ansi-dark')
fi
