configfile: "config.yaml"

rule all:
  input:
    expand("{speaker}_wav-list", speaker=config["speakers"].values())

rule select_speaker_files_from_wav_list:
  input:
    wav=config["files"]["wavs"]
  output:
    speaker="{speaker}_wav-list"
  shell:
    'grep "{wildcards.speaker}" {input.wav} > {output.speaker}'

rule select_speaker_files_from_trn_list:
  input:
    trn=config["files"]["trn"]
  output:
    speaker="{speaker}_trn-list"
  shell:
    'grep "{wildcards.speaker}" {input.trn} > {output.speaker}'

rule select_x_second_amount_of_wavs:
  input:
    wav="{speaker}_wav-list"
    script="scripts/takeXseconds.py"
    seconds=config["params"]["seconds"]
  output:
    wav="{speaker}_{input.seconds}_seconds_wav_list"
  shell:
    "{input.script} {input.wav} {output.wav} {input.seconds}"

rule select_transcripts_for_seconds_wav_list:
  input:
    wav="{speaker_seconds}_seconds_wav_list"
    speaker="{speaker}_trn-list"
    script="scripts/fix_trn.py"
  output:
    trn="{speaker_seconds}_seconds_trn_list"
  shell:
   "{input.script} {input.speaker} {output.trn} {input.wav}" 
