class apache {
  package { 'apache2':
    ensure  => present,
  }
  service { 'apache2':
    ensure  => running,
    require => Package["apache2"],
  }
}
