#!/usr/bin/env python3

# Althougth borrowed lots from psmit
__author__ = 'jpleino1'

import random
import wave
import sys

def main(wav_file, output_file, seconds):
    scp_list = [l.strip() for l in open(wav_file, encoding='utf-8').readlines() if len(l.strip()) > 0]
    random.seed(4554)
    random.shuffle(scp_list)
    rwav_file = open(output_file, "w", encoding='utf-8')    
    tot_seconds = 0.0
    broke = False

    for wav in scp_list:
        if tot_seconds > seconds:
            broke = True
            break
        with wave.open(wav) as wf:
            tot_seconds += wf.getnframes() / wf.getframerate()
        rwav_file.write(wav + "\n")    
    rwav_file.close()
    if not broke:
        print("Not enough seconds, got {} seconds".format(tot_seconds))

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2], int(sys.argv[3]))
