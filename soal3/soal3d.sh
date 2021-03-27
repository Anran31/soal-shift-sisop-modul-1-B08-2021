#!/bin/bash

pass=$(date +"%m%d%Y")
cd /home/anran/sisop/shift1/soal3
for dirName in K*_*; do
	zip -q -P $pass -r Koleksi $dirName
        rm -r $dirName
        done