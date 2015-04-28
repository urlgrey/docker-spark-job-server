# docker-spark-job-server
#
# VERSION 0.0.1

FROM nickpoorman/docker-mesos:0.0.1
MAINTAINER Nick Poorman <mail@nickpoorman.com>

# Don't care about the all the mesos crap that was installed for mesos. We only want the native lib
RUN find / -name \*mesos\* | perl -ne 'print if !/mesos(.*)\.(so|la|jar)/' | xargs rm -rf

# need sbt installed to build the job server
RUN echo "deb http://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list && \
    apt-get update && \
    apt-get install -y --force-yes \
      sbt

# Docker has a problem with long filenames, add this to the global.sbt settings:
RUN echo 'scalacOptions ++= Seq("-Xmax-classfile-name","240")' > /root/.sbt/0.13/global.sbt

# run sbt once to cache all the crap it needs
RUN sbt version

# download the job-server source
RUN mkdir /tmp/sjs && \
    cd /tmp/sjs && \
    wget -qO- https://github.com/nextglass/spark-jobserver/archive/v0.5.1-SNAPSHOT-4.27.2015.tar.gz | tar -xz --strip-components=1

# build the job-server
RUN cd /tmp/sjs && \
    : ${SCALA_VERSION:=2.10.5} && \
    : ${SPARK_HOME:=/tmp/spark} && \
    printf "SCALA_VERSION=${SCALA_VERSION}\nSPARK_HOME=${SPARK_HOME}\n" > config/env.sh && \
    _JAVA_OPTIONS=$(cat .jvmopts) && \
    ./bin/server_package.sh env

WORKDIR /tmp/job-server

ADD run.sh /tmp/job-server/

ENTRYPOINT ["/tmp/job-server/run.sh"]
