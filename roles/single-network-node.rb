name "single-network-node"
description "Quantum Network Node (non-HA)"
run_list(
  "role[base]",
  "role[rsyslog-client]",
  "recipe[nova-network::network-node]",
  "role[openstack-logging]"
)
