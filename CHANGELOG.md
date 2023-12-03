# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.3.0] - 2007-01-13
### Added
- Initial public release
## [1.3.1] - 2007-01-19
### Changed
- Using tr to replace the string-output from camcontrol, for a more human-readable script, no changes in functionality.
## [1.4.0] - 2007-02-08
### Changed
- If a volume didn't have a known state, it just wouldn't show that volume, it now exits with errorcode3 and outputs as "unknown state"
## [1.4.1] - 2007-02-14
### Changed
- Patch by Christoph Schug applied to replace two (cut) systemcalls with one (sed) when getting DEVICESTRING.
- Added quotes in various places for consistency
- Don't set state to unknown if state is already critical (for code added in 1.4)
- unset $ERR before doing anything to avoid problems if the variable is already set
## [1.4.2] - 2007-02-27
### Changed
- The nagios web interface would only show one RAID volume, it seems nagios blocks "|" in the input and throws everything after that away.
- Changed the "|" to a "/" in output
- Thanks to Kai Gallasch for reporting this
## [1.4.3] - 2007-03-23 
### Changed
- Changed tr A-Z a-z to tr [:upper:] [:lower:] to prevent problems with various locales.
- Thanks to Oliver Fromme for reporting this
## [1.4.4] - 2007-04-20
### Added
- Added online expansion
- Thanks to Mikael Antonsen for reporting this
## [1.4.5] - 2007-10-08
### Changed
- Problems with status of ADG (Advanced Data Guarding) Volumes fixed.
- Thanks to Peter Larsen for reporting this
## [1.5.0] - 2014-06-25
### Added
- Can now email an address of choice, just use email address(es) as arguments to shellscript
### Changed
- check if camcontrol binary exists on system before running script
## [1.6.0] - 2014-11-18
### Changed
- HP Finally changed the SCSI output of their latest smart array controllers, updated script to be compatible with both versions
- Thanks to Paul Yates for reporting this and providing sample output
## [1.7.0] - 2014-11-19
### Added
- Added support for FreeBSD 10.1 and later
- Thanks to Marc Peters for reporting this
