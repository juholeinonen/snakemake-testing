#!/bin/bash

script_location=/teamwork/t40511_asr/p/forced-alignment/recipes/create_speaker_data
trn_file=/teamwork/t40511_asr/c/estonian-speech/train.verbatim.trn
wav_list=/teamwork/t40511_asr/c/estonian-speech/train.wav-list
seconds=1000

for speaker in Andres_Laansoo A_Ots_loeng Helina_Vigla Janek_Popell Maarja_Kruusmaa Margit_Suurna Mati_Jarvis Rillo_loeng Tea_Hunt_KG_Loeng; do
  mkdir "$speaker"
  cd "$speaker"
  cp "$script_location"/* .
  chmod +x prepSpeakerX.sh
  ./prepSpeakerX.sh "$speaker" "$trn_file" "$wav_list" "$seconds"
  cd ..
done
