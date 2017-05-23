class mysql (
        $mysql_password       ='adminpass',
        $wp_database          ='prueba',
        $wp_database_user     ='user_db',
        $wp_database_password ='prueba123' ){
        package { 'mysql-server':
                ensure  => present,
        }
        package { 'mysql-common':
                ensure  => present,
        }
        package { 'python-mysqldb':
                ensure  => present,
        }
        service {'mysql':
                name =>'mysql',
                ensure => running,
                require => Package['mysql-server','mysql-common'],
        }
        exec { "Set mysql-password":
                unless => "mysqladmin -uroot -p$mysql_password status",
                path => ["/bin", "/usr/bin"],
                command => "mysqladmin -uroot password $mysql_password",
                require => Service["mysql"],
        }
        exec {"Create WP database":
                command => "/usr/bin/mysql -uroot -p$mysql_password -e \"create database $wp_database; grant all on *.* to $wp_database_user@localhost identified by '$wp_
database_password';\"",
                require => [Service["mysql"],Exec['Set mysql-password']],
        }
}