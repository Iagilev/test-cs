# @summary
#   Конфигурация nginx cs-cart
#

class cs_nginx::cs_nginx (
	$root_www = '/srv/www/cscart',
) {
	$path_cs_conf = '/etc/nginx/conf.d/cs-cart.conf'

	package { 'nginx':
		ensure => latest,
	}

	~> file { 'nginx.conf':
		path => '/etc/nginx/nginx.conf',
		owner => 'root',
		group => 'root',
		mode => '0644',
		ensure => file,
		source => 'puppet:///modules/cs_nginx/nginx.conf',
	}

	~> file { $path_cs_conf:
		ensure => file,
		owner => 'root',
		group => 'root',
		mode => '0644',
		content => template('cs_nginx/cs-cart.conf.erb'),
	}

}
