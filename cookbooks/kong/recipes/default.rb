
package "git" do
  action :install
end

package "python-virtualenv" do
  action :install
end

execute "git clone https://github.com/cloudbuilders/kong" do
  command "git clone https://github.com/cloudbuilders/kong"
  cwd "/root"
  user "root"
end

execute "generate swift_small object" do
  command "dd if=/dev/zero of=swift_small bs=512 count=1024"
  cwd "/root/kong/include/swift_objects"
end

execute "generate swift_medium object" do
  command "dd if=/dev/zero of=swift_medium bs=512 count=1024000"
  cwd "/root/kong/include/swift_objects"
end

execute "generate swift_large object" do
  command "dd if=/dev/zero of=swift_large bs=1024 count=1024"
  cwd "/root/kong/include/swift_objects"
end

execute "install virtualenv" do
  command "python tools/install_venv.py"
  cwd "/root/kong"
  user "root"
end

execute "run kong" do
  command "./run_tests.sh -V"
  cwd "/root/kong"
  user "root"
end
