#!/bin/bash 

set -x

action=$1

case ${action} in 

	listbranches)
		git branch
		;;

	createbranch)
		branch_name=$2
		git branch $2
		;;

	deletebranch)
		branch_name=$2
		git branch -d $2
		;;

	mergebranch)
		branch_1=$2
		branch_2=$3
		git merge $2 $3
		;;

	rebasebranches)
		branch_1=$2
		branch_2=$3
		git checkout $2
		git rebase $3
		;;   
esac
