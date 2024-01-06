FROM python:3.9

WORKDIR /app

COPY ./llama_cpu_server.py /app/llama_cpu_server.py
RUN wget https://huggingface.co/TheBloke/Llama-2-7B-Chat-GGUF/resolve/main/llama-2-7b-chat.Q2_K.gguf?download=true -O /app/llama-2-7b-chat.Q2_K.gguf

RUN pip install llama-cpp-python
RUN pip install Flask

COPY run.sh /app/run.sh
RUN chmod a+x /app/run.sh
CMD ["/app/run.sh"]