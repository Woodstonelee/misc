#!/bin/bash

TRCFILENAMES=( \
  "/home/zhanli/Workspace/data/field/brisbane2013-TRAC/30731117.trc" \
  "/home/zhanli/Workspace/data/field/brisbane2013-TRAC/30731149.trc" \
  "/home/zhanli/Workspace/data/field/brisbane2013-TRAC/30801111.trc" \
  "/home/zhanli/Workspace/data/field/brisbane2013-TRAC/30801148.trc" \
  "/home/zhanli/Workspace/data/field/brisbane2013-TRAC/30803100.trc" \
  "/home/zhanli/Workspace/data/field/brisbane2013-TRAC/30803106.trc" \ 
  "/home/zhanli/Workspace/data/field/brisbane2013-TRAC/30803132.trc" \
)

INDFILENAMES=( \
  "/home/zhanli/Workspace/data/field/brisbane2013-TRAC/30731117.ind" \
  "/home/zhanli/Workspace/data/field/brisbane2013-TRAC/30731149.ind" \
  "/home/zhanli/Workspace/data/field/brisbane2013-TRAC/30801111.ind" \
  "/home/zhanli/Workspace/data/field/brisbane2013-TRAC/30801148.ind" \
  "/home/zhanli/Workspace/data/field/brisbane2013-TRAC/30803100.ind" \
  "/home/zhanli/Workspace/data/field/brisbane2013-TRAC/30803106.ind" \ 
  "/home/zhanli/Workspace/data/field/brisbane2013-TRAC/30803132.ind" \
)

PGAPFILENAMES=( \
  "/home/zhanli/Workspace/data/field/brisbane2013-TRAC/30731117.pgap" \
  "/home/zhanli/Workspace/data/field/brisbane2013-TRAC/30731149.pgap" \
  "/home/zhanli/Workspace/data/field/brisbane2013-TRAC/30801111.pgap" \
  "/home/zhanli/Workspace/data/field/brisbane2013-TRAC/30801148.pgap" \
  "/home/zhanli/Workspace/data/field/brisbane2013-TRAC/30803100.pgap" \
  "/home/zhanli/Workspace/data/field/brisbane2013-TRAC/30803106.pgap" \ 
  "/home/zhanli/Workspace/data/field/brisbane2013-TRAC/30803132.pgap" \
)

# path to the Matlab scripts and functions
BASEDIR='/home/zhanli/Workspace/src/trac-ppfd2pgap'
ML="/usr/local/bin/matlab -nodisplay -nojvm -singleCompThread -r "

set -x
echo ${TRCFILENAMES[6]}
for ID in {0..6}
do
  echo $ID
  echo ${TRCFILENAMES[$ID]}
  $ML "addpath(genpath('$BASEDIR')); intrcfile='${TRCFILENAMES[$ID]}'; ingoodindfile='${INDFILENAMES[$ID]}'; outpgapfile='${PGAPFILENAMES[$ID]}'; run script_ppfd2pgap" &
  echo job submitted
done
set +x
