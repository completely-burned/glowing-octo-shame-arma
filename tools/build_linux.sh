#!/bin/bash

DIR=$(dirname "${BASH_SOURCE[0]}")/..

cd ${DIR}

rm -rf ${DIR}/tmp/*

if [ ! -d ${DIR}/tmp ]; then
	mkdir ${DIR}/tmp
fi

if [ ! -d ${DIR}/out ]; then
        mkdir ${DIR}/out
fi

V=$(grep briefingName ${DIR}/glowing-octo-shame-blufor.Sara/mission.sqm | sed -e 's/.*glowing-octo-shame v\(.*\) .* .*/\1/' -e 's/\./\-/gi')


# Sara blufor
ln -s ./../glowing-octo-shame-blufor.Sara ${DIR}/tmp/glowing-octo-shame-blufor.Sara

makepbo -NM ${DIR}/tmp/glowing-octo-shame-blufor.Sara ${DIR}/out/glowing-octo-shame-blufor-${V}.sara.pbo
