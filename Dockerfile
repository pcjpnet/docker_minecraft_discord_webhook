FROM adoptopenjdk:16-jre

LABEL maintainer='https://github.com/pcjpnet/'

ENV MINECRAFT_VERSION=1.17
ENV MINECRAFT_JAR_SHA1=0a269b5f2c5b93b1712d0f5dc43b6182b9ab254e

ENV MINECRAFT_JAR=https://launcher.mojang.com/v1/objects/${MINECRAFT_JAR_SHA1}/server.jar
ENV JAVA_OPTIONS '-Xmx1024M -Xms1024M'

ENV WEBHOOK="" \
    TEXT_START="Minecraft Server Start" \
    TEXT_LOGIN_LEFT="Minecraftサーバーに" \
    TEXT_LOGIN_RIGHT="がログインしました！" \
    TEXT_LOGOUT_LEFT="Minecraftサーバーから" \
    TEXT_LOGOUT_RIGHT="がログアウトしました"

# Install wget and certificates
RUN     apt-get update \
    &&  DEBIAN_FRONTEND=noninteractive \
        apt-get install -y curl wget screen

# Download the server jar file
RUN  	mkdir -p /opt/minecraft \
    &&  cd /opt/minecraft \
    &&  wget -q $MINECRAFT_JAR

WORKDIR /data
VOLUME /data

EXPOSE 25565

ADD ./files/docker-entrypoint.sh /opt
RUN chmod a+x /opt/docker-entrypoint.sh

ADD ./files/log-info.sh /opt
RUN chmod a+x /opt/log-info.sh

CMD /opt/docker-entrypoint.sh
