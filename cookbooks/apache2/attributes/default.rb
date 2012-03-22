#
# Cookbook Name:: apache2
# Attributes:: apache
#
# Copyright 2008-2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# ::Chef::Node.send(:include, Opscode::OpenSSL::Password)

# Where the various parts of apache are
case platform
when "redhat","centos","fedora","suse"
  set[:apache][:package]   = "httpd"
  set[:apache][:dir]       = "/etc/httpd"
  set[:apache][:log_dir]   = "/var/log/httpd"
  set[:apache][:user]      = "apache"
  set[:apache][:binary]    = "/usr/sbin/httpd"
  set[:apache][:icondir]   = "/var/www/icons/"
  set[:apache][:mod_dir]   = "conf.d"
  set[:apache][:cert_dir]  = "/etc/pki/tls/"
  set[:apache][:self_cert] = "localhost.crt"
  set[:apache][:self_cert_key] = "localhost.key"
when "debian","ubuntu"
  set[:apache][:package]   = "apache2"
  set[:apache][:dir]       = "/etc/apache2"
  set[:apache][:log_dir]   = "/var/log/apache2"
  set[:apache][:user]      = "www-data"
  set[:apache][:binary]    = "/usr/sbin/apache2"
  set[:apache][:icondir]   = "/usr/share/apache2/icons"
  set[:apache][:mod_dir]   = "mods-available"
  set[:apache][:cert_dir]  = "/etc/ssl/"
  set[:apache][:self_cert] = "ssl-cert-snakeoil.pem"
  set[:apache][:self_cert_key] = "ssl-cert-snakeoil.key"
else
  set[:apache][:dir]       = "/etc/apache2"
  set[:apache][:log_dir]   = "/var/log/apache2"
  set[:apache][:user]      = "www-data"
  set[:apache][:binary]    = "/usr/sbin/apache2"
  set[:apache][:icondir]   = "/usr/share/apache2/icons"
  set[:apache][:mod_dir]   = "mods-available"
end

###
# These settings need the unless, since we want them to be tunable,
# and we don't want to override the tunings.
###

# General settings
default[:apache][:listen_ports] = [ "80","443" ]
default[:apache][:contact] = "root@#{node[:hostname]}"
default[:apache][:timeout] = 30
default[:apache][:keepalive] = "On"
default[:apache][:keepaliverequests] = 100
default[:apache][:keepalivetimeout] = 5

# Security
default[:apache][:servertokens] = "Prod"
default[:apache][:serversignature] = "Off"
default[:apache][:traceenable] = "Off"

# mod_auth_openids
default[:apache][:allowed_openids] = Array.new

# mod_status
default[:apache][:status][:enable] = "On"
default_unless[:apache][:status][:user] = "serverinfo"
# This will not work unless the first line in this file works
# default_unless[:apache][:status][:pass] = secure_password
default_unless[:apache][:status][:pass] = "serverinfo"

# Lets figure maxclients depending on size
maxclients = node[:memory][:total].to_i / 15000
maxspareservers = Math.sqrt(maxclients) + 2
minspareservers = maxspareservers / 2

# Prefork Attributes
default[:apache][:prefork][:startservers] = 4
default[:apache][:prefork][:minspareservers] = minspareservers.to_i
default[:apache][:prefork][:maxspareservers] = maxspareservers.to_i
default[:apache][:prefork][:serverlimit] = maxclients.to_i
default[:apache][:prefork][:maxclients] = maxclients.to_i
default[:apache][:prefork][:maxrequestsperchild] = 1000

# Worker Attributes
default[:apache][:worker][:startservers] = 4
default[:apache][:worker][:maxclients] = 1024
default[:apache][:worker][:minsparethreads] = 64
default[:apache][:worker][:maxsparethreads] = 192
default[:apache][:worker][:threadsperchild] = 64
default[:apache][:worker][:maxrequestsperchild] = 0
