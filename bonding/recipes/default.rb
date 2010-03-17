# require 'rubygems'              #
# require 'pp'
# puts node[:network][:interfaces][:eth0]

# ip = node[:network][:interfaces]['eth0']['addresses'].detect{|addr| addr.last["family"] == "inet"}.first
# mac = node[:network][:interfaces]['eth0']['addresses'].detect{|addr| addr.last["family"] == "lladdr"}.first

# puts "IP: #{ip}\nMAC: #{mac}"

node[:network][:interfaces].each do |key,value|
#       puts "----------"
#       puts "Key: #{key}"
#       puts "----------"
        puts "Key: #{key}"
        ip = value['addresses'].detect{|addr| addr.last["family"] == "inet"}.first
        puts "IP: #{ip}"
        case key
        when 'lo'
        else
                mac = value['addresses'].detect{|addr| addr.last["family"] == "lladdr"}.first
                puts "MAC: #{mac}"
        end
        puts "---"
end
