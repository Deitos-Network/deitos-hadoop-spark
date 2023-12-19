FROM python:3.9

WORKDIR /app

# RUN DEBIAN_FRONTEND=noninteractive
# RUN apt-get -y update && apt-get upgrade -y
# RUN apt-get install -y tzdata software-properties-common

# Install Miniconda and PyTorch + CUDA 11.8
# RUN curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
# RUN sh Miniconda3-latest-Linux-x86_64.sh -b -p ./miniconda
# RUN miniconda/bin/conda install llama-cpp-python Flask
# RUN miniconda/bin/conda install pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia

# Install required python packages
# RUN pip install -U scipy sentencepiece protobuf uvicorn fastapi bitsandbytes
# RUN pip install -U git+https://github.com/huggingface/transformers.git git+https://github.com/huggingface/accelerate.git

COPY ./llama_cpu_server.py /app/llama_cpu_server.py
COPY ./model/llama-2-7b-chat.Q2_K.gguf /app/llama-2-7b-chat.Q2_K.gguf

RUN pip install llama-cpp-python
RUN pip install Flask

# CMD ["python", "llama_cpu_server.py"]

# Copy source files
# COPY . /app

# ENTRYPOINT ["/app/run.sh"]
COPY run.sh /app/run.sh
RUN chmod a+x /app/run.sh
CMD ["/app/run.sh"]