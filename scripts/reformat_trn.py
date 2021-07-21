#!/usr/bin/env python3

import os
import sys


def main(output_dir):
    tmp_trn_name = "tmp_trn_list"
    trn_name = os.path.join(output_dir, "text")
    utt2spk_name = os.path.join(output_dir, "utt2spk")

    with open(tmp_trn_name, "r", encoding="utf-8") as trnlist_file,\
        open(trn_name, "w", encoding="utf-8") as trn_file,\
        open(utt2spk_name, "w", encoding="utf-8") as utt2spk_file:

        for line in trnlist_file:
            line = line.strip()
            line = line.split('(')

            line_utterance = line[0].strip()
            line_utterance = line_utterance.replace("[reject]", "<UNK>")

            line_ID = line[1][:-1]

            utt2spk_file.write(line_ID + " " + line_ID + "\n")
            trn_file.write(line_ID + " " + line_utterance + "\n")

if __name__ == "__main__":
	main(sys.argv[1])
