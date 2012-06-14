name "nova-controller"
description "Nova Controller without keystone/glance/horizon"
run_list(
  "role[base]",
  "role[nova-setup]",
  "role[nova-scheduler]",
  "role[nova-api-ec2]",
  "role[nova-api-os-compute]",
  "role[nova-volume]",
  "role[nova-vncproxy]"
)
