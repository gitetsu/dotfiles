#!/usr/bin/env bash

platform=`uname`

if [ $platform = 'Darwin' ]; then
  xcode-select --install
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
