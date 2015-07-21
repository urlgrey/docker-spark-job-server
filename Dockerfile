# docker-spark-job-server
#
# VERSION 0.0.1

FROM urlgrey/docker-spark-postgresql-base
MAINTAINER Nick Poorman <mail@nickpoorman.com>

# Download the pre-built package
RUN cd / && \
    wget -qO- https://github.com/spark-jobserver/spark-jobserver/archive/v0.5.1.tar.gz | tar xz && \
    mv spark-jobserver-0.5.1 job-server && \
    cd job-server && \
    export VER=`sbt version | tail -1 | cut -f2` && \
    echo "SCALA_VERSION=2.10.5" > settings.sh

ADD run.sh /job-server/

WORKDIR /job-server

ENTRYPOINT ["/job-server/run.sh"]
