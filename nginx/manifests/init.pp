class nginx (
    $nginx_config_dir  ='/etc/nginx/sites-available',
    $wp_directory      ='/var/www/html') {
    package {'nginx':
        ensure => present,
    }
    file { "$nginx_config_dir/default":
            ensure  => present,
            mode    => '0644',
            content => template("nginx/default.erb"),
    }
}
