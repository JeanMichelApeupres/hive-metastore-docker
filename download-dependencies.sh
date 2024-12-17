#!/usr/bin/env bash

set -euf -o pipefail

HIVE_VERSION="4.0.1"
HADOOP_VERSION="3.3.6"
PG_VERSION="42.7.4"
AWS_VERSION="1.12.780"

echo "Downloading Hive ${HIVE_VERSION} if not presents"
if [ ! -f "apache-hive-${HIVE_VERSION}-bin.tar.gz" ]; then
    curl -O https://dlcdn.apache.org/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz
fi

echo "Downloading Hadoop ${HADOOP_VERSION} if not presents"
if [ ! -f "hadoop-${HADOOP_VERSION}.tar.gz" ]; then
    curl -O https://dlcdn.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
fi

echo "Downloading S3A jars ${AWS_VERSION} if not presents"
if [ ! -f "aws-java-sdk-bundle-${AWS_VERSION}.jar" ]; then
    curl -O https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/${AWS_VERSION}/aws-java-sdk-bundle-${AWS_VERSION}.jar
fi

echo "Downloading PG JDBC jar ${PG_VERSION} if not presents"
if [ ! -f "postgresql-${PG_VERSION}.jar" ]; then
    curl -O https://repo1.maven.org/maven2/org/postgresql/postgresql/${PG_VERSION}/postgresql-${PG_VERSION}.jar
fi
