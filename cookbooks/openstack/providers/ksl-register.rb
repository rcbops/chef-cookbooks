
action :create_service do
    # construct a HTTP object
    http = Net::HTTP.new(new_resource.auth_host, new_resource.auth_port)

    # Build out the required header info

    # Construct the extension path
    path = "/#{new_resource.api_ver}/OS-KSADM/services"

end


action :create_endpoint do

end


private
def find_service_id(http, path, headers, service_type)
    service_uuid = nil
    error = false
    resp, data = http.request_get(path, headers)
    if resp.is_a?(Net::HTTPOK)
        data = JSON.parse(data)
        data['OS-KSADM:services'].each do |svc|
            service_id = svc['id'] if svc['type'] == service_type
            break if service_id
        end
    else
        Chef::Log.error("Unknown response from the Keystone Server")
        Chef::Log.error("Response Code: #{resp.code}")
        Chef::Log.error("Response Message: #{resp.message}")
        error = true
    end
    return service_uuid,error
end
