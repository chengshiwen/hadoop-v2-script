#!/usr/bin/env bash

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# Start all yarn daemons.  Run this on master node.

bin=`dirname "${BASH_SOURCE-$0}"`
bin=`cd "$bin"; pwd`

DEFAULT_LIBEXEC_DIR="$bin"/../libexec
HADOOP_LIBEXEC_DIR=${HADOOP_LIBEXEC_DIR:-$DEFAULT_LIBEXEC_DIR}
. $HADOOP_LIBEXEC_DIR/yarn-config.sh

# start resourceManager
HARM=$("$HADOOP_PREFIX/bin/hdfs" getconf -confKey yarn.resourcemanager.ha.enabled 2>&-)
if [[ $HARM = "false" ]]; then
  RMHOSTS=$("$HADOOP_PREFIX/bin/hdfs" getconf -confKey yarn.resourcemanager.hostname)
else
  logicals=$("$HADOOP_PREFIX/bin/hdfs" getconf -confKey yarn.resourcemanager.ha.rm-ids 2>&-)
  logicals=${logicals//,/ }
  for id in ${logicals}; do
    rmhost=$("$HADOOP_PREFIX/bin/hdfs" getconf -confKey "yarn.resourcemanager.hostname.${id}" 2>&-)
    RMHOSTS="${RMHOSTS} ${rmhost}"
  done
  RMHOSTS=${RMHOSTS/ /}
fi
echo "Starting resourcemanagers on [${RMHOSTS}]"
"$bin"/yarn-daemons.sh --config $YARN_CONF_DIR --hostnames "${RMHOSTS}" start resourcemanager
# start nodeManager
"$bin"/yarn-daemons.sh --config $YARN_CONF_DIR start nodemanager
# start proxyserver
# "$bin"/yarn-daemon.sh --config $YARN_CONF_DIR start proxyserver
