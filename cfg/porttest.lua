local port_test = function(dest_addr, dest_port, connection_timeout, read_timeout, write_timeout)
    return ngx.thread.spawn(function()
        local sock = ngx.socket.tcp()
        sock:settimeouts(connection_timeout, read_timeout, write_timeout)
        local ok, err = sock:connect(dest_addr, dest_port)
        if not ok then
            sock:close()
            return nil, err
        end
        if dest_port == 443 then
            local ssl_params = {
                ssl_server_name = dest_addr,
                send_ocsp = false,
                verify = false,
            }
            ok, err = sock:sslhandshake(false, dest_addr, false, ssl_params)
            if not ok then
                sock:close()
                return nil, err
            end
        end
        sock:close()
        return true, nil
    end)
end

local port_test_http3 = function(dest_addr, dest_port, connection_timeout, read_timeout, write_timeout)
    return ngx.thread.spawn(function()
        local sock = ngx.socket.udp()
        sock:settimeout(connection_timeout, read_timeout, write_timeout)
        local ok, err = sock:setpeername(dest_addr, dest_port)
        if not ok then
            sock:close()
            return nil, err
        end
        local packet = string.char(0x00)
        local bytes, send_err = sock:send(packet)
        if not bytes then
            sock:close()
            return nil, send_err
        end
        local response, receive_err = sock:receive()
        sock:close()
        if not response then
            return nil, receive_err
        end
        return true, nil
    end)
end

return {
    port_test = port_test,
    port_test_http3 = port_test_http3
}