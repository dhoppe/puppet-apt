define apt::url($debian = false, $ubuntu = false, $source = false) {
  $t_debian = $debian ? {
    false   => $::lsbdistcodename ? {
      lenny   => 'archive.debian.org',
      default => 'ftp.de.debian.org',
    },
    default => $debian,
  }

  $t_debian_src = $source ? {
    false   => $::lsbdistcodename ? {
      lenny   => 'archive.debian.org',
      default => 'ftp.de.debian.org',
    },
    default => $debian,
  }

  $t_ubuntu = $ubuntu ? {
    false   => 'de.archive.ubuntu.com',
    default => $ubuntu,
  }

  $t_ubuntu_src = $source ? {
    false   => 'de.archive.ubuntu.com',
    default => $ubuntu,
  }

  file { $name:
    owner   => root,
    group   => root,
    mode    => '0644',
    notify  => Exec['aptitude-update'],
    content => template("apt/${::lsbdistcodename}/etc/apt/sources.list.erb"),
  }
}