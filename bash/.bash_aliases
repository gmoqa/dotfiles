# ~/.bash_aliases - Custom command aliases

# Common aliases
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

# Quick navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Git aliases (add more as needed)
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Termux specific
alias cls='clear'
alias update='pkg update && pkg upgrade'

# Add your custom aliases below this line
