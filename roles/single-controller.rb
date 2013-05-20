name "single-controller"
description "Nova Controller (non-HA)"
run_list(
  "role[base]",
  "role[rsyslog-client]",
  "role[mysql-master]",
  "role[rabbitmq-server]",
  "role[keystone]",
  "role[glance-setup]",
  "role[glance-registry]",
  "role[glance-api]",
  "role[nova-setup]",
  "role[nova-network-controller]",
  "role[nova-scheduler]",
  "role[nova-conductor]",
  "role[nova-api-ec2]",
  "role[nova-api-os-compute]",
  "role[nova-volume]",
  "role[nova-cert]",
  "role[nova-vncproxy]",
  "role[horizon-server]",
  "role[openstack-logging]"
)
