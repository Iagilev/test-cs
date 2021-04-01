# README

**Тестовое задание на позицию DevOps.**

Проверялось на ОС Ubuntu 20.04 LTS.

## установка Vagrant & Virtualbox

Установить на хостовую машину следующие пакеты:
	- vagrant
	- virtualbox
	- virtualbox-guest-utils

После установки vagrant'a установить плагин vagrant-vbguest `vagrant plugin install vagrant-vbguest --plugin-version 0.29`.

##Структура

```
./
├── puppet
│   ├── manifests
│   │   └── init.pp 			# инструкции по разворачиванию системы
│   └── modules
│       ├── cs_carts			# разворачивание приложения cs-cart
│       ├── cs_nginx			# установка и настройка nginx под приложение cs-cart
│       ├── cs_php				# установка и настройка php-fpm, так же модули php под приложение cs-cart
│       ├── mysql				# модуль скачан с puppetforge версия mysql 11.0
│       ├── puppetserver_gem	# зависимости от mysql скачанных модулей с puppetforge
│       ├── resource_api		# зависимости от mysql скачанных модулей с puppetforge
│       ├── stdlib				# зависимости от mysql скачанных модулей с puppetforge
│       ├── translate			# зависимости от mysql скачанных модулей с puppetforge
│       └── vcsrepo				# модуль скачан с puppetforge версия vscrepo 4.0.1
├── scripts
│   └── install-puppet.sh       # скрипт установки puppet-agent для дальнейшего использование puppet
└── Vagrantfile					# настройка виртуальных машин
```

## Vagrantfile
 
Основные параметры в файле:

	- SUBNAME="192.168.1"     # Настройка сети

	- DOMAIN="testvm.local"   # Название доменного имени

	- WEBNAME="webnginx"	  # Название хоста веб-приложения
	- WEBIP="#{SUBNAME}.2"	  # IP-адрес хоста

	- DBNAME="mysqldb"        # Название хоста базы данных
	- DBIP="#{SUBNAME}.3"     # IP-адрес хоста

**Примечание:** Если поменять одно из параметров, то надо поменять и в файле *init.pp* (*puppet/manifests/init.pp*).

	SUBNAME  -> $sub_ip
	DOMAIN   -> $domain_name
	WEBNAME  -> $host_web
	WEBIP    -> $ip_web
	DBNAME   -> $host_mysql
	DBIP     -> $ip_web

## init.pp

Основные параметры в файле:

	- общие
		$root_www - путь, где находится приложение

	- для баз данных
		$namedb - название базы
		$userdb - название пользователя
		$passwdb - пароль пользователя

	- для приложения cs-cart
		$secret_key - параметр для 
		$hostdb - указывается имя хоста или ip, где находится база данных
		$http_host - указывается ip. Определяется на каком интерфейсе принимать запросы  http и отдавать
		$https_host - То же самое, но по протоколу https
		$admin_email - электронная почта администратора (администрирование сайта)
		$admin_password - пароль администратора.


## Запуск среды

Поднимаются две виртуальные машины, на одно устанавливается база данных (mysql), на другом веб-сервер (nginx), сервер приложения (php-fpm) + зависимости модулей php для cs-cart.

По умолчанию используется подсеть 192.168.1.0/24.

Виртуальная машина с базой данных ip-адрес - 192.168.1.3.

Виртуальная машина с веб-приложением ip-адресс - 192.168.1.2.

Выполнить команду `vagrant up`.  После выполнение команды, открыть браузер и в адресную строку ввести `http://192.168.1.2/`.
