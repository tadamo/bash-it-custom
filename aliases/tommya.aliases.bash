#!/usr/bin/env bash

cite about-alias
about-alias 'tommya aliases'

alias cls='clear'
alias .='cd ../'
alias ..='cd ../../'
alias ...='cd ../../../'
alias mroe='more'
alias l='ls -l --all --color --classify --human-readable' # using gnu coreutils ls
alias t='tree -haCF'
alias where='which'
alias dusort="du -ks ./* | sort -n"
alias empty-file="truncate -s 0 $@"
alias watch-mojo-log="multitail -F ~/.multitail.conf -cS mojo $@"
alias grep="grep --color=auto $@"

alias iterm_myub="i2cssh -XAt -c myub"
alias iterm_myubqa="i2cssh -XAt -c myubqa"
alias iterm_cmsweb="i2cssh -XAt -c cmsweb"
alias iterm_cmswebqa="i2cssh -XAt -c cmswebqa"
