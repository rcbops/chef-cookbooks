name "single-network-node"
description "Neutron Network Node (non-HA)"
run_list(
  "role[base]",
  "recipe[osops-utils::keepalived-timeouts]",
  "role[rsyslog-client]",
  "recipe[nova-network::neutron-metadata-agent]",
  "recipe[nova-network::neutron-dhcp-agent]",
  "recipe[nova-network::neutron-plugin]",
  "recipe[nova-network::neutron-l3-agent]",
  "role[openstack-logging]"
)
