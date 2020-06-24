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

zinit light-mode for \
  denysdovhan/spaceship-prompt \

zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
      zdharma/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions

zinit wait'!0' light-mode lucid for \
  mafredri/zsh-async \
  zdharma/history-search-multi-word \
  atload"bindkey '^x^g' anyframe-widget-cd-ghq-repository" \
    mollifier/anyframe \
  atload"bindkey '^x^e' emoji::cli" \
    b4b4r07/emoji-cli \
  b4b4r07/enhancd \
  hlissner/zsh-autopair

bindkey -e

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
