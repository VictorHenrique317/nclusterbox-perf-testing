FROM ubuntu

COPY . /app

WORKDIR /app/nclusterbox
RUN apt update && apt install -y make
RUN sudo apt-get install -y g++
RUN make install

WORKDIR /app