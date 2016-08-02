#!/bin/zsh

SRC='rsync://rsync.mirrorservice.org/gutenberg.org/'
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CORPUS=$(dirname $(dirname ${SCRIPT_DIR}))
DST=${CORPUS}/gutenberg

tail -n +2 ${CORPUS}/metadata/languages.csv | sed 's/,/\n/' | parallel -N 2 -P 0 "python3 manage.py --file-type txt --n-ebooks 1000000 --lang {2} --file-list ${DST}/lists/{1}"
sed -i "s/http:\/\/www.gutenberg.lib.md.us\///" ${DST}/lists/*

for code in `csvcut -c Ethnologue ${DST}/languages.csv | tail -n +2`; do
  mkdir -p ${DST}/${code}
  rsync -av --files-from=lists/${code}  ${SRC} ${DST}/downloaded/${code}
done

for file in ${DST}/downloaded/**/*.zip; do
  dir=`dirname ${file}`
  unzip -d ${dir} ${file}
  rm ${file}
done

# put all text files in one directory
for code in `csvcut -c Ethnologue ${DST}/languages.csv | tail -n +2`; do
  cd ${DST}/downloaded/${code}
  mv **/*.txt .
  rm -rf 0 1 2 3 4 5 6 7 8 9
done
