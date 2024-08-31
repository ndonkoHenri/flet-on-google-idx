#!/bin/sh

# activate venv
source $VENV_DIR/bin/activate

# run app in hot reload mode
flet run main.py --web --port $PORT
