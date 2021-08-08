#!/usr/bin/env python3

import os
import sys

def main(grepped_trn_list, filtered_trn_list, wav_list):

    utterance_IDs = [] 

    with open(grepped_trn_list, "r", encoding="utf-8") as grepped_trn_file,\
        open(wav_list, "r", encoding="utf-8") as wav_list_file,\
        open(filtered_trn_list, "w", encoding="utf-8") as trn_file:

        for line in wav_list_file:
            line_ID = os.path.splitext(os.path.basename(line))[0]
            utterance_IDs.append(line_ID)

        for line in grepped_trn_file:
            line_parts = line.strip().split('(')

            line_ID = line_parts[1][:-1]
            if line_ID in utterance_IDs:
                trn_file.write(line)

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2], sys.argv[3])
