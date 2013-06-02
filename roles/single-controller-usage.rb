{
  "name": "single-controller-usage",
  "description": "",
  "json_class": "Chef::Role",
  "default_attributes": {
  },
  "override_attributes": {
  },
  "chef_type": "role",
  "run_list": [
    "role[single-controller]",
    "role[ceilometer-setup]",
    "role[ceilometer-api]",
    "role[ceilometer-central-agent]",
    "role[ceilometer-collector]"
  ],
  "env_run_lists": {
  }
}
