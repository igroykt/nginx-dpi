# Пример настройки upstream proxy
В качестве Socks5 прокси будем использовать Hysteria2. Для домашнего использования должно хватить, но на продакшне рекомендуется использовать [projectx/xray](https://xtls.github.io/ru/document/).

Прокси сервер должен быть размещен за пределами страны, а клиент можно разместить на том же железе, что и nginx-dpi. Из поставщиков услуг порекомендую [pq.hosting](https://pq.hosting) поскольку там принимается оплата российскими картами. По конфигурации сойдет vps типа argentum (2 ядра - 2 гига). Интернет будет безлимитный шириной в 100 мегабит. Обойдется все это примерно в 500 рублей в месяц (есть годовой тариф). Из направлений порекомендую молдову, германию (франкфурт на майне) и стокгольм. Связь с ними вроде бы не плохая.

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