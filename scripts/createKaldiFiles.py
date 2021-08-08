#!/usr/bin/env python3

import os
import sys


def main(output_dir, trn_name):
    text_name = os.path.join(output_dir, "text")
    utt2spk_name = os.path.join(output_dir, "utt2spk")
    spk2utt_name = os.path.join(output_dir, "spk2utt")

    with open(trn_name, "r", encoding="utf-8") as trn_file,\
        open(text_name, "w", encoding="utf-8") as text_file,\
        open(utt2spk_name, "w", encoding="utf-8") as utt2spk_file,\
        open(spk2utt_name, "w", encoding="utf-8") as spk2utt_file:

        for line in trn_file:
            line = line.strip()
            line = line.split('(')

            line_utterance = line[0].strip()
            line_utterance = line_utterance.replace("[reject]", "<UNK>")

            line_ID = line[1][:-1]

            utt2spk_file.write(line_ID + " " + line_ID + "\n")
            spk2utt_file.write(line_ID + " " + line_ID + "\n") # Are the same
            text_file.write(line_ID + " " + line_utterance + "\n")

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
