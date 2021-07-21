#!/usr/bin/env python3

import os
import sys

def main(full_trn_list, filtered_trn_list, wav_list):
    grepped_trn_name = "grepped_trn_list"
    trn_name = "tmp_trn_list"
    wav_scp_name = os.path.join(output_dir, "wav.scp")

    utterance_IDs = [] 

    with open(grepped_trn_name, "r", encoding="utf-8") as greppedlist_file,\
        open(wav_scp_name, "r", encoding="utf-8") as wavlist_file,\
        open(trn_name, "w", encoding="utf-8") as trn_file:

        for line in wavlist_file:
            line_ID = os.path.splitext(os.path.basename(line))[0]
            utterance_IDs.append(line_ID)

        for line in greppedlist_file:
            line_parts = line.strip().split('(')

            line_ID = line_parts[1][:-1]
            if line_ID in utterance_IDs:
                trn_file.write(line)

if __name__ == "__main__":
	main(sys.argv[1])
