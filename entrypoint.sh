#!/bin/bash

#Obrain the IPs of ZK instances

ZK_IPs=","

for i in $(curl -s rancher-metadata.rancher.internal/2015-12-19/stacks/mesos/services/zookeeper/containers/ | awk -F= '{print $2}')
do
        ZK_IPs="${ZK_IPs},$(curl -s rancher-metadata.rancher.internal/2015-12-19/stacks/mesos/services/zookeeper/containers/${i}/primary_ip):2181"
done
ZK_IPs=$(echo $ZK_IPs | sed 's/,,//g')

exec /usr/sbin/mesos-slave --zk=zk://${ZK_IPs}/mesos --work_dir=${MESOS_WORK_DIR} --port=${MESOS_PORT} --log_dir=${MESOS_LOG_DIR} --containerizers=${MESOS_CONTAINERIZERS} --switch_user=${MESOS_SWITCH_USER}
