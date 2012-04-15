class apt {
	define apt::url($debian = false, $ubuntu = false, $source = false) {
		$t_debian = $debian ? {
			false   => $::lsbdistcodename ? {
				lenny   => 'archive.debian.org',
				squeeze => 'ftp.de.debian.org',
			},
			default => $debian,
		}

		$t_debian_src = $source ? {
			false   => $::lsbdistcodename ? {
				lenny   => 'archive.debian.org',
				squeeze => 'ftp.de.debian.org',
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

		file { "$name":
			owner   => root,
			group   => root,
			mode    => '0644',
			notify  => Exec['aptitude-update'],
			content => template("apt/${::lsbdistcodename}/etc/apt/sources.list.erb"),
		}
	}

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
			owner  => root,
			group  => root,
			mode   => '0644',
			source => 'puppet:///modules/apt/common/etc/apt/apt.conf.d',
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

# vim: tabstop=3