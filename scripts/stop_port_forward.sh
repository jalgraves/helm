#!/bin/bash

PID=$(ps | grep "${1}:${1}" | grep -v 'grep' | awk '{print $1}')

if [[ ! -z ${PID} ]]; then
    kill ${PID}
fi
