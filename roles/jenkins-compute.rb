name "jenkins-compute"
description "This inherits from role[single-compute], and sets default attributes required for to run this role via jenkins"
run_list(
  "role[single-compute]"
)
default_attributes(
  "mysql" => {
    "allow_remote_root" => true
  },
  "package_component" => "folsom",
  "nova" => {
    "libvirt" => { "virt_type" => "qemu" },
  }
)
override_attributes(
  "nova" => {
    "networks" => [
        {
            "label" => "public",
            "ipv4_cidr" => "192.168.100.0/24",
            "num_networks" => "1",
            "network_size" => "255",
            "bridge" => "br100",
            "bridge_dev" => "eth0.100",
            "dns1" => "8.8.8.8",
            "dns2" => "8.8.4.4"
        },
        {
            "label" => "private",
            "ipv4_cidr" => "192.168.200.0/24",
            "num_networks" => "1",
            "network_size" => "255",
            "bridge" => "br101",
            "bridge_dev" => "eth0.101",
            "dns1" => "8.8.8.8",
            "dns2" => "8.8.4.4"
        }
    ]
  }
)
