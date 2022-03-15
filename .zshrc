### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
      zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions

zinit wait'0' light-mode lucid for \
  mafredri/zsh-async \
  zdharma-continuum/history-search-multi-word \
  jasonmccreary/git-trim \
  atload"_anyframe-config" \
    mollifier/anyframe \
  atload"bindkey '^x^e' emoji::cli" \
    b4b4r07/emoji-cli \
  b4b4r07/enhancd \
  hlissner/zsh-autopair \
  atload'_fzf-widgets-config' \
    ytet5uy4/fzf-widgets \
  atinit"alias gdc='gd --cached'" \
    wfxr/forgit \
  atload"bindkey '^x^f' zce" \
    hchbaw/zce.zsh

_anyframe-config () {
  zle -N _anyframe-gitmoji
  bindkey '^[ig' _anyframe-gitmoji
  zle -N _anyframe-edit-yadm-files
  bindkey '^[e.' _anyframe-edit-yadm-files
}

_anyframe-gitmoji () {
  gitmoji -l \
    | anyframe-selector-auto \
    | awk '{print $3}' \
    | anyframe-action-insert
}

_anyframe-edit-yadm-files () {
  yadm list -a \
    | anyframe-selector-auto \
    | awk -v home=$HOME '{printf "%s/%s", home, $1}' \
    | anyframe-action-execute $EDITOR --
}

_fzf-widgets-config () {
  bindkey '^[ds'  fzf-select-docker-widget
  bindkey '^[dc' fzf-docker-remove-containers
  bindkey '^[di' fzf-docker-remove-images
  bindkey '^[dv' fzf-docker-remove-volumes

  bindkey '^[ef' fzf-edit-files

  bindkey '^[gs' fzf-select-git-widget
  bindkey '^[ga' fzf-git-add-files
  bindkey '^[gb' fzf-git-checkout-branch
  bindkey '^[gd' fzf-git-delete-branches
  bindkey '^[gr' fzf-git-change-repository

  bindkey '^[if' fzf-insert-files
  bindkey '^[id' fzf-insert-directory

  bindkey '^[kp' fzf-kill-processes

  bindkey '^[ss' fzf-exec-ssh
}

bindkey -e
bindkey '^p' history-beginning-search-backward
bindkey '^n' history-beginning-search-forward
bindkey '^x^d' kill-word

source ~/.aliases
source ~/.exports
source ~/.functions

zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'

if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi

if [ -e /usr/local/share/zsh-completions ]; then
    fpath=(/usr/local/share/zsh-completions $fpath)
fi

if (( $+commands[direnv] )); then
  eval "$(direnv hook zsh)"
fi

if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi
