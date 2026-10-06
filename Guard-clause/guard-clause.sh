#!/bin/bash

readonly FILE_PATH="/home/sarvind/gaurd_clause/file.txt"
readonly USER_NAME="admin"

run_process() {
	echo "running process ..."
}

if [[ "${USER_NAME}" != "admin" ]]; then
	echo "User is not admin"
	exit 1
fi

if [[ ! -e "${FILE_PATH}" ]]; then
	echo "file path does not exist."
	exit 1
fi

if [[ ! -s "${FILE_PATH}" ]]; then
	echo "File exists but empty"
	exit 1
fi

run_process

exit 0
