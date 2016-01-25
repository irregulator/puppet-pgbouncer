
  # variables
  $user = 'admin'
  $pass = 'admin'
  $db   = 'test'

  # create the postgresql server
  class { 'postgresql::server':
    listen_addresses     => '*',
    pg_hba_conf_defaults => false,
    encoding             => 'UTF8',
  }

  # add permissions rules
  Postgresql::Server::Pg_hba_rule {
    database => 'all',
    user     => 'all',
  }

  postgresql::server::pg_hba_rule { 'local postgres':
    type        => 'local',
    user        => 'postgres',
    auth_method => 'trust',
    order       => '001',
  }

  postgresql::server::pg_hba_rule { 'ipv4 local connections':
    type        => 'host',
    user        => 'all',
    address     => '127.0.0.1/32',
    auth_method => 'md5',
    order       => '02',
  }
  postgresql::server::pg_hba_rule { 'ipv4 private IP connections':
    type        => 'host',
    user        => 'all',
    address     => '192.168.0.0/16',
    auth_method => 'md5',
    order       => '03',
  }

  postgresql::server::pg_hba_rule { 'ipv4 localhost connections':
    type        => 'host',
    user        => 'all',
    address     => '127.0.0.1/32',
    auth_method => 'md5',
    order       => '04',
  }


  # create a login role
  postgresql::server::role { $user:
    password_hash => postgresql_password($user,$pass),
    superuser     => true,
  }

  # create a database
  postgresql::server::database {$db: }

  class {'pgbouncer':
    databases => ["${db} = host=127.0.0.1 port=5432"],
    auth_list => [ "\"postgres\" \"postgres\"",
      "\"${user}\" \"${pass}\""
    ],
    rpm_url   => $::pg_rpm_url,
    rpm_name  => $::pg_rpm_name,
    require   => [
      Class['postgresql::server'],
      Postgresql::Server::Database[$db],
      Postgresql::Server::Role[$user]
    ],
  }
