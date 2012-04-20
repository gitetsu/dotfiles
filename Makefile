
install: emacs screen gitconfig inputrc

emacs:
	ln -s `pwd`/emacs.d ${HOME}/.emacs.d

screen:
	ln -fs `pwd`/screenrc ${HOME}/.screenrc

gitconfig:
	ln -fs `pwd`/gitconfig ${HOME}/.gitconfig

inputrc:
	ln -fs `pwd`/inputrc ${HOME}/.inputrc

.PHONY: install emacs screen gitconfig inputrc
