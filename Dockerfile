FROM alpine:3.4

RUN apk add --update bash && rm -rf /var/cache/apk/*

RUN apk --update add openjdk8-jre
ENV SCALA_VERSION=2.12.0-M5 \
    SCALA_HOME=/usr/share/scala

RUN apk add --no-cache --virtual=.build-dependencies wget ca-certificates && \
            apk add --no-cache bash && \
            cd "/tmp" && \
            wget "https://downloads.typesafe.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz" && \
            tar xzf "scala-${SCALA_VERSION}.tgz" && \
            mkdir "${SCALA_HOME}" && \
            rm "/tmp/scala-${SCALA_VERSION}/bin/"*.bat && \
            mv "/tmp/scala-${SCALA_VERSION}/bin" "/tmp/scala-${SCALA_VERSION}/lib" "${SCALA_HOME}" && \
            ln -s "${SCALA_HOME}/bin/"* "/usr/bin/" && \
            apk del .build-dependencies && \
            rm -rf "/tmp/"*

RUN apk --update add --virtual wget
ADD https://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/0.13.12/sbt-launch.jar /root/.sbt/launchers/0.13.12/sbt-launch.jar

ENTRYPOINT SBT_OPTS="-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M" java $SBT_OPTS -jar /root/.sbt/launchers/0.13.12/sbt-launch.jar "$@"
