#!/bin/bash

decho() {
  echo "[$(date +"%Y-%m-%d %T %Z")] $1"
}

# We need the square brackets "[s]" to prevent `ps` from reporting its own process
NOHUP_PID=`ps -ef | grep [s]hared-notepad/venv | head -n 1 | awk -F ' ' '{print $2}'`
if [[ ! -z $NOHUP_PID ]]
then
  decho "Killing PID=$NOHUP_PID.."
  kill $NOHUP_PID
  while kill -0 $NOHUP_PID 2> /dev/null; do
    sleep 1
  done
  decho "PID=$NOHUP_PID killed.."
fi

decho "Stopped service succesfully"
