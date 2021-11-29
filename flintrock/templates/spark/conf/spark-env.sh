#!/usr/bin/env bash

export SPARK_LOCAL_DIRS="{spark_root_ephemeral_dirs}"

# Standalone cluster options
export SPARK_EXECUTOR_INSTANCES="{spark_executor_instances}"
export SPARK_EXECUTOR_CORES="$(($(nproc) / {spark_executor_instances}))"
export SPARK_WORKER_CORES="$(nproc)"

export SPARK_MASTER_HOST="{master_private_host}"

# TODO: Make this dependent on HDFS install.
export HADOOP_CONF_DIR="$HOME/hadoop/conf"

# TODO: Make this non-EC2-specific.
# Bind Spark's web UIs to this machine's public EC2 hostname
export SPARK_PUBLIC_DNS="$(curl --silent http://169.254.169.254/latest/meta-data/local-ipv4)"

# TODO: Set a high ulimit for large shuffles
# Need to find a way to do this, since "sudo ulimit..." doesn't fly.
# Probably need to edit some Linux config file.
# ulimit -n 1000000

{spark_dist_classpath}

# Should this be made part of a Python service somehow?
export PYSPARK_PYTHON="python3"

# Every hour, delete folders of finished applications in "spark/work" that are older than 4 hours.
# This is important for Spark applications that are executed regularly, e.g. every 30 minutes,
# because each folder in "spark/work" contains the application jar (around 40 MB)
export SPARK_WORKER_OPTS="-Dspark.worker.cleanup.enabled=true -Dspark.worker.cleanup.interval=3600 -Dspark.worker.cleanup.appDataTtl=14400"
