FROM ubuntu

COPY . /app
WORKDIR /app

RUN apt update && apt install -y make
RUN make install