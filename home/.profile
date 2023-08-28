if [ -z ${ORIGINAL_PATH+x} ]; then
   export ORIGINAL_PATH="$PATH"
else
   export PATH=$ORIGINAL_PATH
fi

# MacPorts Installer addition on 2017-07-30_at_16:54:49: adding an appropriate PATH variable for use with MacPorts.
#export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
export PATH="$PATH:/opt/local/bin:/opt/local/sbin"

# Finished adapting your PATH environment variable for use with MacPorts.
#export PATH="$HOME/bin/:$HOME/usr/bin/:/Users/dhinton/projects/arc/arcanist/bin/:$PATH"

# arcanist
export PATH="$PATH:$HOME/workspaces/arcanist/bin/"

# php -- for arcanist
#export PATH="/Users/dhinton/workspaces/php_workspace/bin:$PATH"

export PATH="$HOME/bin:$PATH"

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

source $HOME/projects/misc/response-files/setup_response_files.sh

. .bashrc
