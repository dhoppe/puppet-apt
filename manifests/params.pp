class apt::params {
  case $::lsbdistcodename {
    'squeeze': {
      $mirror = hiera('debian')
      $source = hiera('source') ? {
        false => 'ftp.de.debian.org',
        true  => $mirror,
      }
    }
    'maverick', 'natty': {
      $mirror = hiera('ubuntu')
      $source = hiera('source') ? {
        false => 'de.archive.ubuntu.com',
        true  => $mirror,
      }
    }
    default: {
      fail("Module ${module_name} does not support ${::lsbdistcodename}")
    }
  }
}
