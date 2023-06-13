FROM ubuntu

COPY . /app

WORKDIR /app/nclusterbox
RUN pip install matplotlib
RUN pip install numpy
RUN pip install scipy

RUN apt-get update && apt-get install -y make
RUN apt-get install -y libboost-all-dev
RUN apt-get install -y g++
RUN make install

WORKDIR /app