name "single-controller"
description "Nova Controller (non-HA)"
run_list(
  "role[base]",
  "role[rsyslog-server]",
  "role[mysql-master]",
  "role[rabbitmq-server]",
  "role[keystone-setup]",
  "role[keystone-api]",
  "role[glance-setup]",
  "role[glance-registry]",
  "role[glance-api]",
  "role[nova-setup]",
  "role[nova-network-controller]",
  "role[nova-scheduler]",
  "role[nova-conductor]",
  "role[nova-api-ec2]",
  "role[nova-api-os-compute]",
  "role[cinder-setup]",
  "role[cinder-api]",
  "role[cinder-scheduler]",
  "role[nova-cert]",
  "role[nova-vncproxy]",
  "role[horizon-server]",
  "role[openstack-logging]"
)
