#!/bin/bash

decho() {
  echo "[$(date +"%Y-%m-%d %T %Z")] $1"
}

source venv/bin/activate

# We need the square brackets "[s]" to prevent `ps` from reporting its own process
NOHUP_PID=`ps -ef | grep [s]hared-notepad/venv | head -n 1 | awk -F ' ' '{print $2}'`
if [[ ! -z $NOHUP_PID ]]
then
  decho "Service is already running with PID=$NOHUP_PID"
  exit 0
fi

decho "Starting service.."
mkdir -p log
nohup waitress-serve --host 127.0.0.1 --port 5678 main:application >> log/shared_notepad_001.log &
deactivate
decho "Started service successfully"
