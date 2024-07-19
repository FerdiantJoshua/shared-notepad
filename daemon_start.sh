#!/bin/bash

source {{path_to_directory}}/venv/bin/activate
nohup waitress-serve --host 127.0.0.1 --port 5678 main:application >> log/shared_notepad_001.log &
deactivate
