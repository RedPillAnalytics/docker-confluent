FROM adoptopenjdk:8-jdk-hotspot

ENV CONFLUENT_HOME=/confluent \
    CONFLUENT_BASE=5.5 \
    CONFLUENT_VERSION=5.5.1 \
    SCALA_VERSION=2.12 \
    CONFLUENT_CURRENT=/confluent/data \
    PATH="$PATH:.:/confluent/bin"

# apt-get dependencies
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install wget curl zip -y

# install confluent
RUN curl -O http://packages.confluent.io/archive/${CONFLUENT_BASE}/confluent-community-${CONFLUENT_VERSION}-${SCALA_VERSION}.zip \
    && unzip confluent-community-${CONFLUENT_VERSION}-${SCALA_VERSION}.zip \
    && mv confluent-${CONFLUENT_VERSION} /confluent \
    # install confluent cli
    && curl -L --http1.1 https://cnfl.io/cli | sh -s -- -b /usr/local/bin \
    && mkdir -p ${CONFLUENT_CURRENT} \
    && confluent update

RUN confluent local start kafka > /dev/null \
    && ksql-datagen quickstart=clickstream_codes format=json topic=clickstream_codes maxInterval=1 iterations=100 > /dev/null  \
    && ksql-datagen quickstart=clickstream_users format=json topic=clickstream_users maxInterval=1 iterations=1000 > /dev/null \
    && ksql-datagen quickstart=clickstream format=json topic=clickstream maxInterval=1 iterations=100000 > /dev/null \
    && confluent local stop

ADD entrypoint.sh .

ENTRYPOINT entrypoint.sh
