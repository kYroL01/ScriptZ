#!/usr/bin/env bash

#
# Nice way to ask a script listening on a named pipe to close without getting stuck writing if there's nothing listening.
# Useful if you don't know if the script is already running or there's an undeleted fifo.
#
# How to test:
# Run this script and in another terminal do:  echo 'hello' > ./myfifo

HardExit=
OnExit() {
	[[ $HardExit ]] && return
	rm -f "$PipeFilePath"
}

export PipeFilePath='./myfifo'
if [[ -e $PipeFilePath ]]; then
	[[ -p $PipeFilePath ]] && timeout 1 bash -c 'printf "%s" "EXIT" > "$PipeFilePath"'
	rm -f "$PipeFilePath"
fi
mkfifo "$PipeFilePath"
trap OnExit EXIT

while true; do
	read Message < "$PipeFilePath" || exit
	[[ $Message == 'EXIT' ]] && HardExit=1 && exit
	echo "$Message"
done
