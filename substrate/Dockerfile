# This is an example build stage for the node template. Here we create the binary in a temporary image.


# This is a base image to build substrate nodes
FROM docker.io/paritytech/ci-linux:production as builder

RUN git clone https://github.com/Deitos-Network/deitos-node.git 
RUN mv deitos-node /node-template 

WORKDIR /node-template

RUN rm -rf /usr/local/rustup /usr/local/cargo && \
    curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain none && \
    rustup show && \
    cargo build --release

# This is the 2nd stage: a very small image where we copy the binary."
FROM docker.io/library/ubuntu:20.04
LABEL description="Multistage Docker image for Substrate Node Template" \
  image.type="builder" \
  image.authors="you@email.com" \
  image.vendor="Substrate Developer Hub" \
  image.description="Multistage Docker image for Substrate Node Template" \
  image.source="https://github.com/substrate-developer-hub/substrate-node-template" \
  image.documentation="https://github.com/substrate-developer-hub/substrate-node-template"


# Copy the node binary.
COPY --from=builder /node-template/target/release/deitos-node /usr/local/bin

RUN useradd -m -u 1000 -U -s /bin/sh -d /node-dev node-dev && \
  mkdir -p /chain-data /node-dev/.local/share && \
  chown -R node-dev:node-dev /chain-data && \
  ln -s /chain-data /node-dev/.local/share/deitos-node && \
  # unclutter and minimize the attack surface
  rm -rf /usr/bin /usr/sbin && \
  # check if executable works in this container
  /usr/local/bin/deitos-node --version 


USER node-dev

EXPOSE 30333 9933 9944 9615
VOLUME ["/chain-data"]

ENTRYPOINT ["/usr/local/bin/deitos-node","--dev"]
