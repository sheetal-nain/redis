#!/bin/bash

set -x

repo_url=$1
days=$2

git log --since="$2" --stat --pretty=format:'%h,%an,%ae,%ar,%s' > log.csv
