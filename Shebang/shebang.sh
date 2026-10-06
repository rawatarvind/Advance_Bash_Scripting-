#!/bin/bash

WORD="I don't have a shebang and still i run"


for word in "${WORD}"; do
	if [[ 2 < 3 ]]; then
		echo "${word}"
	fi
done
