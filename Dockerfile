FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install -y software-properties-common python-software-properties

RUN add-apt-repository ppa:openjdk-r/ppa
RUN apt-get update

RUN apt-get install -y openjdk-8-jdk
RUN apt-get install -y wget

RUN wget http://www.scala-lang.org/files/archive/scala-2.11.8.deb
RUN dpkg -i scala-2.11.8.deb
RUN echo "deb http://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823

RUN apt-get update

RUN apt-get install -y scala
RUN apt-get install -y sbt

ENV LC_ALL C.UTF-8

WORKDIR /app
RUN sbt clean

ENTRYPOINT ["/usr/bin/sbt"]
CMD clean
