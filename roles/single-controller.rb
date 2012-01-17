name "single-controller"
description "Nova Controller (non-HA)"
run_list (
          "recipe[openstack::controller]"
)

