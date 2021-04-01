# @summary
#   Конфигурация php cs-cart
#

class cs_php::cs_php {
	# install php
	$package_list_php = [
	'php',
    'php-fpm',
    'php-json',
    'php-mysqlnd',
    'php-soap',
    'php-zip',
	'php-xml',
	]
	package { $package_list_php:
		ensure => latest,
	}

	# install php-imagemagick
	package { 'epel-release':
		ensure => latest,
	}

	~> exec { 'dnf-powertools':
		command => 'dnf config-manager --set-enabled powertools',
		path    => '/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin',
		require => Package['epel-release'],
	}

	$package_list_imagick = [
	'ImageMagick',
	'ImageMagick-devel',
	'php-devel',
	'php-pear',
	'php-gd',
	'make',
	]

	package { $package_list_imagick:
		ensure => latest,
		require => Exec['dnf-powertools'],
	}

	# условие imagic для корректной установки
	~> exec { 'pecl-imagick':
		command => 'pecl install -f imagick',
		path    => '/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin',
		onlyif  => 'pecl list 2>/dev/null | grep imagick -q && exit 1 || exit 0',
	}
	
	~> file { '/etc/php.d/20-imagick.ini':
		content => 'extension=imagick.so',
		ensure  => file,
		mode => '0664',
	}

	~> exec { 'rm php-fpm.conf':
		command => 'rm -f php-fpm.conf',
		cwd		=> '/etc/nginx/conf.d',
		path    => '/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin',
	}
}