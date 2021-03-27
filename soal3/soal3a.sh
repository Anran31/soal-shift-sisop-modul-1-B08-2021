#!/bin/bash

for i in {1..23}; do
    wget -a Foto.log https://loremflickr.com/320/240/kitten -O "Koleksi_$i"
    maxCheck=$((i-1))
    for (( a=1; a<=maxCheck; a++ ))
    do
	if [ -f Koleksi_$a ]; then
           if comm Koleksi_$a Koleksi_$i &> /dev/null;
	      then rm Koleksi_$i
	           break;
	   fi
	fi 
    done
done

for i in {1..23}; do
    if [ ! -f Koleksi_$i ]; then
       for (( j=23; j>i; j-- ))
       do
	   if [ -f Koleksi_$j ]; then
	      mv Koleksi_$j Koleksi_$i
	      break
	   fi
       done
     fi
done

for i in {1..9}; do
    if [ -f Koleksi_$i ]; then
       mv Koleksi_$i Koleksi_0$i
    fi
done