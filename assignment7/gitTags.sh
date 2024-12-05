#!/bin/bash

set -x

action=$1

case ${action} in

	createtag) 
		tag_name=$2
		git tag $2
		;;

	listtag)
		git tag
		;;

	deletetag)
		tag_name=$2
		git tag --delete $2
		;;

esac
