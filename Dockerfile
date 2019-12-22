FROM adoptopenjdk:8-jdk-hotspot
ENV CONFLUENT_HOME=/confluent

# apt-get dependencies
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install software-properties-common apt-utils wget curl zip gnupg -y

# install confluent
RUN wget -qO - http://packages.confluent.io/deb/3.1/archive.key | apt-key add -
RUN add-apt-repository "deb [arch=amd64] http://packages.confluent.io/deb/3.1 stable main"
RUN apt-get -y install confluent-platform-oss-2.11

# install confluent cli
RUN curl -L https://cnfl.io/cli | sh -s -- -b /usr/local/bin
RUN confluent update

# RUN confluent local start
# RUN ksql-datagen quickstart=clickstream_codes format=json topic=clickstream_codes maxInterval=1 iterations=100
# RUN ksql-datagen quickstart=clickstream_users format=json topic=clickstream_users maxInterval=1 iterations=1000
# RUN ksql-datagen quickstart=clickstream format=json topic=clickstream maxInterval=1 iterations=100000

ENTRYPOINT bash
