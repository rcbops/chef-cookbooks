The following section is incomplete but is a good start.

* Services that will listen on IP from the network specified in `node['osops_networks']['networks']['nova']`
	* `cinder-scheduler`
	* `keystone`
	* `nova-cert`
	* `nova-consoleauth`
	* `nova-novncproxy`
	* `nova-scheduler`
	* `ntpd`
	* `ZeroMQ`
* Services that will listen on IP from the network specified in `node['osops_networks']['networks']['public']`
	* `apache2` (dashboard)
	* `glance-api`
	* `glance-registry`
	* `nova-api`
* Services that will listen on IP from the network specified in `node['osops_networks']['networks']['management']`
	* TBD
* `node['nova']['networks']['ipv4_cidr']` (with parallel `label` attribute `public`)
	*Warning*: this goes into MySQL database `nova`, table `networks`. You have to update it manually in MySQL if you change the value later, the recipes do not do that.
* `node['nova']['networks']['ipv4_cidr']` (with parallel `label` attribute `private`)
	Warning: same as above.


