SHELL := /bin/bash

reinstall: clean
	./bin/reinstall_ilab.sh

clean:
	rm -rf work

init:
	mkdir -p work
	mkdir -p models
	cd work && ilab config init --non-interactive --taxonomy-path taxonomy --repository https://github.com/instructlab/taxonomy.git --min-taxonomy
	rsync -r -v models work
	cd work && ilab model download

generate:
	rsync -r -v taxonomy work
	cd work && ilab taxonomy diff
	cd work && ilab data generate

trainmac:
	cd work && ilab model train
	cd work && ilab model test
	cd work && ilab model convert

traincuda:
	cd work && ilab train --device cuda

serve_default:
	cd work && ilab model serve --model-path models/merlinite-7b-lab-Q4_K_M.gguf

all: init generate train
