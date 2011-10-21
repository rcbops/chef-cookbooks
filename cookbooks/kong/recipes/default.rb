
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
