#!/bin/bash
# Copyright 2017 WSO2 Inc. (http://wso2.org)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ----------------------------------------------------------------------------
# Start Netty Service
# ----------------------------------------------------------------------------

script_dir=$(dirname "$0")
# Change directory to make sure logs directory is created inside $script_dir
cd $script_dir
service_jar=netty-http-connection-service-0.1.0-SNAPSHOT.jar

if pgrep -f "$service_jar" > /dev/null; then
    echo "Shutting down Netty"
    pkill -f $service_jar
fi

gc_log_file=./logs/nettygc.log

if [[ -f $gc_log_file ]]; then
    echo "GC Log exists. Moving $gc_log_file to /tmp"
    mv $gc_log_file /tmp/
fi

mkdir -p logs

echo "Starting Netty"
nohup java -Xms4g -Xmx4g -XX:+PrintGC -XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xloggc:$gc_log_file \
    -jar $service_jar --worker-threads 1000 --port 8587 > netty.out 2>&1 &
