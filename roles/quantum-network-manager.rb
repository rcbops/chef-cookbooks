name "quantum-network-manager"
description "Where the quantum-dhcp-agent, quantum-l3-agent, and openvswitch setups live. Usually a single node"
run_list(
  "role[base]",
  "recipe[osops-utils::keepalived-timeouts]",
  "recipe[nova::nova-common]",
  "recipe[nova-network::quantum-plugin]",
  "recipe[nova-network::quantum-dhcp-agent]",
  "recipe[nova-network::quantum-l3-agent]",
  "role[openstack-logging]"
)
