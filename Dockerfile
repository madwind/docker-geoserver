FROM openjdk:11
# The GS_VERSION argument could be used like this to overwrite the default:
# docker build --build-arg GS_VERSION=2.21.2 -t geoserver:2.21.2 .
ARG GS_VERSION=2.22.0
ARG GS_HOME=/opt/geoserver

ENV GEOSERVER_VERSION=$GS_VERSION
ENV GEOSERVER_HOME=$GS_HOME
ENV GEOSERVER_DATA_DIR=$GS_HOME/data_dir

# init
RUN apt update && \
    apt -y upgrade && \
    apt install -y --no-install-recommends unzip wget curl && \
    apt clean && \
    rm -rf /var/cache/apt/* && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

# install geoserver
RUN wget -q -O /tmp/geoserver.zip https://downloads.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/geoserver-$GEOSERVER_VERSION-bin.zip && \
    mkdir -p $GEOSERVER_HOME && \
    unzip -q geoserver.zip -d $GEOSERVER_HOME
    
# cleanup
RUN apt purge -y && \
    apt autoremove --purge -y && \
    rm -rf /tmp/*

# copy scripts
RUN chmod +x $GS_HOME/bin/*.sh

ENTRYPOINT $GS_HOME/bin/startup.sh

WORKDIR $GS_HOME
