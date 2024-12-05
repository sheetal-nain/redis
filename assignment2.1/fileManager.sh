#!/bin/bash
set -ex
action=$1
path=$2
dir=$3

case ${action} in
# To create a directory.
	addDir)                                                                                     
		mkdir $path/$dir                                                                    
		;;
# To list files.
	listFiles)
	        find $path -maxdepth 1 -type f
		;;
# To list directories.
	listDirs)
	        find $path -maxdepth 1 -type d
		;;
# To list all files and directories.       
       	listAll)
		ls -a $path
		;;
# To delete a directory.
	deleteDir)
		rm -r $path/$dir
		;;
# To create a file.                                                                          
	addFile)                                                                           
		file=$4
		touch $path/$dir

		;;
# To add content to a file.
	addContent)                                     

		content=$4
		echo "$4" > $path/$dir
		;;
# To add additional content to a file.
	addContentToFile)
		for line in {1..9}
		do
		echo "$line" >> $path/$dir
	done
		;;
# To add content to the beginning of the file.
	addContentToFileBeginning)                
		content=$4                              
		cd /tmp/dir1
		touch todo.txt
		echo "$4" | cat - $dir > /tmp/dir1/todo.txt && mv todo.txt $path/$dir                       
		#cat $path/$dir >> $path/$5
		#mv $path/$5 $path/$dir
		;;
# To show first lines of the file.
	showFileBeginningContent)
		n=$5
	        head -n $4 $path$dir                                   
		;;
# To show last lines of the file.                                      
	showFileEndContent)
		n=$5
		tail -n $4 $path/$dir                                       
		;;
# To show content at a particular line.                                     
	showFileContentAtLine)
		n=$5
		head -$5 $path/$dir/$4  | tail -1                          
		;;
# To show content for line range in a file.
	showFilteContentForLineRange)                             
		n=$5                                              

		head -$5 $path/$dir/$4 | tail -4
		;;
# To rename a file.                                                     
       	renameFile)                                                   
		sourcePath=$2
		destinationPath=$3
		mv $sourcePath $destinationPath
	       ;;
# To move a file to a different location.      
       moveFile)                                                   
	       sourcepath=$2
	       destinationpath=$3
	       mv $sourcepath $destinationpath
	       ;;
# To copy a file to a different location.      
       copyFile)                                                                   
	       sourcepath=$2
	       destinationpath=$3
	       cp $sourcepath $destinationpath
	       ;;
# To copy a file.     
       copyFile)                                                   

	       sourcepath=$2
	       destinationpath=$3
	       cp $sourcepath $destinationpath
	       ;;
# To clear the content of a file.      
       clearFileContent)                                                      
	       filepath=$2
	       truncate -s 0 $filepath
	       ;;
# To delete a file.                                                                    
       deleteFile)                                                                  
	       filepath=$2
	       rm -rf $filepath
	       ;;
       *)
	       echo"please provide valid inpit"
	       ;;
	       
       esac


	       
	       






		
		


