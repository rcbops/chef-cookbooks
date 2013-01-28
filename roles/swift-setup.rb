name "swift-setup"
description "sets up swift keystone passwords/users"
run_list(
    "role[base]",
    "recipe[swift::setup]"
)

