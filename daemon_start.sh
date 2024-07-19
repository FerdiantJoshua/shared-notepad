#!/bin/bash

cd {{path_to_directory}}

source venv/bin/activate

mkdir -p log
touch text.txt
touch key.txt

nohup waitress-serve --host 127.0.0.1 --port 5678 main:application >> log/shared_notepad_001.log &

deactivate
