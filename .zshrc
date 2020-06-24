### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

zinit for \
  light-mode denysdovhan/spaceship-prompt \
  light-mode zdharma/fast-syntax-highlighting

zinit lucid wait'!0' for \
  light-mode mafredri/zsh-async \
  light-mode zsh-users/zsh-autosuggestions \
  light-mode zdharma/history-search-multi-word \
  light-mode zsh-users/zsh-completions \
  light-mode mollifier/anyframe \
  light-mode b4b4r07/emoji-cli \
  light-mode b4b4r07/enhancd

bindkey -e
bindkey '^x^g' anyframe-widget-cd-ghq-repository
bindkey '^x^e' emoji::cli

source ~/.aliases
source ~/.exports
source ~/.functions

eval "$(direnv hook zsh)"

zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'

if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi

if [ -e /usr/local/share/zsh-completions ]; then
    fpath=(/usr/local/share/zsh-completions $fpath)
fi

export SPACESHIP_PROMPT_ADD_NEWLINE=false
export SPACESHIP_PROMPT_SEPARATE_LINE=false
export SPACESHIP_CHAR_SYMBOL="⋱  "
export SPACESHIP_EXIT_CODE_SHOW=true
export SPACESHIP_EXIT_CODE_SYMBOL="✘ "
export SPACESHIP_CHAR_PREFIX="$NEWLINE"
