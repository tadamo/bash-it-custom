#!/usr/bin/env bash

mypath=.
mypath=${mypath}:~/bin
if [ $USER != 'tadamo' ] && [ -d ~tadamo/bin ]; then
    mypath=${mypath}:~tadamo/bin
fi
mypath=${mypath}:~/local/bin
if [ $USER != 'tadamo' ] && [ -d ~tadamo/local/bin ]; then
    mypath=${mypath}:~tadamo/local/bin
fi

if [ -e $ORACLE_HOME ]; then
    mypath=${mypath}:$ORACLE_HOME
fi

if [ $(command -v brew) ]; then
    if [ -d $(brew --prefix coreutils)/libexec/gnubin ]; then
        mypath=${mypath}:$(brew --prefix coreutils)/libexec/gnubin
    fi

    if [ -d $(brew --prefix go)/libexec/bin ]; then
        mypath=${mypath}:$(brew --prefix go)/libexec/bin
    fi
fi

export HOMEBREW_FORCE_BREWED_CURL=1
mypath=${mypath}:/usr/local/opt/curl/bin
mypath=${mypath}:/usr/local/opt/grep/libexec/gnubin

mypath=${mypath}:/opt/local/bin
mypath=${mypath}:/opt/local/sbin
mypath=${mypath}:/usr/local/bin
mypath=${mypath}:/usr/local/sbin
export PATH=${mypath}:$PATH
