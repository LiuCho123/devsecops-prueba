FROM ubuntu:latest
LABEL authors="luise"

ENTRYPOINT ["top", "-b"]