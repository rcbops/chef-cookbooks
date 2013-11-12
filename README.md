## Description ##

This repository contains a collection of [chef](http://www.opscode.com/chef/) cookbooks  that can be used to deploy, and manage, the suite of OpenStack core projects (nova, glance, keystone, swift, horizon).  [User documentation](http://www.rackspace.com/knowledge_center/getting-started/rackspace-private-cloud) is available in our knowledge center!  The rest of this documentation is primarily aimed at developers who want to hack on the cookbooks.

The cookbooks have been designed and written in such a way that they can be used to deploy individual service components on _any_ of the nodes in the infrastructure; in short they can be used for single node 'all-in-one' installs (for testing), right up to multi/many node production installs.  

In order to achieve this flexibility, they make use of the [chef search](http://wiki.opscode.com/display/chef/Search)  functionality, and therefore require that if you are deploying anything larger than a single node deployment, you use [chef server](http://wiki.opscode.com/display/chef/Chef+Server) to host your cookbooks rather than using chef solo.  

## Cookbooks ##

Each of the cookbooks in the cookbooks directory is actually a [git submodule](http://help.github.com/submodules/), linking to an individual git repository where that cookbook is maintained.  

## Roles ##

There are a number of different chef roles that are included with these cookbooks.  Descriptions of each of the roles can be found in the [readme](https://github.com/rcbops/chef-cookbooks/blob/master/roles/README.md) in the roles directory.  

## Network configuration ##
Network configuration is stored in Chef `environment`. Please see `environments/example.json` and [networking documentation](networking.md).

## Usage ##

##### getting the cookbooks #####

* clone the parent repository (note the `--recursive` flag - this will ensure that each of the repositories that the submodules point to is also cloned):

`git clone --recursive git@github.com:rcbops/chef-cookbooks.git`  

* upload your cookbooks and roles to your chef server( assuming  you have already [configured your knife client](http://wiki.opscode.com/display/chef/Fast+Start+Guide) with the credentials of your chef server:  

`cd chef-cookbooks`  
`knife cookbook upload -o cookbooks --all`  
`knife role from file roles/*.rb`

##### using the cookbooks #####

NOTE: You must use chef >= 0.10.12
NOTE: If you are using Red Hat Enterprise Linux you must use RHEL >= 6 and you must enable the repository rhel-x86_64-server-optional-6

Ensure you have [registered](http://wiki.opscode.com/display/chef/Cookbook+Fast+Start+Guide#CookbookFastStartGuide-Registeranodewithchefclient),  one or more nodes with your chef server.  Then use knife to assign roles to your nodes:

* for an all-in-one deployment of nova, using keystone and glance, on a node called node1:  

`knife node run_list add node1 'role[allinone]'`  

* for a 2 node deployment of nova, installing all nova controller functions, keystone and glance on node1, and setting node2 up as a compute server:  

`knife node run_list add node1 'role[single-controller]'`  
`knife node run_list add node2 'role[single-compute]'`  

* for a multi node deployment as above but with 'N' nova compute nodes  

`knife node run_list add node1 'role[single-controller]'`  
`knife node run_list add node2 'role[single-compute]'`  
`knife node run_list add node3 'role[single-compute]'`  
`...`  
`knife node run_list add node[n] 'role[single-compute]'`  

* for a many node deployment with mysql and keystone on one node, nova core functions and horizon on another, glance on another, rabbitmq on another, and 'N' compute nodes:

`knife node run_list add node1 'role[keystone]'`  
`knife node run_list add node1 'role[mysql-master]'`  
`knife node run_list add node2 'role[nova-controller]'`  
`knife node run_list add node2 'role[horizon-server]'`  
`knife node run_list add node3 'role[glance-api]'`  
`knife node run_list add node3 'role[glance-registry]'`  
`knife node run_list add node4 'role[rabbitmq-server]'`  
`knife node run_list add node5 'role[single-compute]'`  
`knife node run_list add node6 'role[single-compute]'`  
`...`  
`knife node run_list add nodeN 'role[single-compute]'`  


## Custom template banners ##

You can define a custom string to be included in every template file managed by the Rackspace cookbooks by defining the custom_template_banner environment variable.  For Example:

`knife environment edit <environment name>`
`"override_attributes": { "custom_template_banner": "# This\n# is\n# a\n# multiline\n# message"`

## License and Author ##

Author:: Justin Shepherd (<justin.shepherd@rackspace.com>)  
Author:: Jason Cannavale (<jason.cannavale@rackspace.com>)  
Author:: Ron Pedde (<ron.pedde@rackspace.com>)  
Author:: Joseph Breu (<joseph.breu@rackspace.com>)  
Author:: William Kelly (<william.kelly@rackspace.com>)  
Author:: Darren Birkett (<darren.birkett@rackspace.co.uk>)  
Author:: Evan Callicoat (<evan.callicoat@rackspace.com>)  
Author:: Andy McCrae (<andrew.mccrae@rackspace.co.uk>)  

Copyright 2012, Rackspace US, Inc.  

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
