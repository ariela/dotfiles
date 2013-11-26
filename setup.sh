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

cd ${CURRENT}
