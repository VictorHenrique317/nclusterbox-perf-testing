FROM ubuntu

RUN apt-get update
RUN apt-get install -y python3 python3-pip
RUN pip3 install matplotlib
RUN pip install numpy
RUN pip install scipy

RUN apt-get install -y make
RUN apt-get install -y libboost-all-dev
RUN apt-get install -y g++

COPY . /app
WORKDIR /app/nclusterbox
RUN make install

WORKDIR /app