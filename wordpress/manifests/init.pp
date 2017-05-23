class wordpress (
        $wp_server_user       = 'wordpress',
        $wp_server_group      = 'wordpress',
        $wp_database          = 'prueba',
        $wp_database_user     = 'user_db',
        $wp_database_password = 'prueba123',
        $wp_default_dir       = '/var/www/html'){

        exec { "Download wordpress":
                command =>"/usr/bin/wget http://wordpress.org/wordpress-latest.tar.gz":
                cwd => "/tmp",
        }
        exec { "Uncompress wordpress":
          command => "/bin/tar zxvf wordpress-latest.tar.gz",
          cwd     => "/tmp",
          require => Exec["Download wordpress"],
        }
        exec { "Copy wordpress":
          command => "/bin/cp -a /tmp/wordpress/. /var/www/html/",
          cwd => "/tmp",
          require => Exec['Uncompress wordpress'],
        }
        group {"$wp_server_group":
          ensure => present,
        }
        user {"$wp_server_user":
          ensure => present,
          groups => "$wp_server_group",
          require => Group["$wp_server_group"],
        }
        file {"$wp_default_dir":
          ensure => 'directory',
          owner => "$wp_server_user",
          group => "$wp_server_group",
          recurse => true,
          require => [Group["$wp_server_group"],User["$wp_server_user"],Exec['Copy wordpress']],
        }
        file { "$wp_default_dir/wp-config.php":
          ensure  => present,
          owner   => "$wp_server_user",
          group   => "$wp_server_group",
          mode    => '0644',
          content => template("wordpress/wp-config.php.erb"),
          require => Exec['Copy wordpress'],
        }
        exec{ "Apache reload":
          command => "/etc/init.d/apache2 force-reload",
          require => File["$wp_default_dir/wp-config.php"],
        }
}
