name "cinder-all"
description "Cinder Volume Service"
run_list(
  "role[base]",
  "role[cinder-api]",
  "role[cinder-scheduler]",
  "role[cinder-volume]"
)
