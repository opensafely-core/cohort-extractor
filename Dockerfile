FROM ubuntu:bionic

RUN apt-get update
RUN apt-get install -y libpng16-16

RUN mkdir -p /work/bin
WORKDIR /work
COPY bin/ /work/bin/
COPY endpoint.sh /work/

CMD ["/work/endpoint.sh"]