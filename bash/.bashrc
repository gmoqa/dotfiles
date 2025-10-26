# ~/.bashrc - Bash configuration for Termux

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# History settings
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth  # ignorespace + ignoredups
shopt -s histappend

# Check window size after each command
shopt -s checkwinsize

# Better directory navigation
shopt -s autocd 2>/dev/null  # cd to directory by typing name
shopt -s cdspell 2>/dev/null # autocorrect typos in path

# Colored prompt
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Enable color support
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Load custom aliases if exists
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Termux specific settings
if [ -n "$TERMUX_VERSION" ]; then
    # Add your Termux-specific configurations here
    export EDITOR=vim
fi
