#!/bin/bash
set -e

function addLabel {
	if [ -z "$1" -o -z "$2" -o -z "$3" -o -z "$4" ]; then
		echo "Not enough arguments to addLabel"
		exit 1;
	fi
}

source "$1"
funcConfigPre
funcConfigPost

