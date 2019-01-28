#!/usr/bin/env bash

if [ -f ~/perl5/perlbrew/etc/bashrc ]; then
   source ~/perl5/perlbrew/etc/bashrc
   ln -s -f $(which perl) /usr/local/bin/perl
fi
