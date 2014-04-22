#!/bin/bash

# コマンド箇所の確認
DIRNAME=`which dirname`

# スクリプトの位置を確定
CURRENT=`$DIRNAME ${0}`
expr ${0} : "/.*" > /dev/null || CURRENT=`(cd $CURRENT && pwd)`


# 【関数】ホームディレクトリへのリンクを作成する
create_link() {
    source="$PWD/$1"
    target="$HOME/${1/_/.}"
    echo "Install:  $target"
    ln -sf $source $target
}

# 【関数】NVM設定の挿入
set_nvm_config() {
    target=$HOME/$1
    if test ! `grep ".nvm/nvm.sh" $target`; then
        echo 'if [[ -s $HOME/.nvm/nvm.sh ]] ; then source $HOME/.nvm/nvm.sh ; fi' \
            | tee -a $target
    fi
}

# カレントディレクトリを変更
cd ${CURRENT}

# サブモジュールの更新
git submodule init
git submodule update


# コマンドのリンクを作成
create_link bin

# ZSH関連のリンクを作成
create_link _zsh
create_link _zshrc
echo "Install:  $HOME/.zshrc.local"
touch $HOME/.zshrc.local

# vim関連のリンクを作成
create_link _vim
create_link _vimrc

# 環境別のリンクを作成
case "$OSTYPE" in
darwin*)
    create_link .zshrc.osx
    ;;
linux*)
    create_link .zshrc.linux
    ;;
esac

# カレントディレクトリをホームへ
cd $HOME

# nvmのインストール
if [ ! -e $HOME/.nvm/nvm.sh ]; then
    # 未インストールの場合はインストール
    git clone git://github.com/creationix/nvm.git $HOME/.nvm
    if [ -f "$HOME/.zshrc" ]; then
        set_nvm_config $HOME/.zshrc
    elif [ -f "$HOME/.bash_profile" ]; then
        set_nvm_config $HOME/.bash_profile
    elif [ -f "$HOME/.bashrc" ]; then
        set_nvm_config $HOME/.bashrc
    fi
else
    # インストール済みの場合はアップデート
    cd $HOME/.nvm
    git pull
fi

# nodejsの最新化
. $HOME/.nvm/nvm.sh
NVM_VER=`nvm ls-remote | tail -1 | sed "s/.*\(v[0-9]*\.[0-9]*\.[0-9]*\).*/\1/"`
nvm install $NVM_VER
nvm use $NVM_VER
nvm alias default $NVM_VER

# rvmのインストール
if [ ! -e $HOME/.rvm ]; then
    curl -L get.rvm.io | bash -s stable
fi

# カレントディレクトリを実行パスへ
cd $CURRENT;

# OS毎の処理を行う
case "$OSTYPE" in
darwin*)
    /bin/bash $CURRENT/mac/setup.sh
    ;;
linux*)
    ;;
esac
