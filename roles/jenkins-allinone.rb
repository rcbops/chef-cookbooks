name "jenkins-allinone"
description "This inherits from role[allinone], and sets default attributes required for to run this role via jenkins"
run_list(
  "role[allinone]",
  "recipe[nova::patch]"
)
default_attributes(
  "mysql" => {
    "allow_remote_root" => true
  },
  "glance" => {
    "image_upload" => true,
    "images" => ["tty"]
  },
  "package_component" => "folsom",
  "nova" => {
    "libvirt" => { "virt_type" => "qemu" },
  }
)
override_attributes(
  "osops_networks" => {
    "public" => "192.168.1.0/24",
    "management" => "192.168.1.0/24",
    "nova" => "192.168.1.0/24"
  },
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
