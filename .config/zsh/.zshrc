# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"

if [[ ! -f $XDG_DATA_HOME/antidote/antidote.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}antidote%F{220} Initiative Plugin Manager (%F{33}mattmc3/antidote%F{220})…%f"
    command mkdir -p "$XDG_DATA_HOME/antidote" && command chmod g-rwX "$XDG_DATA_HOME/antidote"
    command git clone --depth=1 https://github.com/mattmc3/antidote.git "$XDG_DATA_HOME/antidote" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

zstyle ':antidote:bundle' use-friendly-names 'yes'

source $XDG_DATA_HOME/antidote/antidote.zsh

# Set the name of the static .zsh plugins file antidote will generate.
zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins.zsh

# Ensure you have a .zsh_plugins.txt file where you can add plugins.
[[ -f ${zsh_plugins:r}.txt ]] || touch ${zsh_plugins:r}.txt

# Lazy-load antidote.
fpath+=($XDG_DATA_HOME/antidote)
autoload -Uz $fpath[-1]/antidote

# Generate static file in a subshell when .zsh_plugins.txt is updated.
if [[ ! $zsh_plugins -nt ${zsh_plugins:r}.txt ]]; then
  (antidote bundle <${zsh_plugins:r}.txt >|$zsh_plugins)
fi

# Source your static plugins file.
source $zsh_plugins

_anyframe-config () {
  zle -N _anyframe-gitmoji
  zle -N _anyframe-edit-yadm-files
}
zsh-defer _anyframe-config

_anyframe-gitmoji () {
  gitmoji -l \
    | anyframe-selector-auto \
    | awk '{print $3}' \
    | anyframe-action-insert
  zle redisplay
}

_anyframe-edit-yadm-files () {
  yadm list -a \
    | awk -v "home=$HOME" '{printf "%s/%s\n", home, $1}' \
    | anyframe-selector-auto \
    | anyframe-action-execute $EDITOR --
}

_bindkeys () {
  bindkey -e

  bindkey "^r" history-search-multi-word
  bindkey '^p' history-beginning-search-backward
  bindkey '^n' history-beginning-search-forward
  bindkey '^x^d' kill-word
  # ^M under csi-u
  bindkey '^[[109;5u' autosuggest-execute

  bindkey '^[ds'  fzf-select-docker-widget
  bindkey '^[dc' fzf-docker-remove-containers
  bindkey '^[di' fzf-docker-remove-images
  bindkey '^[dv' fzf-docker-remove-volumes

  bindkey '^[ef' fzf-edit-files
  bindkey '^[e.' _anyframe-edit-yadm-files

  bindkey '^[gs' fzf-select-git-widget
  bindkey '^[ga' fzf-git-add-files
  bindkey '^[gb' fzf-git-checkout-branch
  bindkey '^[gd' fzf-git-delete-branches
  bindkey '^[gr' fzf-git-change-repository

  bindkey '^[if' fzf-insert-files
  bindkey '^[id' fzf-insert-directory
  bindkey '^[ig' _anyframe-gitmoji

  bindkey '^[kp' fzf-kill-processes

  bindkey '^[ss' fzf-exec-ssh
}
zsh-defer _bindkeys

source ~/.aliases
source ~/.functions

export HISTFILE="$XDG_STATE_HOME/zsh/.zsh_history"
setopt inc_append_history
setopt share_history
setopt hist_ignore_dups
setopt extended_history
setopt hist_reduce_blanks

setopt extended_glob
setopt numeric_glob_sort

setopt no_clobber

setopt list_rows_first

setopt correct

[ -n $(alias run-help) ] && unalias run-help
autoload run-help

zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'

if [[ -f $ZDOTDIR/.zshrc.local ]]; then
  source $ZDOTDIR/.zshrc.local
fi

if [ -e $(brew --prefix)/share/zsh-completions ]; then
  fpath=($(brew --prefix)/share/zsh-completions $fpath)
fi

if (( $+commands[direnv] )); then
  eval "$(direnv hook zsh)"
fi

if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

if (( $+commands[asdf] )); then
  . $(brew --prefix)/opt/asdf/libexec/asdf.sh
fi

source $XDG_CONFIG_HOME/broot/launcher/bash/br

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
