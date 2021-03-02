# @summary Parameters to be set for pgbouncer
#
class pgbouncer::params {
  case $::osfamily {
    'redhat': {
      $log_dir         = '/var/log/pgbouncer'
      $owner_user      = 'pgbouncer'
      $owner_group     = 'pgbouncer'
    }
    'debian': {
      # do nothing
      $log_dir     = '/var/log/postgresql'
      $owner_user  = 'postgres'
      $owner_group = 'postgres'
    }
    default: {
      fail("Unsupported osfamily ${::osfamily}")
    }
  }
  $logfile         = "${log_dir}/pgbouncer.log"
  $pidfile         = '/var/run/pgbouncer/pgbouncer.pid'
  $unix_socket_dir = '/var/run/pgbouncer'
}
