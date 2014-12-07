#!/bin/bash

ARRAY_TEST=( \
"first" \
  "second" \
       "third")

COUNT=0

TMP=${ARRAY_TEST[$COUNT]}
echo ${TMP:0:${#TMP}-2}_ground.xyz