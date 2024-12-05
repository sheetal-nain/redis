#!/bin/bash

set -x

num=$1

for i in ${num}; do
           if    
	        ([ `expr $num % 15` == 0 ])
       then
               echo "tomcat"
                      
       elif
               ([ `expr $num % 3` == 0 ])                             

	then
	       echo "tom"

       elif
	       ([ `expr $num % 5` == 0 ])                             
       then 
	       echo "cat"

       else
		echo "no matches found"

      
	   fi
done

