#!/bin/bash

set -o emacs

export TERM=xterm-256color

# Avoid duplicates
#export HISTCONTROL=ignoreboth:erasedups
#export HISTCONTROL=ignoredups:erasedups
# When the shell exits, append to the history file instead of overwriting it
#shopt -s histappend

# After each command, append to the history file and reread it
#export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
#export PROMPT_COMMAND="history -a; history -c; history -r"

#HISTFILESIZE=100000
#HISTSIZE=100000
PAGER=less
PS1="${HOSTNAME##*.}:\${PWD} \$ "
#export HISTFILESIZE HISTSIZE PAGER PS1
export PAGER PS1

# turn off bell
#xset -b

export DYLD_LIBRARY_PATH=${DYLD_LIBRARY_PATH}:

export CCACHE_CPP2=yes

EMACS=`which emacs`
export EMACS

function emacs
{
  command ${EMACS} -nw $@
}

XTERM_CMD=`which xterm`

function xterm
{
  command ${XTERM_CMD} -rv $@
}

alias gmake='make'
