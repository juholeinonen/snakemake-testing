# Parameters and filepaths
configfile: "config.yaml"

rule all:
  input:
    expand("{speaker}_train/text", speaker=config["speakers"].values())


# Selecting all the audio files with certain ID/speaker from the complete list
rule select_speaker_files_from_wav_scp:
  input:
    wav=config["files"]["wav"]
  output:
    wav="{speaker}_wav.scp"
  shell:
    'grep "{wildcards.speaker}" {input.wav} > {output.wav}'


# Selecting the transcriptions with certain ID/speaker from the complete list
rule select_speaker_files_from_trn:
  input:
    trn=config["files"]["trn"]
  output:
    trn="{speaker}_trn.txt"
  shell:
    'grep "{wildcards.speaker}" {input.trn} > {output.trn}'


# Selecting certain amount of files (in seconds) from the ID/speaker specific scp file
rule select_x_second_amount_of_wavs:
  input:
    wav="{speaker}_wav.scp",
    script="scripts/takeXseconds.py",
  output:
    wav="{speaker}_wav_seconds.scp"
  params:
    seconds=config["params"]["seconds"]
  shell:
    "{input.script} {input.wav} {output.wav} {params.seconds}"


# Selecting the matching transcipts to the smaller (x seconds) scp file
rule select_transcripts_for_seconds_wav_list:
  input:
    wav="{speaker}_wav_seconds.scp",
    trn="{speaker}_trn.txt",
    script="scripts/takeXtranscripts.py"
  output:
    trn="{speaker}_trn_seconds.txt"
  shell:
   "{input.script} {input.trn} {output.trn} {input.wav}" 


# Creating speaker/ID specific directories with other necessary files for Kaldi
rule create_speaker_folders:
  input:
    trn="{speaker}_trn_seconds.txt", 
    wav="{speaker}_wav_seconds.scp",
    script="scripts/createKaldiFiles.py"
  output:
    text="{speaker}_train/text",
    utt2spk="{speaker}_train/utt2spk",
    spk2utt="{speaker}_train/spk2utt",
    wav="{speaker}_train/wav.scp"
  shell:
    """
    rm -f {wildcards.speaker}_train
    mkdir {wildcards.speaker}_train
    {input.script} {wildcards.speaker}_train {input.trn}
    cp {output.utt2spk} {output.spk2utt}
    mv {input.wav} {output.wav}
    """
