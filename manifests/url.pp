define apt::url($mirror_deb, $mirror_src) {
  file { $name:
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Exec['aptitude-update'],
    content => template("apt/${::lsbdistcodename}/etc/apt/sources.list.erb"),
  }
}