FROM ubuntu:22.04

ENV ETL_PATH /root/etlegacy
ENV ETL_FOLDER etlegacy-v2.80.2-i386
ENV ETL_FILENAME $ETL_FOLDER.tar.gz
ENV ETL_URL https://www.etlegacy.com/download/file/410
ENV PAK_MIRROR http://spongeserv.com/et/

RUN dpkg --add-architecture i386
RUN apt-get update -y && apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386
# RUN apt-get install -y multiarch-support

RUN apt-get install -y wget
RUN wget -nv -O $ETL_FILENAME $ETL_URL
RUN tar -xzf $ETL_FILENAME && rm -f $ETL_FILENAME
RUN mv $ETL_FOLDER $ETL_PATH

WORKDIR $ETL_PATH/etmain
RUN wget -nv $PAK_MIRROR/pak0.pk3 \
             $PAK_MIRROR/pak1.pk3 \
             $PAK_MIRROR/pak2.pk3 \
             $PAK_MIRROR/mp_bin.pk3 \
             $PAK_MIRROR/qagame.mp.i386.so

COPY etl_server.cfg $ETL_PATH/etmain/
ARG REF_PASSWORD
ARG RCON_PASSWORD
ARG ET_HOSTNAME
RUN sed -i "s/__REFPASS__/$REF_PASSWORD/" $ETL_PATH/etmain/etl_server.cfg
RUN sed -i "s/__RCONPASS__/$RCON_PASSWORD/" $ETL_PATH/etmain/etl_server.cfg
RUN sed -i "s/__HOSTNAME__/$ET_HOSTNAME/" $ETL_PATH/etmain/etl_server.cfg

EXPOSE 27960/udp

WORKDIR $ETL_PATH

ENTRYPOINT ./etlded +set fs_game etmain +exec etl_server.cfg
