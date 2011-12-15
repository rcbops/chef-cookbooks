#
# Chef Solo Config File
#

log_level          :info
log_location       STDOUT
file_cache_path    "/tmp/chef-solo/cookbooks"

# Optionally store your JSON data file and a tarball of cookbooks remotely.
#json_attribs "http://chef.example.com/dna.json"

Mixlib::Log::Formatter.show_time = false
