#!/bin/bash

if [ $# != 1 ]; then
  echo "You're doing this wrong"
  exit 1;
fi

speaker=$1

cleanup="true"

cut -f 2- -d ' ' "$speaker"/wav.scp > "$speaker"_cp_wavs.sh
sed -i "s/^/cp /; s/$/ \/tmp\/$speaker/" "$speaker"_cp_wavs.sh
chmod +x "$speaker"_cp_wavs.sh
./"$speaker"_cp_wavs.sh

tar czf "$speaker"_wavs.tar.gz -C /tmp/"$speaker" .

if [ "$cleanup" = "true" ];
then
  rm "$speaker"_cp_wavs.sh
  rm -r /tmp/"$speaker"
fi
