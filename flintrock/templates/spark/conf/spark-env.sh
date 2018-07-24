#!/usr/bin/env bash

export SPARK_LOCAL_DIRS="{spark_root_ephemeral_dirs}"

# Standalone cluster options
export SPARK_EXECUTOR_INSTANCES="{spark_executor_instances}"
export SPARK_EXECUTOR_CORES="$(($(nproc) / {spark_executor_instances}))"
export SPARK_WORKER_CORES="$(nproc)"

export SPARK_MASTER_HOST="{master_ip}"

# Needed for spark 1.6.x
export SPARK_MASTER_IP="{master_ip}"

# TODO: Make this dependent on HDFS install.
export HADOOP_CONF_DIR="$HOME/hadoop/conf"

# TODO: Make this non-EC2-specific.
# SPARK_PUBLIC_DNS="$(curl --silent http://169.254.169.254/latest/meta-data/public-hostname)"
# Bind Spark's web UIs to this machine's private IP
SPARK_PUBLIC_DNS="$(curl --silent http://169.254.169.254/latest/meta-data/local-ipv4)"
export SPARK_PUBLIC_DNS

# TODO: Set a high ulimit for large shuffles
# Need to find a way to do this, since "sudo ulimit..." doesn't fly.
# Probably need to edit some Linux config file.
# ulimit -n 1000000

{spark_dist_classpath}
