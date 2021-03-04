# pgbouncer Puppet Module

## 2021-03-04 Version 6.0.1

- Migrated to the puppet-functional-tester for managing functional testing.

## 2021-03-03 Version 6.0.0

- Upgraded for Puppet 6 compliance.
- Removed anchor pattern.
- Added support for Ubuntu 16.04, 18.04, and 20.04
- Removed support for Ubuntu 12.04, 14.04, & 15.04
- Updated documentation to support the operating system support changes.
- Added parameter datatypes.
- Removed requirement for Centos to supply RPM repository as centos has pgbouncer in the default repos.
- Changed the pid file path to /var/run/pgbouncer for both centos and debian oses.

## 2017-12-22

- Added a paramater for setting the timeout of database pool connections.

## 2016-06-14

- Fixed an issue with the pid file.

## 2016-01-26 Version 0.1.9, 0.1.8, 0.1.7, 0.1.6

- Added support for centos
- Added user owner and group to userlist.txt
- Added vagrant directory for testing
- Updated Rakefile for automated testing (lint)
- Added a params class which has OS dependant configuration.

## 2015-06-21 Version 0.1.5, 0.1.4

- Updated documentation

## 2015-06-21 Version 0.1.3

- Merged community changes to clean up doco
- Moved contributors to a text file

## 2015-03-04 Version 0.1.2

- Migrated from github to bitbucket
- Changed ownership of puppetforge account
- Change log migrated to markdown.

## 2015-02-20 Version 0.1.1

- Added openhub badge to readme.
- Added pool_mode
- Added auth_type

## 2015-02-19 Version 0.1.0

- Initial Version.
