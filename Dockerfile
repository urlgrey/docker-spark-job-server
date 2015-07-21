# docker-spark-job-server
#
# VERSION 0.0.1

FROM nickpoorman/docker-mesos
MAINTAINER Nick Poorman <mail@nickpoorman.com>

# Don't care about the all the mesos crap that was installed for mesos. We only want the native lib
RUN find / -name \*mesos\* | perl -ne 'print if !/mesos(.*)\.(so|la|jar)/' | xargs rm -rf

# Download the pre-built package
RUN cd / && \
    wget -qO- https://github.com/spark-jobserver/spark-jobserver/archive/v0.5.1.tar.gz | tar xz && \
    mv spark-jobserver-0.5.1 job-server && \
    cd job-server && \
    export VER=`sbt version | tail -1 | cut -f2`

ADD run.sh /job-server/

WORKDIR /job-server

ENTRYPOINT ["/job-server/run.sh"]
