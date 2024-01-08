#!/bin/bash

kadmin -p admin/admin -w admin -q "addprinc -randkey test_user/$(hostname -f)@DEITOS.NETWORK"
kadmin -p admin/admin -w admin -q "xst -k /home/jovyan/keytabs/current-jupyter.keytab test_user/$(hostname -f)@DEITOS.NETWORK HTTP/localhost"

kinit -kt /home/jovyan/keytabs/current-jupyter.keytab test_user/$(hostname -f)@DEITOS.NETWORK

echo "Starting jupyter notebook -\-/- ..."
export PATH="/home/jovyan/venv/bin:$PATH"

jupyter --config-dir
jupyter notebook --generate-config
jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --NotebookApp.token='' --notebook-dir=/home/jovyan/work 
