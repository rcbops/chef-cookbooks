name "allinone"
description "This will create an all-in-one Openstack cluster"
run_list(
  "role[single-controller]",
  "role[single-compute]",
  "role[collectd-client]",
  "role[collectd-server]",
  "role[graphite]"
)
