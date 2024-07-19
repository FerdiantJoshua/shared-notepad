#!/bin/bash

decho() {
  echo "[$(date +"%Y-%m-%d %T %Z")] $1"
}

# We need the square brackets "[s]" to prevent `ps` from reporting its own process
NOHUP_PID=`ps -ef | grep [s]hared-notepad/venv | head -n 1 | awk -F ' ' '{print $2}'`
if [[ ! -z $NOHUP_PID ]]
then
  kill $NOHUP_PID
  decho "PID=$NOHUP_PID killed.."
else
  decho "Service is not running"
  exit 0
fi

decho "Stopped service succesfully"
