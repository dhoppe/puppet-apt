class apt {
  validate_string(hiera('debian'))
  validate_string(hiera('ubuntu'))

  exec { 'aptitude-update':
    command     => 'aptitude update',
    refreshonly => true,
  }

  if $::lsbdistcodename == 'lenny' {
    file { '/etc/apt/apt.conf.d':
      recurse => true,
      owner   => root,
      group   => root,
      mode    => '0644',
      source  => "puppet:///modules/apt/${::lsbdistcodename}/etc/apt/apt.conf.d",
    }

    file { '/etc/apt/preferences':
      owner  => root,
      group  => root,
      mode   => '0644',
      source => "puppet:///modules/apt/${::lsbdistcodename}/etc/apt/preferences",
    }
  } else {
    file { '/etc/apt/apt.conf.d':
      recurse => true,
      owner   => root,
      group   => root,
      mode    => '0644',
      source  => 'puppet:///modules/apt/common/etc/apt/apt.conf.d',
    }

    file { '/etc/apt/preferences.d':
      force   => true,
      purge   => true,
      recurse => true,
      owner   => root,
      group   => root,
      mode    => '0644',
      source  => "puppet:///modules/apt/${::lsbdistcodename}/etc/apt/preferences.d",
    }
  }

  apt::url { '/etc/apt/sources.list':
    debian => hiera('debian'),
    ubuntu => hiera('ubuntu'),
    source => false,
  }

  file { '/etc/apt/sources.list.d':
    force   => true,
    purge   => true,
    recurse => true,
    owner   => root,
    group   => root,
    mode    => '0644',
    notify  => Exec['aptitude-update'],
    source  => "puppet:///modules/apt/${::lsbdistcodename}/etc/apt/sources.list.d",
  }
}