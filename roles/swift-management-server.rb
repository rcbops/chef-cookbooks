name "swift-management-server"
description "swift management server"
run_list(
    "role[base]",
    "recipe[swift::management-server]"
)



