# @summary
#   Конфигурация сs-cart
#

class cs_carts::cs_carts (
	$root_www = '/srv/www/cscart',
	$admin_email = 'admin@example.com',
	$admin_password = 'admin',
	$secret_key = 'YOURVERYSECRETCEY',
	$hostdb = 'localhost',
	$namedb = '%DB_NAME%',
	$userdb = '%DB_USER%',
	$passwdb  = '%DB_PASS%',
	$http_host = '%HTTP_HOST%',
	$https_host = '%HTTP_HOST%',
) {
	$path_config = "$root_www/install/config.php"
	$dir_config = "$root_www/install"

	package { 'git':
		ensure => latest,
	}

	~> vcsrepo { $root_www:
	  ensure   => present,
	  provider => git,
	  source   => 'https://github.com/Iagilev/test-app-cs.git',
	  require => Package['git'],
	}

	~> file { $path_config:
		ensure => file,
		owner => 'root',
		group => 'root',
		mode => '0644',
		content => template('cs_carts/config.php.erb'),
	}

	~> exec { 'install-cscart':
		command => "php ./index.php",
		cwd     => $dir_config,
		path    => '/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin',
	}

	# SELinux CentOS/8
	~> case $::osfamily {
	    'RedHat': {
		 exec { 'chcon-www':
			command => "chcon -Rt httpd_sys_rw_content_t $root_www",
			path    => '/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin',
			}
		}
	}

	~> exec { 'chown root_www':
		command => "chown nginx:nginx -Rf ./",
		cwd  => $root_www,
		path    => '/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin',
	}

	~> exec { 'chmod config.local.php':
		command => "chmod 666 config.local.php",
		cwd  => $root_www,
		path    => '/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin',
	}

	~> exec { 'chmod design images var':
		command => "chmod -R 777 design images var",
		cwd  => $root_www,
		path    => '/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin',
	}

	~> exec { 'find chmod design':
		command => "find design -type f -print0 | xargs -0 chmod 666",
		cwd  => $root_www,
		path    => '/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin',
	}

	~> exec { 'find chmod images':
		command => "find images -type f -print0 | xargs -0 chmod 666",
		cwd  => $root_www,
		path    => '/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin',
	}

	~> exec { 'find chmod var':
		command => "find var -type f -print0 | xargs -0 chmod 666",
		cwd  => $root_www,
		path    => '/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin',
	}

	~> exec { 'chmod .htaccess':
		command => "chmod 644 design/.htaccess images/.htaccess var/.htaccess var/themes_repository/.htaccess",
		cwd  => $root_www,
		path    => '/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin',
	}

	~> exec { 'chmod index.php':
		command => "chmod 644 design/index.php images/index.php var/index.php var/themes_repository/index.php",
		cwd  => $root_www,
		path    => '/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin',
	}


	~> exec { 'enable connect to db':
		command => "setsebool -P httpd_can_network_connect_db 1",
		cwd  => $root_www,
		path    => '/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin',
	}

}


