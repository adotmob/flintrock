#!/bin/bash

set -e

url="$1"

echo "Installing Spark..."
echo "  from: ${url}"

file="$(basename ${url})"

# S3 is generally reliable, but sometimes when launching really large
# clusters it can hiccup on us, in which case we'll need to retry the
# download.
set +e
tries=1
while true; do
    curl --remote-name "${url}"
    curl_ret=$?

    if ((curl_ret == 0)); then
        break
    elif ((tries >= 3)); then
        exit 1
    else
        tries=$((tries + 1))
        sleep 1
    fi
done
set -e

gzip -t "$file"

mkdir "spark"
# strip-components puts the files in the root of spark/
tar xzf "$file" -C "spark" --strip-components=1
rm "$file"

# Because of https://issues.apache.org/jira/browse/SPARK-17993, Spark 2.1 displays very
# verbose logs when reading parquet files, with the default log4j file.
# This is fixed by SPARK-19219, which is released in Spark 2.2
#
# Workaround: if url contains "spark-2.1", use a copy of log4j.properties.template which
# contains level "ERROR" for parquet logs (default file log4j-defaults.properties doesn't)
if [[ $url == *"spark-2.1"* ]]; then
  cp -p spark/conf/log4j.properties.template spark/conf/log4j.properties
fi
