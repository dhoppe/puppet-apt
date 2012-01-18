class apt {
	define apt::url($debian = false, $ubuntu = false, $source = false) {
		$t_debian = $debian ? {
			false   => "ftp.de.debian.org",
			default => $debian,
		}

		$t_debian_src = $source ? {
			false   => "ftp.de.debian.org",
			default => $debian,
		}

		$t_ubuntu = $ubuntu ? {
			false   => "de.archive.ubuntu.com",
			default => $ubuntu,
		}

		$t_ubuntu_src = $source ? {
			false   => "de.archive.ubuntu.com",
			default => $ubuntu,
		}

		file { "$name":
			owner   => root,
			group   => root,
			mode    => 0644,
			content => template("apt/$lsbdistcodename/etc/apt/sources.list.erb"),
			notify  => Exec["aptitude-update"],
		}
	}

	exec { "aptitude-update":
		command     => "aptitude update",
		refreshonly => true,
	}

	if $lsbdistcodename == "lenny" {
		file { "/etc/apt/apt.conf.d/10periodic":
			owner  => root,
			group  => root,
			mode   => 0644,
			source => "puppet:///modules/apt/$lsbdistcodename/etc/apt/apt.conf.d/10periodic",
		}

		file { "/etc/apt/apt.conf.d/20archive":
			owner  => root,
			group  => root,
			mode   => 0644,
			source => "puppet:///modules/apt/$lsbdistcodename/etc/apt/apt.conf.d/20archive",
		}
	} else {
		file { "/etc/apt/apt.conf.d/10periodic":
			owner  => root,
			group  => root,
			mode   => 0644,
			source => "puppet:///modules/apt/common/etc/apt/apt.conf.d/10periodic",
		}
	}

	if $lsbdistcodename == "lenny" {
		file { "/etc/apt/preferences":
			owner  => root,
			group  => root,
			mode   => 0644,
			source => "puppet:///modules/apt/$lsbdistcodename/etc/apt/preferences",
		}
	} else {
		file { "/etc/apt/preferences.d":
			force   => true,
			purge   => true,
			recurse => true,
			owner   => root,
			group   => root,
			mode    => 0644,
			source  => [
				"puppet:///modules/apt/$lsbdistcodename/etc/apt/preferences.d/$hostname",
				"puppet:///modules/apt/$lsbdistcodename/etc/apt/preferences.d"
			],
		}
	}

	apt::url { "/etc/apt/sources.list":
		debian => "192.168.122.1",
		ubuntu => "192.168.122.1",
		source => false,
	}

	file { "/etc/apt/sources.list.d":
		force   => true,
		purge   => true,
		recurse => true,
		owner   => root,
		group   => root,
		mode    => 0644,
		source  => [
			"puppet:///modules/apt/$lsbdistcodename/etc/apt/sources.list.d/$hostname",
			"puppet:///modules/apt/$lsbdistcodename/etc/apt/sources.list.d"
		],
		notify  => Exec["aptitude-update"],
	}
}

# vim: tabstop=3