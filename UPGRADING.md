4.1.X to 4.2 (Ubuntu)
=====================


Known Issues
-------------

* At present, qemu-kvm does not update cleanly.  You can avoid any
  issues with this by manually upgrading qemu-kvm prior to starting
  the chef-client run.  If you forget to do this, fear not.  The run
  will fail, at which point you can manually upgrade qemu-kvm and then
  run chef-client again with no issues.  Currently this takes a couple
  of runs.  Make sure you've got the havana repos set up.

  apt-get install -y qemu-kvm qemu-utils qemu-system-common qemu-system-x86


* The dependencies on the nova-common package in ubuntu are incorrect,
  resulting in the required version of python-cmd2 not being
  installed.  This means you get stack traces on nova-manage service
  list, for example.  This can be resolved by apt-get install
  python-cmd2.  We've filed a package bug here:
  https://bugs.launchpad.net/ubuntu/+source/nova/+bug/1242925
