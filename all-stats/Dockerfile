FROM ubuntu

COPY . /app

WORKDIR /app/nclusterbox
RUN apt update && apt install -y make
RUN apt install -y g++
RUN make install

WORKDIR /app