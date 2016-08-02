#!/bin/bash

# Converts text files downloaded from project Gutenberg into UTF-8, and strips boilerplate (license, etc) from file

FILE=${1}
CHARSET=`dos2unix < ${FILE} | grep -a "Character set encoding: " | head -n 1 | cut -d":" -f 2 | cut -d" " -f 2-`

function convert {
    echo "Converting from $1 UTF-8"
    iconv -f $1 -t UTF-8 ${FILE} > ${FILE}.converted
    if [[ $? -ne 0 ]]; then
      echo "ERROR: conversion failed ($?), exiting."
      exit 1
    fi
    mv ${FILE}.converted ${FILE}
}

case $CHARSET in
  UTF-8)
    # good -- do nothing
    ;;
  "ISO Latin-1")
    convert "ISO-8859-1"
    ;;
  CP-1251)
    convert "WINDOWS-1251"
    ;;
  *)
    convert $CHARSET
    ;;
esac

START_LINE=`grep -a -n -E "\*\*\*.*START.*PROJECT GUTENBERG EBOOK" ${FILE} | cut -d":" -f 1`
END_LINE=`grep -a -n -E "\*\*\*.*END.*PROJECT GUTENBERG EBOOK" ${FILE} | cut -d":" -f 1`

START_LINE=`echo ${START_LINE}+1 | bc`
END_LINE=`echo ${END_LINE}-1 | bc`

echo "Extracting from ${START_LINE} to ${END_LINE}"
head -n ${END_LINE} ${FILE} | tail -n +${START_LINE} > ${FILE}.trimmed
mv ${FILE}.trimmed ${FILE}
