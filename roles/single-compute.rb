name "single-compute"
description "Nova compute (with non-HA Controller)"
run_list (
          "recipe[nova::compute]"
)

