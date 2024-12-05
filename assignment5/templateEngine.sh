#!/bin/bash
 set -x

file=$1

fname=`echo $2  | cut -d "=" -f 2`

topic=`echo $3 | cut -d "=" -f 2`

echo $fname

echo $topic

echo "`sed 's/{{fname}}/'$fname'/g;s/{{topic}}/'$topic'/g' $file`"
