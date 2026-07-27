# ~/.bash_aliases — portable shell conveniences (synced from dotfiles/bash)
# Ubuntu's default ~/.bashrc auto-sources this file. Keep it portable: no
# macOS/zsh-specific bits (pbcopy, brew, zstyle, absolute /Users paths).

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ls (GNU coreutils)
alias l='ls -lFh'
alias ll='ls -lFh'
alias la='ls -lAFh'

# tree (install `tree` for this to work)
alias tree="tree --dirsfirst -C -I 'node_modules'"

# editor: prefer nvim if present, else vim
if command -v nvim >/dev/null 2>&1; then
  alias vim='nvim'
  export EDITOR='nvim' GIT_EDITOR='nvim'
else
  export EDITOR='vim' GIT_EDITOR='vim'
fi
