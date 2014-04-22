#!/bin/bash
cwd=`dirname ${0}`
expr ${0} : "/.*" > /dev/null || cwd=`(cd ${cwd} && pwd)`

cd $cwd

# xcode Command Line Tools
xcode-select --install

# homebrewのインストール
if test ! `brew --version`
then
	ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
fi

# モジュールのインストール
cd $cwd/brew
brew bundle
cd $cwd

# シェルの変更
if test ! `grep "/usr/local/bin/zsh" /etc/shells`
then
	echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells
	chpass -s /usr/local/bin/zsh
fi
