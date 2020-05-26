# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH=$HOME/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/bin:$PATH
export PATH=/usr/local/mysql/bin:$PATH
export PATH=/usr/local/opt/ruby/bin:$PATH

# Brew Mysql (Remove after Avanoo)
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

export JAVA_HOME="$(/usr/libexec/java_home)"

# Mono install for YCM (Brew Package)
export MONO_GAC_PREFIX="/usr/local"

# -- NVM
#
# For brew, at least

# NVM Stuff
export NVM_DIR="$HOME/.nvm"
. "$(brew --prefix nvm)/nvm.sh"
#
# -- end of NVM

# Home Brew - Z
. $(brew --prefix)/etc/profile.d/z.sh
# end of Home Brew - Z

# Path to your oh-my-zsh installation.
export ZSH="/Users/danielryan/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  docker
  docker-compose
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

alias tree="tree --filelimit 20 --dirsfirst -C -I 'node_modules'"
alias weather='curl -4 http://wttr.in/Boise'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

