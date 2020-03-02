### Added by Zplugin's installer
source "$HOME/.zplugin/bin/zplugin.zsh"
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
### End of Zplugin installer's chunk

zplugin light "mafredri/zsh-async"
zplugin light "denysdovhan/spaceship-prompt"
zplugin light "zsh-users/zsh-autosuggestions"
zplugin light "zdharma/fast-syntax-highlighting"
zplugin light "zdharma/history-search-multi-word"
zplugin light "zsh-users/zsh-completions"
zplugin light "mollifier/anyframe"
zplugin light "b4b4r07/emoji-cli"
zplugin light "b4b4r07/enhancd"

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

export SPACESHIP_CHAR_SYMBOL="⋱ "
