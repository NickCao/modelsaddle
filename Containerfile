FROM quay.io/fedora/fedora:42 AS builder
RUN dnf install -y awk && dnf clean all -y
RUN curl -fsSL https://ollama.com/install.sh | sh

ARG MODELS
RUN <<PULL
OLLAMA_MODELS=/models ollama serve &
curl --retry 5 --retry-connrefused --silent --fail http://localhost:11434
for MODEL in ${MODELS}
do
  ollama pull ${MODEL}
done
PULL

FROM scratch
COPY --from=builder --chown=0:0 --chmod=444 /models /models
