configfile: "config.yaml"

rule all:
  input:
    expand("{speaker}_train/text", speaker=config["speakers"].values())

rule select_speaker_files_from_wav_list:
  input:
    wav=config["files"]["wav"]
  output:
    wav="{speaker}_wav_list"
  shell:
    'grep "{wildcards.speaker}" {input.wav} > {output.wav}'

rule select_speaker_files_from_trn_list:
  input:
    trn=config["files"]["trn"]
  output:
    trn="{speaker}_trn_list"
  shell:
    'grep "{wildcards.speaker}" {input.trn} > {output.trn}'

rule select_x_second_amount_of_wavs:
  input:
    wav="{speaker}_wav_list",
    script="scripts/takeXseconds.py",
  output:
    wav="{speaker}_wav_list_seconds"
  params:
    seconds=config["params"]["seconds"]
  shell:
    "{input.script} {input.wav} {output.wav} {params.seconds}"

rule select_transcripts_for_seconds_wav_list:
  input:
    wav="{speaker}_wav_list_seconds",
    trn="{speaker}_trn_list",
    script="scripts/fix_trn.py"
  output:
    trn="{speaker}_trn_list_seconds"
  shell:
   "{input.script} {input.trn} {output.trn} {input.wav}" 

rule create_speaker_folders:
  input:
    trn="{speaker}_trn_list_seconds", 
    wav="{speaker}_wav_list_seconds",
    script="scripts/reformat_trn.py"
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
