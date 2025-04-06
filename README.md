# monitor HP Smart Array from NRPE / cron for FreeBSD

[![Codacy Badge](https://app.codacy.com/project/badge/Grade/cc158957feef461bad697b8ecedbdd50)](https://app.codacy.com/gh/Klintrup/check_smartarray/dashboard)
[![License Apache 2.0](https://img.shields.io/github/license/Klintrup/check_smartarray)](https://github.com/Klintrup/check_smartarray/blob/main/LICENSE)
[![Latest Release](https://img.shields.io/github/v/release/Klintrup/check_smartarray)](https://github.com/Klintrup/check_smartarray/releases)
[![Contributors](https://img.shields.io/github/contributors-anon/Klintrup/check_smartarray)](https://github.com/Klintrup/check_smartarray/graphs/contributors)
[![Issues](https://img.shields.io/github/issues/Klintrup/check_smartarray)](https://github.com/Klintrup/check_smartarray/issues)
[![build](https://img.shields.io/github/actions/workflow/status/Klintrup/check_smartarray/lint.yml)](https://github.com/Klintrup/check_smartarray/actions/workflows/lint.yml)

## Synopsis

Get the status HP/Compaq SmartArray controllers and output the failed volumes if any such exist.

This only works for FreeBSD, however it doesn't require any special kernel modules as it just queries the controller via the SCSI commands.

## Syntax

`$path/check_smartarray.sh [email] [email]`

If no arguments are specified, the script will assume its run for NRPE.
If one or more email addresses are specified, the script will send an email in case an array reports an error.

## Output Examples

| output             | description                                                                                                                                                                                                            |
| ------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ok                 | The device is reported as ok by the smart array controller                                                                                                                                                             |
| DEGRADED           | The RAID volume is degraded, it's still working but without the safety of RAID, and in some cases with severe performance loss.                                                                                        |
| rebuilding         | The RAID is rebuilding, will return to OK when done                                                                                                                                                                    |
| expanding          | The RAID is expanding, will return to OK when done                                                                                                                                                                     |
| ready for recovery | The RAID is ready for recovery, but not recovering. This can happen if automatic recovery is disabled, and on some smaller versions of the Smart Array Controllers where only one RAID volume can be rebuild at a time |
| unknown state      | Volume is in an unknown state. Please submit a bug report so I can update the script, include the following output. `camcontrol devlist`, `camcontrol inquiry da0 -D` - run the inquiry for every volume on the system. |

## Compatibility

Should work on all smartarray controllers though - if you test on another (working or not) controller, I would like to know, please mail me on soren at klintrup.dk.

I have tested the script on the following controllers

- HP Smart Array 6i
- HP Smart Array 5i
- HP Smart Array P400
- HP Smart Array P410
- HP Smart Array P420
- HP Smart Array P800
