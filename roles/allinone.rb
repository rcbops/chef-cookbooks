name "allinone"
description "This will create an all-in-one Openstack cluster"
run_list(
  "role[base]",
  "recipe[openstack::apt]",
  "recipe[openstack::controller]",
  "recipe[openstack::compute]"
)
