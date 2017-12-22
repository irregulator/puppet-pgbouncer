# pgbouncer

[![Puppet Forge](http://img.shields.io/puppetforge/v/landcareresearch/pgbouncer.svg)](https://forge.puppetlabs.com/landcaresearch/pgbouncer)
[![Bitbucket Build Status](http://build.landcareresearch.co.nz/app/rest/builds/buildType%3A%28id%3ALinuxAdmin_PuppetPgbouncer_PuppetPgbouncer%29/statusIcon)](http://build.landcareresearch.co.nz/viewType.html?buildTypeId=LinuxAdmin_PuppetPgbouncer_PuppetPgbouncer&guest=1)
[![Project Stats](https://www.openhub.net/p/puppet-pgbouncer/widgets/project_thin_badge.gif)](https://www.openhub.net/p/puppet-pgbouncer)

## Overview
Installs and configures [pgbouncer](https://wiki.postgresql.org/wiki/PgBouncer).

## Module Description
This module installs the pgbouncer package and configures it to pool connections for postgresql databases.
By default, the service uses port 6432 as this is the default port of pgbouncer.

## Setup

### What pgbouncer affects

* /etc/pgbouncer/pgbouncer.ini
* /etc/pgbouncer/userlist.txt
* /etc/default/pgbouncer

### Setup Requirements 

Requires a Debian based system.

### Beginning with pgbouncer 

To install pgbouncer and have it connect to a database with default parameters.
Where all pgbouncer is installed on the postgresql server.  The database db2 is available.  An authorized user is postgres with password postgres.

```puppet 
  class{'pgbouncer': 
    databases => [ '* = port=5432',
                   "database2 = host=localhost port=5432 dbname=db2"],
    auth_list => [ "\"postgres\" \"password\""],
  }
```

## Usage

###Classes

This module modifies the pgbouncer configuration files and replaces the main configuration file.

####Class: `pgbouncer`

The primary class that installs and configures pgbouncer.  It also ensures the pgbouncer service is running.

**Parameters within `pgbouncer`:**

#####`databases`
An array of entries to be written to the databases section in the pbbouncer.ini
Array entry format: database_alias_name = connection_string

#####`logfile`
The full path to the log file.  
Default: OS dependant, see params class.

#####`pidfile`
The full path to the pid file for the pgbouncer process.  
Default: OS dependant, see params class.

#####`listen_addr`
The address that are listened to by pgbouncer.
Default: * (all addresses)

#####`listen_port`
The port for pgbouncer to listen on.
Default: 6432

#####`admin_users`
A comma-seperated list of users allowed to access the admin console who
then can perform connection pool management operations and obtain
information about the connection pools.

#####`stats_users`
A comma-seperated list of users allowed to access the admin console
who can obtain information about the connection pools.

##### `owner_user`
User who owns userlist.txt (and potentially other files). Should be changed to the user pgbouncer runs as.  
Default: OS dependant, see params class.

##### `owner_group`
Group which owns userlist.txt (and potentially other files). Should be changed to the group pgbouncer runs as if not 'postgres'.  
Default: OS dependant, see params class.

##### `userlist_mode`
The mode for the userlist.txt files.  
Default: '0600'

#####`auth_type`
Method used by PgBouncer to authenticate client connections
to PgBouncer. Values may be md5, crypt, plain, trust, or any. 
Default: trust

#####`auth_list`
An array of auth values (user/password pairs).
This array is written to /var/lib/postgresql/pgbouncer.auth line by line.

Array entry format: "USERNAME" "PASSWORD"

#####`pool_mode`
Specifies when the server connection can be released back
into the pool. Values may be session, transaction, or statement. 
Default: transaction

##### `default_pool_size`
The default connection pool size.  
Default: 20

#### `autodb_idle_timeout`
If the automatically created (via “*”) database pools have been unused
this many seconds, they are freed. The negative aspect of that is that
their statistics are also forgotten. [seconds]  
Default: 3600.0

##### `options`
Add your own custom extra options to the config file.

##### `rpm_url`
The string is the URL to a RPM repository for installing pgbouncer.
Only needed for redhat based distros.
Leave as undef if you have already configured a yum repo outside of this class.
The URLs for your specific OS can be found here: http://yum.postgresql.org/repopackages.php  
Example: rpm_url => 'http://yum.postgresql.org/9.2/redhat/rhel-7-x86_64/pgdg-centos92-9.2-2.noarch.rpm'  
Default: undef

##### `rpm_name`
The name of the rpm excluding the extension.
This is important as the package resource needs the name to match in order to prevent puppet from trying to install the package again.
Note, required if rpm_url is set.  
Example: rpm_name => 'pgdg-centos92-9.2-2.noarch.rpm'  
Default: undef

## Limitations

Works with debian and redhat based OS's.

## Development

The module is open source and available on bitbucket.  Please fork!

## Testing

This module includes a vagrant directory that contains vagrant code and scripts for testing on the supported platforms.
Please see the readme.md file in the vagrant directory for additional information.
