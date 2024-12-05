#!/bin/bash
set -x
action=$1

case ${action} in 
	addlinetop)
		file=$2
		line=$3

                sed -i "1s/^/$3\n/" "$2"
		;;

	addlinebottom)
		file=$2
		line=$3
	     
		sed -i "\$a $3" "$2"
		;;

	addlineat)
		file=$2
		linenumber=$3
		line=$4

		sed -i "/$3/i$4" $2
		;;

	updatefirstword)
		file=$2
		word1=$3
		word2=$4

		sed -i 1s"/$3/$4/" $2
		;;

	updateallwords) 
		file=$2
		word1=$3
		word2=$4

		sed -i s"/$3/$4/g" $2
		;;

	insertword)
                 file=$2
		 word1=$3
		 word2=$4
		 new_word=$5

		 sed -i -e "s/\($3\)/\1 $5/g" -e "s/\($5\) $4/$5 $4/g" "$2"
		 ;;

	 deleteline) 
		 file=$2
		line_number=$3
	        
		sed -i "/$3/d" "$2"
		;;

	DELETELINE)
		file=$2
		line_number=$3
		word=$4

	        sed -i "/$4/ { ${3}d; }" "$2"
		;;

 esac	

