#!/bin/bash

set -x

action=$1

case ${action} in
	
	topProcess_memory)
	        top -o %MEM | head -12
		;;

        topProcess_cpu)
                top -o %CPU | head -18
                ;;

        KillLeastPriorityProcess)
		process=$(ps -eo pid,pri,ni,comm --sort=pri | awk 'NR==2')

		if [ -n "$process" ]; then
			echo "kill -9 $pid"
		else 
			echo "no process found"
		fi
		;;
	
	RunningDurationProcess)
		PID=$2
		top -p $PID -o TIME+
		;;

	listOrphanProcess)
		 ps -eo pid,ppid,cmd | awk '$2 == 1'
		 ;;

	 listZombieProcess)
		 ps -eo pid,ppid,state,cmd | awk '$3=="Z"'
		 ;;

	 killProcess)
		 PID=$2
		 kill -9 $2
		 ;;

	 listWaitingProcess)
		 ps -eo pid,stat,cmd | grep ' D '
		 ;;

esac 

