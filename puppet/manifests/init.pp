# ....

$domain_name="testvm.local"
$sub_ip="192.168.1"

$host_web="webnginx"
$domain_web="$host_web.$domain_name"
$ip_web="$sub_ip.2"

$host_mysql="mysqldb"
$domain_mysql="$host_mysql.$domain_name"
$ip_mysql="$sub_ip.3"

$root_www="/srv/www/cscart"

# параметры для виртуальной машиный базза данных
$namedb = "testdb"
$userdb = "test"
$passwdb = "test"

# параметры для cs-cart
$secret_key = "g0WJrIoLvt"
$hostdb = "$domain_mysql"
$http_host = "$ip_web"
$https_host = "$ip_web"
$admin_email = 'admin@example.com'
$admin_password = 'admin'

# параметр для настройки my.cnf
# слушает адресс 0.0.0.0 для mysql
$override_options = {
	'mysqld' => {
		'bind-address' => '0.0.0.0'
	}
}

class addhosts{
	file_line {'host_web':
		line      => "$ip_web $domain_web $host_web",
		path      => '/etc/hosts',
	}
	file_line {'host_mysql':
		line      => "$ip_mysql $domain_mysql $host_mysql",
		path      => '/etc/hosts',
	}
}


node mysqldb.testvm.local {
	include addhosts
	class { 'mysql::server':
	   root_password => 'password',
	   restart => true,
	   override_options => $override_options,
	}

	mysql::db { 'testdb':
	   user     => $userdb,
	   password => $passwdb,
	   host     => $domain_web,
	   grant    => ['ALL'],
	   require => Class['mysql::server'],
	 }
}

node webnginx.testvm.local {
	include addhosts

	class { 'cs_nginx::cs_nginx':
		root_www => $root_www,
	}
	
	class { 'cs_php::cs_php': }

	class { 'cs_carts::cs_carts':
		root_www => $root_www,
		admin_email => $admin_email,
		admin_password => $admin_password,
		secret_key => $secret_key,
		hostdb => $hostdb,
		namedb => $namedb,
		userdb => $userdb,
		passwdb => $passwdb,
		http_host => $http_host,
		https_host => $https_host,
	}
	
	~> service { 'nginx':
		ensure => running,
		enable => true,
		require => Class['cs_carts::cs_carts'],
	}

}
