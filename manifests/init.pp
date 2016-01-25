# == Class: pgbouncer
#
# Installs the pbouncer package and configures the ini.
#
# === Parameters
#
# [*databases*] 
#   An array of entries to be written to the databases section in the 
#   pbbouncer.ini
#   Array entry format:
#     database_alias_name = connection_string
#
# [*logfile*]
#   The full path to the log file.
#   Default: OS dependant, see params class.
#
# [*pidfile*]
#   The full path to the pid file for the pgbouncer process.
#   Default: OS dependant, see params class.
#
# [*listen_addr*]
#   The address that are listened to by pgbouncer.
#   Default: * (all addresses)
#
# [*listen_port*]
#   The port for pgbouncer to listen on.
#   Default: 6432
#
# [*admin_users*]
#   A comma-seperated list of users allowed to access the admin console who
#   then can perform connection pool management operations and obtain
#   information about the connection pools.
#
# [*stats_users*]
#   A comma-seperated list of users allowed to access the admin console
#   who can obtain information about the connection pools.
#
# [*owner_user*]
#   User who owns userlist.txt (and potentially other files). Should be
#   changed to the user pgbouncer runs as.
#   Default: OS dependant, see params class.
#
# [*owner_group*]
#   Group which owns userlist.txt (and potentially other files). Should be
#   changed to the group pgbouncer runs as if not 'postgres'.
#   Default: OS dependant, see params class.
#
# [*userlist_mode*]
#   The mode for the userlist.txt files.
#   Default: '0600'
#
# [*auth_type*]
#   Method used by PgBouncer to authenticate client connections
#   to PgBouncer. Values may be md5, crypt, plain, trust, or any. 
#   Default: trust
#
# [*auth_list*] 
#   An array of auth values (user/password pairs).
#   This array is written to /var/lib/postgresql/pgbouncer.auth line by line.
#   Array entry format: 
#     "\"<username>\" \"<password\"
#
# [*pool_mode*]
#   Specifies when the server connection can be released back
#   into the pool. Values may be session, transaction, or statement. 
#   Default is transaction
#
# [*default_pool_size*]
#   The default connection pool size
#   Default: 20
#
# [*options*]
#   Add your own custom extra options to the config file
#
# [*rpm_url*]
#   The string is the URL to a RPM repository for installing pgbouncer.
#   Only needed for redhat based distros.
#   Leave as undef if you have already configured a yum repo outside of this
#   class.
#   The URLs for your specific OS can be found here:
#   http://yum.postgresql.org/repopackages.php
#   Default: undef
#
# [*rpm_name*]
#   The name of the rpm excluding the extension.
#   This is important as the package resource needs the name to match
#   in order to prevent puppet from trying to install the package again.
#   Note, required if rpm_url is set.
#   Default: undef
#
# === Variables
#
# [*confdir*]
#   The directory that contains the pgbouncer configuration.
#
# [*conf*]
#   The configuration file for pgbouncer.
#
# === Examples
#
#  class { pgbouncer: }
#
# === Copyright
#
# GPL-3.0+
#
class pgbouncer (
  $databases         = [''],
  $logfile           = $pgbouncer::params::logfile,
  $pidfile           = $pgbouncer::params::pidfile,
  $listen_addr       = '*',
  $listen_port       = '6432',
  $admin_users       = 'postgres',
  $stats_users       = 'postgres',
  $owner_user        = $pgbouncer::params::owner_user,
  $owner_group       = $pgbouncer::params::owner_group,
  $userlist_mode     = '0600',
  $auth_type         = 'trust',
  $auth_list         = undef,
  $pool_mode         = 'transaction',
  $default_pool_size = 20,
  $options           = {},
  $rpm_url           = undef,
  $rpm_name          = undef,
) inherits pgbouncer::params {

  anchor{'pgbouncer::begin':}

  # === Variables === #
  $confdir = '/etc/pgbouncer'
  $conf    = "${confdir}/pgbouncer.ini"

  # check OS family
  case $::osfamily {
    'redhat': {
      if $rpm_url {

        package{'pgdg_repo':
          ensure   => installed,
          name     => $rpm_name,
          source   => $rpm_url,
          provider => 'rpm',
          before   => Package['pgbouncer'],
          require  => Anchor['pgbouncer::begin']
        }
      }
    }
    'debian': {
      # do nothing
    }
    default: {
      fail("Unsupported osfamily ${::osfamily}")
    }
  }

  # Same package name for both redhat based and debian based
  # Note, pgbouncer doesn't seem to be available in centos 6.4 or 6.5
  package{'pgbouncer':
    require => Anchor['pgbouncer::begin'],
  }

  # same directory structure
  file{$conf:
    ensure  => file,
    content => template('pgbouncer/pgbouncer.ini.erb'),
    require => Package['pgbouncer'],
  }

  # check if debian
  file{'/etc/default/pgbouncer':
    ensure  => file,
    source  => 'puppet:///modules/pgbouncer/pgbouncer',
    require => Package['pgbouncer'],
    before  => File["${confdir}/userlist.txt"],
  }

  file {"${confdir}/userlist.txt":
    ensure  => file,
    content => template('pgbouncer/userlist.txt.erb'),
    require => File[$conf],
    owner   => $owner_user,
    group   => $owner_group,
    mode    => $userlist_mode,
  }

  service {'pgbouncer':
    ensure    => running,
    subscribe => File["${confdir}/userlist.txt", $conf],
  }

  anchor{'pgbouncer::end':
    require => Service['pgbouncer'],
  }
}
