# Do not use 'latest' tag in production 😛
FROM alpine:latest AS build
ARG HIVE_VERSION
ARG HADOOP_VERSION
COPY apache-hive-$HIVE_VERSION-bin.tar.gz /opt/
COPY hadoop-$HADOOP_VERSION.tar.gz /opt/
#COPY deps.txt /tmp/
RUN tar zxf /opt/apache-hive-$HIVE_VERSION-bin.tar.gz -C /opt/ && \
  rm /opt/apache-hive-$HIVE_VERSION-bin.tar.gz && \
  tar zxf /opt/hadoop-$HADOOP_VERSION.tar.gz -C /opt/ && \
  rm /opt/hadoop-$HADOOP_VERSION.tar.gz && \
  cp /opt/hadoop-$HADOOP_VERSION/share/hadoop/tools/lib/hadoop-aws-$HADOOP_VERSION.jar /opt/hadoop-$HADOOP_VERSION/share/hadoop/common/lib/ && \
  rm -rf /opt/hadoop-$HADOOP_VERSION/share/doc \
    /opt/hadoop-$HADOOP_VERSION/share/hadoop/yarn \
    /opt/hadoop-$HADOOP_VERSION/share/hadoop/tools \
    /opt/hadoop-$HADOOP_VERSION/share/hadoop/mapreduce \
    /opt/hadoop-$HADOOP_VERSION/share/hadoop/client \
    /opt/apache-hive-$HIVE_VERSION-bin/jdbc && \
  #mkdir -p /tmp/lib && \
  #for i in $(cat /tmp/deps.txt); do cp /opt/apache-hive-$HIVE_VERSION-bin/lib/$i /tmp/lib; done && \
  rm -rf /opt/apache-hive-$HIVE_VERSION-bin/lib


# Do not use 'latest' tag in production 😛
FROM alpine:latest AS run

ARG HIVE_VERSION
ARG HADOOP_VERSION
COPY --from=build --chown=1000:1000 /opt/apache-hive-$HIVE_VERSION-bin /opt/hive
COPY --from=build --chown=1000:1000 /opt/hadoop-$HADOOP_VERSION /opt/hadoop
#COPY --from=build --chown=1000:1000 /tmp/lib /opt/hive/lib

# Uncomment if s3 support is needed
#COPY --chown=1000:1000 aws-java-sdk-bundle-1.12.780.jar /opt/hadoop/share/hadoop/common/lib/
COPY --chown=1000:1000 postgresql-42.7.4.jar /opt/hive/lib/
COPY --chown=1000:1000 --chmod=755 entrypoint.sh /entrypoint.sh
COPY --chown=1000:1000 hive-site.xml /opt/hive/conf
COPY --chown=1000:1000 metastore-log4j2.properties /opt/hive/conf

RUN apk update && \
  apk add openjdk17-jre-headless procps bash && \
  addgroup -g 1000 -S hive && adduser -S -u 1000 -g "" -G hive hive && \
  mkdir -p /opt/hive/data/warehouse && \
  chown -R hive:hive /opt/hive/data/warehouse

ENV JAVA_HOME="/usr/lib/jvm/java-17-openjdk" \
  HADOOP_HOME="/opt/hadoop" \
  HADOOP_YARN_HOME="/opt/hadoop" \
  HADOOP_MAPRED_HOME="/opt/hadoop" \
  HADOOP_HDFS_HOME="/opt/hadoop" \
  HIVE_HOME="/opt/hive" \
  HIVE_VER=$HIVE_VERSION
ENV PATH=$HIVE_HOME/bin:$HADOOP_HOME/bin:$PATH

USER hive
WORKDIR /opt/hive
EXPOSE 9083
ENTRYPOINT ["sh", "-c", "/entrypoint.sh"]
