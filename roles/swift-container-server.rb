name "swift-container-server"
description "swift container server"
run_list(
    "role[base]",
    "recipe[swift::container-server]",
    "recipe[openstack-monitoring::swift-container-server]"
)


