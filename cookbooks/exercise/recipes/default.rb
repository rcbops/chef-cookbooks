package "git" do
    action :install
end

execute "git clone git@github.com:rcbops/exercise.git" do
    command "git clone git@github.com:rcbops/exercise.git"
    cwd "/opt"
    user "root"
    not_if do File.exists?("/opt/exercise") end
end

execute "run excercise" do
    cwd "/opt/exercise"
    command "./exercise.sh"
    action :run
end
