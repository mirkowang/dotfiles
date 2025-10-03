# If you come from bash you might have to change your $PATH.
export PATH=/usr/local/bin:$HOME/.local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="simple"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git tmux)

# You may need to manually set your language environment
export LANG=en_US.UTF-8

source $ZSH/oh-my-zsh.sh

# User configuration
#
source ~/.alias

export EDITOR='vim'

alias vim='nvim'

# This command disables the software flow control that uses <C-s> and <C-q>.
stty -ixon

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

if [ -f "$HOME/.tokens" ]; then
  source "$HOME/.tokens"
fi

if [ -f "$HOME/.programming" ]; then
  source "$HOME/.programming"
fi

# Load .pyenvrc if it exists
if [ -f "$HOME/.pyenvrc" ]; then
  source "$HOME/.pyenvrc"
fi

export PATH="/Users/mirkowang/.rbenv/shims:${PATH}"
export RBENV_SHELL=zsh
command rbenv rehash 2>/dev/null
rbenv() {
  local command
  command="${1:-}"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  rehash|shell)
    eval "$(rbenv "sh-$command" "$@")";;
  *)
    command rbenv "$command" "$@";;
  esac
}

# Added by mirkowang
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql-client@8.0/bin:$PATH"

# export ANTHROPIC_AUTH_TOKEN=sk-OlsaGUP4Hc4JTggStDWSVYvZIQD8kzoHK7WRPu1vZMW9Kkzt
# export ANTHROPIC_BASE_URL=https://api.moonshot.cn/anthropic

# export ANTHROPIC_AUTH_TOKEN=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

export AZURE_OPENAI_API_KEY="CXhMsMCOkoHyYCtCyDbVhSYTB41XTHcTYlLW0z3JRmG9EHnDQzNjJQQJ99BIACHYHv6XJ3w3AAAAACOGkobM"
