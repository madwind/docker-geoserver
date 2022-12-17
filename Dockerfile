FROM openjdk:11
# The GS_VERSION argument could be used like this to overwrite the default:
# docker build --build-arg GS_VERSION=2.21.2 -t geoserver:2.21.2 .
ARG GS_VERSION=2.22.0
ARG GS_HOME=/opt/geoserver

ENV GEOSERVER_HOME=$GS_HOME
ENV GEOSERVER_DATA_DIR=$GS_HOME/data_dir

# init
RUN apt update && \
    apt -y upgrade && \
    apt install -y --no-install-recommends unzip wget curl && \
    apt clean && \
    rm -rf /var/cache/apt/* && \
    rm -rf /var/lib/apt/lists/* && \
    wget -q -O /tmp/geoserver.zip https://downloads.sourceforge.net/project/geoserver/GeoServer/$GS_VERSION/geoserver-$GS_VERSION-bin.zip && \
    mkdir -p $GS_HOME && \
    unzip -q /tmp/geoserver.zip -d $GS_HOME && \
    apt purge -y && \
    apt autoremove --purge -y && \
    rm -rf /tmp/* && \
    chmod +x $GS_HOME/bin/*.sh && \
    sed -i '137d;158d;189d;194d' $GS_HOME/webapps/geoserver/WEB-INF/web.xml

WORKDIR $GS_HOME

EXPOSE 8079

ENTRYPOINT $GEOSERVER_HOME/bin/startup.sh

