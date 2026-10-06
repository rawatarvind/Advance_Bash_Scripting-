#!/usr/bin/env bash
#
#if Statement 

if [[ 3 -gt 4 ]]; then 
	echo "This will nerver be printed"
fi 

# case Statement 

# Use case for clear branching when matching a variable against multiple patterns:
#
action="$1"

case "$action" in 
	start)
	    echo "Starting Service";;
	stop)
	    echo "Stoping Service";;
	restart) 
	    echo "Restarting Service";;
	*)
           echo "Usage: $0 {start|stop|restart}";;
esac

# while loop 

i=1 
while [[ $i -le 3 ]]; do
	echo "Iteration $i"
	i=$(( i+1 ))
done

# 2 For loop 
#
for i in {1..3}; do
	echo "Iteration $i"
done


