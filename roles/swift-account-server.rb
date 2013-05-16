name "swift-account-server"
description "swift account server"
run_list(
    "role[base]",
    "recipe[swift::account-server]",
    "recipe[openstack-monitoring::swift-account-server]"
)


