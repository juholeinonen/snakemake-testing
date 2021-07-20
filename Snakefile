configfile: "config.yaml"

# Trying to replicate stackoverflow answer
speakers = {
  "1": "And_Laa",
  "2": "A_log"
}

def get_speaker(wildcards):
#  return expand("{speaker}", speaker=config["speakers"]) 
  return speakers[wildcards.speaker]

rule all:
  input:
#    expand("{speaker}_wav-list", speaker=config[speakers])
    expand("{speaker}", speaker=speakers.values())

# Selecting all the audiofiles for the speakers from a very large file
rule select_speaker_files:
  input:
    wav=config["files"]["wavs"]
  output:
    speaker="{speaker}_wav-list"
  params:
    speaker=get_speaker,
  shell:
    'grep "{params.speaker}" {input.wav} > {output.speaker}'
