#!/bin/bash

if [ $# != 4 ]; then
  echo "You're doing this wrong"
  exit 1;
fi

speaker=$1
trn_list=$2
wav_list=$3
seconds=$4

cleanup="true"

mkdir "$speaker"
mkdir /tmp/"$speaker"

grep "$speaker" "$wav_list" > tmp_wav_list.scp
python takeXseconds.py tmp_wav_list.scp "$speaker"/wav.scp "$seconds" 

grep "$speaker" "$trn_list" > grepped_trn_list
python fix_trn.py "$speaker"
python reformat_trn.py "$speaker"
cp "$speaker"/utt2spk "$speaker"/spk2utt

cut -f 2- -d ' ' "$speaker"/wav.scp > cp_wavs.sh
sed -i "s/^/cp /; s/$/ \/tmp\/$speaker/" cp_wavs.sh
echo "cp $speaker/text /tmp/$speaker" >> cp_wavs.sh
chmod +x cp_wavs.sh
./cp_wavs.sh

tar cvzf "$speaker"_wavs.tar.gz -C /tmp/"$speaker" .

wc -l "$speaker"/text
wc -l "$speaker"/wav.scp
wc -l "$speaker"/utt2spk

if [ "$cleanup" = "true" ];
then
  rm tmp_wav_list.scp
  rm grepped_trn_list
  rm tmp_trn_list
  rm cp_wavs.sh
  rm -r /tmp/"$speaker"
  rm -r "$speaker"
fi

