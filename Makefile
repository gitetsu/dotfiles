
install: screen gitconfig inputrc

screen:
	ln -fs `pwd`/screenrc ${HOME}/.screenrc

gitconfig:
	ln -fs `pwd`/gitconfig ${HOME}/.gitconfig

inputrc:
	ln -fs `pwd`/inputrc ${HOME}/.inputrc

.PHONY: install screen gitconfig inputrc
