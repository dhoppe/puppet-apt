class apt::params {
  case $::lsbdistcodename {
    'squeeze': {
      $mirror = hiera('debian')
      $source = hiera('source') ? {
        false => 'ftp.de.debian.org',
        true  => $mirror,
      }
    }
    default: {
      fail("Module ${module_name} does not support ${::lsbdistcodename}")
    }
  }
}
