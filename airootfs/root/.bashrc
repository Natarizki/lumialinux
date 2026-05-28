RED='\[\e[31m\]'
BLUE='\[\e[34m\]'
RESET='\[\e[0m\]'
PS1="${RED}[\u@LUMIA]${RESET}-${BLUE}[\W]${RESET} # "

alias ls='ls --color=auto'
alias ll='ls -la'
alias grep='grep --color=auto'
alias update='lumen -Uu'
alias install='lumen -I'
alias remove='lumen -R'
