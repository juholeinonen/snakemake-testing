configfile: "config.yaml"

rule all:
  input:
    expand("{speaker}_wav-list", speaker=config["speakers"].values())

rule select_speaker_files:
  input:
    wav=config["files"]["wavs"]
  output:
    speaker="{speaker}_wav-list"
  shell:
    'grep "{wildcards.speaker}" {input.wav} > {output.speaker}'
