
# MacPorts Installer addition on 2017-07-30_at_16:54:49: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
#export PATH="$PATH:/opt/local/bin:/opt/local/sbin"

# Finished adapting your PATH environment variable for use with MacPorts.
export PATH="$HOME/bin/:$HOME/usr/bin/:/Users/dhinton/projects/arc/arcanist/bin/:$PATH"

# llvm
export PATH="$PATH:/Users/dhinton/projects/llvm_project/monorepo/llvm-project/llvm/utils/git-svn"

#export PATH=${PATH}:~/projects/arc/arcanist/bin:~/bin
#export PATH=${HOME}/usr/bin:${PATH}


# Avoid duplicates
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="&":"[ ]*"
#export HISTCONTROL=ignoredups:erasedups
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# After each command, append to the history file and reread it
#export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
# "history -a" shares with other shells
#export PROMPT_COMMAND="history -a; history -c; history -r"

HISTFILESIZE=100000
HISTSIZE=100000
PAGER=less
PS1="${HOSTNAME##*.}:\${PWD} \$ "
export HISTFILESIZE HISTSIZE PAGER PS1

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# added by Anaconda2 2018.12 installer
# >>> conda init >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$(CONDA_REPORT_ERRORS=false '/anaconda2/bin/conda' shell.bash hook 2> /dev/null)"
if [ $? -eq 0 ]; then
    \eval "$__conda_setup"
else
    if [ -f "/anaconda2/etc/profile.d/conda.sh" ]; then
        . "/anaconda2/etc/profile.d/conda.sh"
        CONDA_CHANGEPS1=false conda activate base
    else
        \export PATH="/anaconda2/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda init <<<

source $HOME/projects/misc/response-files/setup_response_files.sh
