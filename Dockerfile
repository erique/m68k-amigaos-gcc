# docker build --platform linux/amd64 -t m68k-amigaos-gcc .
# docker tag m68k-amigaos-gcc trixitron/m68k-amigaos-gcc
# docker push trixitron/m68k-amigaos-gcc

FROM ubuntu:latest AS builder

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update -y && \
    apt install -y make wget git gcc g++ lhasa libgmp-dev libmpfr-dev \
                   libmpc-dev flex bison gettext texinfo ncurses-dev  \
                   autoconf rsync libreadline-dev

RUN git config --global pull.ff only

RUN git clone https://github.com/bebbo/amiga-gcc && \
    cd amiga-gcc && make update && make all all-sdk -j8

FROM ubuntu:latest

COPY --from=builder /opt/amiga /opt/amiga

RUN apt-get -y update && \
    apt-get -y install make git libmpc3 libmpfr6 libgmp10

ENV PATH /opt/amiga/bin:$PATH
