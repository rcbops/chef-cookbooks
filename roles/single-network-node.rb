name "single-network-node"
description "Quantum Network Node (non-HA)"
run_list(
  "role[base]",
  "recipe[osops-utils::keepalived-timeouts]",
  "role[rsyslog-client]",
  "recipe[nova-network::quantum-metadata-agent]",
  "recipe[nova-network::quantum-dhcp-agent]",
  "recipe[nova-network::quantum-plugin]",
  "recipe[nova-network::quantum-l3-agent",
  "recipe[nova-network::rpcdaemon]",
  "role[openstack-logging]"
)
