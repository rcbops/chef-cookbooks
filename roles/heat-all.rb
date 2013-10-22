name "heat-all"
description "heat all in one"
run_list(
  "role[heat-setup]",
  "role[heat-engine]",
  "role[heat-api]",
  "role[heat-api-cfn]",
  "role[heat-api-cloudwatch]",
)
