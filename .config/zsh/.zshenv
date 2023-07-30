export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

export ZDOTDIR=$XDG_CONFIG_HOME/zsh

export PATH=$HOME/.local/bin:/opt/homebrew/bin:$PATH

export HOMEBREW_BUNDLE_FILE=$XDG_CONFIG_HOME/homebrew-bundle/Brewfile

export DOT_BASE_DIR=$HOME # for fzf-edit-dotfiles
export FZF_DEFAULT_OPTS='--height=40% --layout=reverse --bind=ctrl-j:accept,ctrl-k:kill-line,alt-n:preview-page-down,alt-p:preview-page-up --cycle --select-1 --exit-0 --preview "bat -r 0:100 --color=always {}"'

export PASSWORD_STORE_ENABLE_EXTENSIONS=true
export PASSWORD_STORE_EXTENSIONS_DIR=$XDG_DATA_HOME/password-store/extensions

export GOKU_EDN_CONFIG_FILE=$XDG_CONFIG_HOME/karabiner/karabiner.edn

export STARSHIP_CONFIG=$XDG_CONFIG_HOME/starship/config.toml

export TEALDEER_CONFIG_DIR=$XDG_CONFIG_HOME/tealdeer
export TEALDEER_CACHE_DIR=$XDG_CACHE_HOME/tealdeer

export READNULLCMD=bat

export EDITOR=nvim
