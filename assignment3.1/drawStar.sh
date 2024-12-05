#!/bin/bash


size=$1
type=$2

case ${type} in

t1)
# To add rows.
	for ((i=1; i<=5; i++)); do

# To print spaces.		
	for ((k=1;k<=(5-i);k++)); do
        printf "%s" " ";
done;

# To print stars.
        for ((j=1;j<=i;j++)); do
  	printf  "%s" "*"                                
done;
        printf "\n"
done;
;;


t2)
		
# To add rows.
	for ((i=1; i<=5; i++)); do
       
# To print stars.	       
	for ((j=1; j<=i; j++)); do
	printf "%s" "*"
done;
	printf "\n"
done;
;;

t3)

# To add rows.	
	for ((i=1; i<=9; i+=2)); do

# To print spaces.	
	for ((j=i; j<=9; j+=2)); do
	printf " "
done;

# To print stars.
	for ((k=1; k<=2*i-1; k+=2)); do
	printf "*"
done;
	printf "\n"
done;
;;

t4) 
 
# To add rows.
       for ((i=5; i>=1; i--)); do

# To print stars.
        for ((j=i; j>=1; j--)); do
        printf "%s" "*"
done;
        printf "\n"
done;
;;

t5)

# To add rows.	
       for ((i=5; i>=1; i--)); do

# To print spaces.      
       for ((j=1; j<=5-i; j++)); do
        printf " "
done;

# To print stars.
        for ((k=i; k>=1; k--)); do
        printf "*"
done;
        printf "\n"
done;
;;

t6)

# To add rows.	
       for ((i=9; i>=1; i-=2)); do

# To print spaces.      
        for ((j=i; j<=9; j+=2)); do
        printf " "
done;

# To print stars.
        for ((k=1; k<=2*i-1; k+=2)); do
        printf "*"
done;
        printf "\n"
done;
;;

t7)

# To add top rows.
       for ((i=1; i<=9; i+=2)); do

# To print spaces.      
        for ((j=i; j<=9; j+=2)); do
        printf " "
done;

# To print stars.
        for ((k=1; k<=2*i-1; k+=2)); do
        printf "*"
done;
        printf "\n"
done;

# To add bottom rows.
       for ((i=7; i>=1; i-=2)); do

# To print spaces.      
        for ((j=i-2; j<=7; j+=2)); do
        printf " "
done;

# To print stars.
        for ((k=1; k<=2*i-1; k+=2)); do
        printf "*"
done;
        printf "\n"
done;




esac

