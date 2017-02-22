#!/bin/bash
# © Copyright IBM Corporation 2015.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html

set -e

NODE_NAME=${NODENAME-IIBV10NODE}

stop()
{
	echo "----------------------------------------"
	echo "Stopping node $NODE_NAME..."
	mqsistop $NODE_NAME
}

start()
{
	echo "----------------------------------------"
  /opt/ibm/iib-10.0.0.7/iib version
	echo "----------------------------------------"

  NODE_EXISTS=`mqsilist | grep $NODE_NAME > /dev/null ; echo $?`


	if [ ${NODE_EXISTS} -ne 0 ]; then
    echo "----------------------------------------"
    echo "Node $NODE_NAME does not exist..."
    echo "Creating node $NODE_NAME"
		mqsicreatebroker $NODE_NAME
    echo "----------------------------------------"
	fi
	echo "----------------------------------------"
	echo "Starting syslog"
  sudo /usr/sbin/rsyslogd
	echo "Starting node $NODE_NAME"
	mqsistart $NODE_NAME
	echo "----------------------------------------"
}

monitor()
{
	echo "----------------------------------------"
	echo "Running - stop container to exit"
	# Loop forever by default - container must be stopped manually.
  # Here is where you can add in conditions controlling when your container will exit - e.g. check for existence of specific processes stopping or errors beiing reported
	while true; do
		sleep 1
	done
}

vframe()
{
	echo "----------------------------------------"
	echo "Running - xvfb in background"
	if ! pgrep -x "Xvfb" > /dev/null
	then
		echo "Starting Xvfb in background"
		nohup Xvfb ${DISPLAY} > /dev/null 2>&1 &
	fi
}

iib-license-check.sh
vframe
start
trap stop SIGTERM SIGINT
monitor
