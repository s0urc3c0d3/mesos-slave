from mesosphere/mesos-slave:1.2.1
add entrypoint.sh /entrypoint.sh
expose 5051
env MESOS_PORT=5051 MESOS_LOG_DIR=/var/log/mesos MESOS_WORK_DIR=/var/tmp/mesos MESOS_CONTAINERIZERS=docker,mesos MESOS_SWITCH_USER=0
entrypoint /entrypoint.sh
