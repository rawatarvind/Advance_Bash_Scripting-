#!/usr/bin/env bash

string="One Two Three"
	
# Unquoted Expansion

# splits into words

for elements in ${string}; do 
	echo "${elements}"
done

# Quoted Expasion 

# preserves the entire string in one element
#
for elements in "${string}"; do
	echo "${elements}"
done


# Intentional Splitting
#
# Sometimes you want to iterate over each word in a list:

readonly SERVERS="server1 server2 server3"

for server in ${SERVERS}; do
	echo "${server}.example.com"

done

# Quoting the variable in this case treats the entire list as one element:

for server in "${SERVERS}"; do
	echo "${server}.example.com"
done


