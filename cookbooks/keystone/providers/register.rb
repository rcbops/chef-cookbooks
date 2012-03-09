
action :create_service do
    # construct a HTTP object
    http = Net::HTTP.new(new_resource.auth_host, new_resource.auth_port)

    # Check to see if connection is http or https
    if new_resource.auth_protocol == "https"
        http.use_ssl = true
    end

    # Build out the required header info
    headers = _build_headers(new_resource.auth_token)
    
    # Construct the extension path
    path = "/#{new_resource.api_ver}/OS-KSADM/services"

    # See if the service exists yet
    service_uuid, error = _find_service_id(http, path, headers, new_resource.service_type)
    unless service_uuid
        # Service does not exist yet
        payload = _build_service_object(new_resource.service_type, new_resource.service_name, new_resource.service_description)
        resp, data = http.send_request('POST', path, JSON.generate(payload), headers)
        if resp.is_a?(Net::HTTPOK)
            Chef::Log.info("Created service '#{new_resource.service_name}'")
            new_resource.updated_by_last_action(true)
        else
            Chef::Log.error("Unable to create service '#{new_resource.service_name}'")
            Chef::Log.error("Response Code: #{resp.code}")
            Chef::Log.error("Response Message: #{resp.message}")
            new_resource.updated_by_last_action(false)
        end
    else
        Chef::Log.info("Service Type '#{new_resource.service_type}' already exists.. Not creating.") if error
        Chef::Log.info("Service UUID: #{service_uuid}")
        new_resource.updated_by_last_action(false)
    end
end


action :create_endpoint do
    # construct a HTTP object
    http = Net::HTTP.new(new_resource.auth_host, new_resource.auth_port)

    # Check to see if connection is http or https
    if new_resource.auth_protocol == "https"
        http.use_ssl = true
    end

    # Build out the required header info
    headers = _build_headers(new_resource.auth_token)
    
    # Construct the extension path
    path = "/#{new_resource.api_ver}/OS-KSADM/endpoints"

    # Lookup the service_uuid for service_type
    service_uuid, error = _find_service_id(http, "/#{new_resource.api_ver}/OS-KSADM/services", headers, new_resource.service_type)
    unless service_uuid
        Chef::Log.error("Unable to find service type '#{new_resource.service_type}'")
        new_resource.updated_by_last_action(false)
        return
    end

    # Make sure this endpoint does not already exist
    resp, data = http.request_get(path, headers)
    if resp.is_a?(Net::HTTPOK)
        endpoint_exists = false
        data = JSON.parse(data)
        data['endpoint'].each do |endpoint|
            if endpoint['service_id'] == service_uuid
                # Match found
                endpoint_exists = true
                break
            end
        end
        if endpoint_exists
            Chef::Log.info("Endpoint already exists for Service Type '#{new_resource.service_type}' already exists.. Not creating.")
            new_resource.updated_by_last_action(false)
        else
            payload = _build_endpoint_object(
                      new_resource.endpoint_region,
                      service_uuid,
                      new_resource.endpoint_publicurl,
                      new_resource.endpoint_internalurl,
                      new_resource.endpoint_adminurl)
            resp, data = http.send_request('POST', path, JSON.generate(payload), headers)
            if resp.is_a?(Net::HTTPOK)
                Chef::Log.info("Created endpoint for service type '#{new_resource.service_type}'")
                new_resource.updated_by_last_action(true)
            else
                Chef::Log.error("Unable to create endpoint for service type '#{new_resource.service_type}'")
                Chef::Log.error("Response Code: #{resp.code}")
                Chef::Log.error("Response Message: #{resp.message}")
                new_resource.updated_by_last_action(false)
            end
        end
    else
        Chef::Log.error("Unknown response from the Keystone Server")
        Chef::Log.error("Response Code: #{resp.code}")
        Chef::Log.error("Response Message: #{resp.message}")
        new_resource.updated_by_last_action(false)
    end
end


private
def _find_service_id(http, path, headers, service_type)
    service_uuid = nil
    error = false
    resp, data = http.request_get(path, headers)
    if resp.is_a?(Net::HTTPOK)
        data = JSON.parse(data)
        data['OS-KSADM:services'].each do |svc|
            service_uuid = svc['id'] if svc['type'] == service_type
            break if service_uuid
        end
    else
        Chef::Log.error("Unknown response from the Keystone Server")
        Chef::Log.error("Response Code: #{resp.code}")
        Chef::Log.error("Response Message: #{resp.message}")
        error = true
    end
    return service_uuid,error
end

private
def _build_service_object(type, name, description)
    service_obj = Hash.new
    service_obj.store("type", type)
    service_obj.store("name", name)
    service_obj.store("description", description)
    ret = Hash.new
    ret.store("OS-KSADM:service", service_obj)
    return ret
end

private
def _build_endpoint_object(region, service_uuid, publicurl, internalurl, adminurl)
    endpoint_obj = Hash.new
    endpoint_obj.store("adminurl", adminurl)
    endpoint_obj.store("internalurl", internalurl)
    endpoint_obj.store("publicurl", publicurl)
    endpoint_obj.store("service_id", service_uuid)
    endpoint_obj.store("region", region)
    ret = Hash.new
    ret.store("endpoint", endpoint_obj)
    return ret
end

private
def _build_headers(token)
    ret = Hash.new
    ret.store('X-Auth-Token', token)
    ret.store('Content-type', 'application/json')
    return ret
end
