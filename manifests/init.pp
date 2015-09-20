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
#   Default: /var/log/postgresql/pgbouncer.log
#
# [*pidfile*]
#   The full path to the pid file for the pgbouncer process.
#   Default: /var/run/postgresql/pgbouncer.pid
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
#
# [*options*]
#   Add your own custom extra options to the config file
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
  $databases = [''],
  $logfile = '/var/log/postgresql/pgbouncer.log',
  $pidfile = '/var/run/postgresql/pgbouncer.pid',
  $listen_addr = '*',
  $listen_port = '6432',
  $admin_users = 'postgres',
  $stats_users = 'postgres',
  $auth_type = 'trust',
  $auth_list = undef,
  $pool_mode = 'transaction',
  $default_pool_size = 20,
  $options = {},
){

  # === Variables === #
  $confdir = '/etc/pgbouncer'
  $conf    = "${confdir}/pgbouncer.ini"

  # check OS family
  if $::osfamily != 'debian' {
    fail("Unsupported OS ${::osfamily}.  Please use a debian based system")
  }

  anchor{'pgbouncer::begin':}

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
  }

  service {'pgbouncer':
    ensure    => running,
    subscribe => File["${confdir}/userlist.txt", $conf],
  }

  anchor{'pgbouncer::end':
    require => Service['pgbouncer'],
  }
}
