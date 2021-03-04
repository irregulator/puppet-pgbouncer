# pgbouncer Puppet Module

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

## API

See REFERENCE.md

## Limitations

Works with debian and redhat based OS's.

## Development

The module is open source and available on bitbucket.  Please fork!

## Testing

This module uses the [puppet-functional-tester](https://bitbucket.org/landcareresearch/puppet-functional-tester) for testing the supported platforms.
Please see puppet-functional-tester/README.md file additional information.
