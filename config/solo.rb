#
# Chef Solo Config File
#

log_level          :info
log_location       STDOUT
file_cache_path    "/tmp/chef-solo/cookbooks"

# Optionally store your JSON data file and a tarball of cookbooks remotely.
#json_attribs "http://chef.example.com/dna.json"
recipe_url    "http://github.com/galstrom21/Chef_Cookbooks/raw/master/cookbooks.tgz"

Mixlib::Log::Formatter.show_time = false
