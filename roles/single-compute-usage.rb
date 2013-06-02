{
  "name": "single-compute-usage",
  "description": "",
  "json_class": "Chef::Role",
  "default_attributes": {
  },
  "override_attributes": {
  },
  "chef_type": "role",
  "run_list": [
    "role[single-compute]",
    "role[ceilometer-compute]"
  ],
  "env_run_lists": {
  }
}
