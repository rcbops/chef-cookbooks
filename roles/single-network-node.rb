name "single-network-node"
description "Quantum Network Node (non-HA)"
run_list(
  "role[base]",
  "role[rsyslog-client]",
  "recipe[nova-network::quantum-metadata-agent]",
  "recipe[nova-network::quantum-dhcp-agent]",
  "recipe[nova-network::quantum-plugin]",
  "role[openstack-logging]"
)
