configfile: "config.yaml"

rule all:
  input:
    expand("{speaker}_trn_list_seconds", speaker=config["speakers"].values())

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
    speaker="{speaker}_trn_list",
    script="scripts/fix_trn.py"
  output:
    trn="{speaker}_trn_list_seconds"
  shell:
   "{input.script} {input.speaker} {output.trn} {input.wav}" 
