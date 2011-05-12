#!/bin/bash

REPODIR=$(cd $(dirname $0) && pwd)
for file in `find $REPODIR -type f -maxdepth 1`; do
	if [ `basename $file` = `basename $0` ]; then
		continue
	fi
	ln -fs $file $HOME/.`basename $file`
done
