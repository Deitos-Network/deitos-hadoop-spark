#!/bin/bash

echo "Starting jupyter notebook -\-/- ..."0
export PATH="/home/$USERNAME/venv/bin:$PATH"
# jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --NotebookApp.token='' --notebook-dir=/home/jupyter/notebook

# rm -fr /home/jupyter/.jupyter
jupyter --config-dir
jupyter notebook --generate-config
jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --NotebookApp.token='' --notebook-dir=/home/jupyter/notebook
#  --notebook-dir='./notebook' --no-browser --NotebookApp.token='' 

# exec "$@"