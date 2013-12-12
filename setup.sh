#!/bin/sh
CURRENT=${PWD}

cd `/usr/bin/dirname ${0}`

git submodule init
git submodule update

create_link() {
    source="${PWD}/$1"
    target="${HOME}/${1/_/.}"

    echo "Install:	$target"
    ln -sf ${source} ${target}
}


for i in _*
do
    create_link $i
done
create_link bin


cd ${HOME}

# nvm install
git clone git://github.com/creationix/nvm.git .nvm
${HOME}/.nvm/install.sh

# rvm
curl -L get.rvm.io | bash -s stable

cd ${CURRENT}
