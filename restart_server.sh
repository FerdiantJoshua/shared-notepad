#!/bin/bash

decho() {
  echo "[$(date +"%Y-%m-%d %T %Z")] $1"
}

source venv/bin/activate

# We need the square brackets "[s]" to prevent `ps` from reporting its own process
NOHUP_PID=`ps -ef | grep [s]hared-notepad/venv | head -n 1 | awk -F ' ' '{print $2}'`
if [[ ! -z $NOHUP_PID ]]
then
  kill $NOHUP_PID
  decho "PID=$NOHUP_PID killed.."
fi

decho "Starting service.."
mkdir -p log
touch text.txt
touch key.txt
nohup waitress-serve --host 127.0.0.1 --port 5678 main:application >> log/shared_notepad_001.log &
deactivate
decho "Restarted service successfully"
