name "mysql-master"
description "Installs mysql and sets up replication (if 2 nodes with role)"
run_list(
  "role[base]",
  "recipe[mysql-openstack::server]",
  "recipe[openstack-monitoring::mysql-server]"
)
