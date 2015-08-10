#!/bin/bash
mkdir -p work
mkdir -p out

CUR_DIR=$(pwd)

WAV_DIR=$1
TXT_DIR=$2

MODEL=/l/psmit/test_alignment/model/models/saami2015_BN_dev_AM_12000_18.5.2015_22

RECIPE=work/recipe_$RANDOM
> $RECIPE

for txt in $(ls -1 $TXT_DIR/*.txt); do
    b=`basename $txt .txt`
    ./parse_transcripts.py $txt work/${b}.phn out/${b}.trn
    echo "audio=${WAV_DIR}/${b}.wav transcript=work/${b}.phn alignment=work/${b}.aligned" >> $RECIPE
done

align -b $MODEL -c ${MODEL}.cfg -r $RECIPE --beam=2000 --sbeam=2000 --phoseg -i 1

for txt in $(ls -1 $TXT_DIR/*.txt); do
b=`basename $txt .txt`
./split_files.py work/${b}.aligned ${WAV_DIR}/${b}.wav out
done