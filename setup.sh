#!/bin/sh
CURRENT=${PWD}
SCRIPT_NAME=`/bin/readlink -f $0`

cd `/usr/bin/dirname ${SCRIPT_NAME}`

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
