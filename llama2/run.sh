#!/bin/bash

echo "Starting Llama2  -\-/- ..."
# uvicorn main:app --host 0.0.0.0 --port 7860
python llama_cpu_server.py
while true; do sleep 1000; done
