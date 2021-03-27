#!/bin/bash

cd /home/anran/sisop/shift1/soal3
dirName=$(date +"%d-%m-%Y")

if [ ! -d "$dirName" ]; then
    mkdir $dirName

    bash /home/anran/sisop/shift1/soal3/soal3a.sh
    mv Koleksi_{01..23} $dirName &> /dev/null
    mv Foto.log $dirName
fi
