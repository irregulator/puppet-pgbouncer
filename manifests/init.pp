# @summary Installs the pbouncer package and configures the ini.
#
# @param databases
#   An array of entries to be written to the databases section in the 
#   pbbouncer.ini
#   Array entry format:
#     database_alias_name = connection_string
#
# @param logfile
#   The full path to the log file.
#
# @param pidfile
#   The full path to the pid file for the pgbouncer process.
#   Default: OS dependant, see params class.
#
# @param listen_addr
#   The address that are listened to by pgbouncer.
#
# @param listen_port
#   The port for pgbouncer to listen on.
#
# @param admin_users
#   A comma-seperated list of users allowed to access the admin console who
#   then can perform connection pool management operations and obtain
#   information about the connection pools.
#
# @param stats_users
#   A comma-seperated list of users allowed to access the admin console
#   who can obtain information about the connection pools.
#
# @param owner_user
#   User who owns userlist.txt (and potentially other files). Should be
#   changed to the user pgbouncer runs as.
#   Default: OS dependant, see params class.
#
# @param owner_group
#   Group which owns userlist.txt (and potentially other files). Should be
#   changed to the group pgbouncer runs as if not 'postgres'.
#   Default: OS dependant, see params class.
#
# @param userlist_mode
#   The mode for the userlist.txt files.
#   Default: '0600'
#
# @param auth_type
#   Method used by PgBouncer to authenticate client connections
#   to PgBouncer. Values may be md5, crypt, plain, trust, or any. 
#
# @param auth_list
#   An array of auth values (user/password pairs).
#   This array is written to /var/lib/postgresql/pgbouncer.auth line by line.
#   Array entry format: 
#     "\"<username>\" \"<password\"
#
# @param pool_mode
#   Specifies when the server connection can be released back
#   into the pool. Values may be session, transaction, or statement. 
#
# @param default_pool_size
#   The default connection pool size
#
# @param autodb_idle_timeout
#   If the automatically created (via “*”) database pools have been unused
#   this many seconds, they are freed. The negative aspect of that is that
#   their statistics are also forgotten. [seconds]
#
# @param options
#   Add your own custom extra options to the config file
#
class pgbouncer (
  Array[String]    $databases           = [''],
  String           $logfile             = $pgbouncer::params::logfile,
  String           $pidfile             = $pgbouncer::params::pidfile,
  String           $listen_addr         = '*',
  String           $listen_port         = '6432',
  String           $admin_users         = 'postgres',
  String           $stats_users         = 'postgres',
  String           $owner_user          = $pgbouncer::params::owner_user,
  String           $owner_group         = $pgbouncer::params::owner_group,
  String           $userlist_mode       = '0600',
  String           $auth_type           = 'trust',
  Optional[Array]  $auth_list           = undef,
  String           $pool_mode           = 'transaction',
  Integer          $default_pool_size   = 20,
  String           $autodb_idle_timeout = '3600',
  Hash             $options             = {},
) inherits pgbouncer::params {

  # === Variables === #
  # The directory that contains the pgbouncer configuration.
  $confdir = '/etc/pgbouncer'

  # The configuration file for pgbouncer.
  $conf    = "${confdir}/pgbouncer.ini"

  # Same package name for both redhat based and debian based
  # Note, pgbouncer doesn't seem to be available in centos 6.4 or 6.5
  package{'pgbouncer': }

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

  file{'/var/run/pgbouncer':
    ensure  => directory,
    owner   => $owner_user,
    group   => $owner_group,
    require => Package['pgbouncer'],
  }

  service {'pgbouncer':
    ensure    => running,
    require   => File['/var/run/pgbouncer'],
    subscribe => File["${confdir}/userlist.txt", $conf],
  }
}
