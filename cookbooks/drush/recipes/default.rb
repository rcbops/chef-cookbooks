
include_recipe "httpd::php-drupal"

directory "/opt/drush" do
	owner "root"
	group "root"
	mode "0755"
	action :create
	not_if "test -d /opt/drush"
end

remote_file "/tmp/drush-All-versions-3.0-beta1.tar.gz" do
	source "http://ftp.drupal.org/files/projects/drush-All-versions-3.0-beta1.tar.gz"
	mode "0644"
	checksum "d4e62187"
end

execute "extract_drush" do
	command "/usr/bin/tar -zxf /tmp/drush-All-versions-3.0-beta1.tar.gz -C /opt"
	action :run
end

execute "symlink_drush" do
	command "/bin/ln -s /opt/drush/drush /usr/local/bin/drush"
	action :run
	not_if do File.symlink?("/usr/local/bin/drush") end
end

file "/tmp/drush-All-versions-3.0-beta1.tar.gz" do
	action :delete
end
