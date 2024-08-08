# Пример настройки upstream proxy
В качестве Socks5 прокси будем использовать Hysteria2. Для домашнего использования должно хватить, но на продакшне рекомендуется использовать [projectx/xray](https://xtls.github.io/ru/document/).

## Установка
```
git clone https://github.com/igroykt/nginx-dpi.git
mkdir /usr/local/hysteria
wget -O /usr/local/hysteria https://download.hysteria.network/app/latest/hysteria-linux-amd64 
cp nginx-dpi/example/config/server.json /usr/local/hysteria
cp nginx-dpi/example/sapi/hysteria-server.service /etc/systemd/system/
systemctl daemon-reload
```
Установка клиента производится аналогичным образом.

## Конфигурация
Конфигурация простая, но "salamander password" не должен совпадать с auth, а в конфигурацииях клиента и сервера должны совпадать. Естественно auth отвечает за аутентификацию, а salamander за обфускацию/деобфускацию трафика.