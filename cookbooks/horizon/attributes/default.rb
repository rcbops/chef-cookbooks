# Identity Specifics
default["identity"]["service_port"] = "5000"
default["identity"]["admin_port"] = "35357"
default["identity"]["admin_token"] = "999888777666"

# Horizon Specifics
default["horizon"]["db_user"] = "dash"
default["horizon"]["db_passwd"] = "dash"
default["horizon"]["db"] = "dash"
default["horizon"]["db_ipaddress"] = node["controller_ipaddress"]

case node["platform"]
when "fedora", "centos", "redhat"
  default["horizon"]["cert_dir"] = "/etc/pki/tls"
  # TODO(shep) - Fedora does not generate self signed certs by default
  default["horizon"]["self_cert"] = "ssl-cert-snakeoil.pem"
  default["horizon"]["self_cert_key"] = "ssl-cert-snakeoil.key"
when "ubuntu", "debian"
  default["horizon"]["cert_dir"] = "/etc/ssl"
  default["horizon"]["self_cert"] = "ssl-cert-snakeoil.pem"
  default["horizon"]["self_cert_key"] = "ssl-cert-snakeoil.key"
end

# Compute Information (probably better with node search later)
default["compute"]["controller_ipaddress"] = node["ipaddress"]

# Account for the moving target that is the dashboard path....
default["horizon"]["dash_path"] = "/usr/share/openstack-dashboard/openstack_dashboard"
default["horizon"]["wsgi_path"] = node["horizon"]["dash_path"] + "/wsgi"
