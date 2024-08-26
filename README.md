# NGINX DPI
Fork of project nginxdpi. Reverse proxy with DPI to redirect traffic through proxy.

Original post: [https://habr.com/ru/post/548110](https://habr.com/ru/post/548110)

## Install
```
git clone https://github.com/igroykt/nginx-dpi.git
dnf install libtool make zlib-devel pcre-devel bc
wget https://openresty.org/download/openresty-1.25.3.1.tar.gz
tar xvvf openresty-1.25.3.1.tar.gz
wget https://www.openssl.org/source/openssl-1.1.1t.tar.gz
tar xvvf openssl-1.1.1t.tar.gz
cd openresty-1.25.3.1
./configure --prefix=/usr/local/nginx-dpi --with-cc=gcc --add-module=../nginx-dpi/lua-resty-openssl-aux-module --add-module=../nginx-dpi/lua-resty-openssl-aux-module/stream --add-module=../nginx-dpi/lua-resty-getorigdest-module/src --with-openssl=../openssl-1.1.1t --with-http_v3_module
gmake && gmake install
cd ..
yes|cp -r nginx-dpi/lua-resty-getorigdest-module/lualib/* /usr/local/nginx-dpi/lualib/
yes|cp -r nginx-dpi/lua-resty-openssl/lib/resty/* /usr/local/nginx-dpi/lualib/resty/
yes|cp -r nginx-dpi/lua-resty-openssl-aux-module/lualib/* /usr/local/nginx-dpi/lualib/
yes|cp nginx-dpi/lua-resty-socks5/socks5.lua /usr/local/nginx-dpi/lualib/resty/
yes|cp nginx-dpi/lua-struct/src/struct.lua /usr/local/nginx-dpi/lualib/
cp -r nginx-dpi/cfg /usr/local/nginx-dpi/
cp nginx-dpi/sapi/nginx-dpi.service /etc/systemd/system/
systemctl daemon-reload
```

## DPI setup
Configuration file located at /usr/local/nginx-dpi/cfg/config.lua. It is necessary to correct the variables.
```
local proxy_addr - proxy server IP address
local proxy_port - proxy server port
local isp_block_banner - block banner url of ISP
local isp_common_name - ISP main domain
local exclude_domains - list of domains that should not be redirected through proxy
local force_domains - list of domains that should be forced to redirected through proxy 
```

## Iptables setup
Iptables scripts located at cfg/start.sh and cfg/stop.sh. Correct interface name and the network to fit your realities.
```
INTERFACE - network interface name
NETWORK - local network
```

## Logrotate script
```
/usr/local/nginx-dpi/nginx/logs/*.log {
    daily
    rotate 10
    missingok
    notifempty
    compress
    sharedscripts
    postrotate
        [ ! -f /usr/local/nginx-dpi/nginx/logs/nginx.pid ] || kill -USR1 `cat /usr/local/nginx-dpi/nginx/logs/nginx.pid`
    endscript
}
```

## Замедление Youtube в России
Добавьте следующие домены в force_domains:
```
"youtube.com",
"googlevideo.com",
"ytimg.com",
"googleapis.com",
"youtube-nocookie.com",
"gvt1.com",
"gvt2.com",
"googleusercontent.com",
"ggpht.com",
"gstatic.com"
```
Чтобы ролики игрались в 4K включите в браузере поддержку протокола QUIC (в Яндекс.Браузер включен по-умолчению).

More detailed information at: [https://it.igro.tech/nginx-dpi](https://it.igro.tech/nginx-dpi)
