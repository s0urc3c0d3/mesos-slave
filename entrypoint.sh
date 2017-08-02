#!/bin/bash

#Obrain the IPs of ZK instances

cron 
crontab -r
echo "*/5 * * * * /gen_hosts.sh > /etc/hosts" > /tmp/mycron 
crontab /tmp/mycron

ZK_IPs=","

my_stack=$(curl -s rancher-metadata.rancher.internal/2015-12-19/self/stack/name)

for i in $(curl -s rancher-metadata.rancher.internal/2015-12-19/stacks/${my_stack}/services/zookeeper/containers/ | awk -F= '{print $2}')
do
        ZK_IPs="${ZK_IPs},$(curl -s rancher-metadata.rancher.internal/2015-12-19/stacks/${my_stack}/services/zookeeper/containers/${i}/primary_ip):2181"
done
ZK_IPs=$(echo $ZK_IPs | sed 's/,,//g')

#tymczasowy fix hostname
my_hostname=$(curl -s rancher-metadata.rancher.internal/2015-12-19/self/host/agent_ip)

exec /usr/sbin/mesos-slave --master=zk://${ZK_IPs}/mesos --work_dir=${MESOS_WORK_DIR} --port=${MESOS_PORT} --log_dir=${MESOS_LOG_DIR} --containerizers=${MESOS_CONTAINERIZERS} --switch_user=${MESOS_SWITCH_USER} --launcher=posix --hostname=${my_hostname}
