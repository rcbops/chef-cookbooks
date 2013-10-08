name "neutron-network-manager"
description "Where the neutron-dhcp-agent, neutron-l3-agent, and openvswitch setups live. Usually a single node"
run_list(
  "role[base]",
  "recipe[osops-utils::keepalived-timeouts]",
  "recipe[nova::nova-common]",
  "recipe[nova-network::neutron-plugin]",
  "recipe[nova-network::neutron-dhcp-agent]",
  "recipe[nova-network::neutron-l3-agent]",
  "role[openstack-logging]"
)
