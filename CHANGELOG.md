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
