#!/bin/sh
# NRPE check for Proliant SmartArray Controllers (ciss)
# Written by: Søren Klintrup <github at klintrup.dk>
# Get your copy from: https://github.com/Klintrup/check_smartarray/

unset ERRORSTRING
unset OKSTRING
unset ERR

PATH="/sbin:/bin:/usr/sbin:/usr/bin"
if [ -x "/sbin/camcontrol" ]
then
 # shellcheck disable=SC2086
 DEVICES="$(camcontrol devlist|grep -Ee "(HP|COMPAQ) RAID"|sed -Ee 's/.*(pass[0-9]{1,3}).*/\1/')"
else
 ERRORSTRING="camcontrol binary does not exist on system"
 ERR=3
fi

for DEVICE in ${DEVICES}
do
 # shellcheck disable=SC2086
 DEVICENAME="$(camcontrol devlist|grep ${DEVICE}|sed -Ee 's/.*(da[0-9]{1,3}).*/\1/')"
 # shellcheck disable=SC2086
 DEVICESTRING="$(camcontrol inquiry ${DEVICE} -D|sed -n -e 's/^[^<]*<\([^>]*\)>.*$/\1/p')"
 # shellcheck disable=SC2086
 if [ "$(echo ${DEVICESTRING}|tr '[:upper:]' '[:lower:]'|sed -Ee 's/.*(rea|int|exp|rec|fai|ok).*/\1/')" = "" ]
 then
  ERRORSTRING="${ERRORSTRING} / ${DEVICENAME}: unknown state"
  if ! [ "${ERR}" = 2 ];then ERR=3;fi
 else
  # shellcheck disable=SC2086
  case $(echo ${DEVICESTRING}|tr '[:upper:]' '[:lower:]'|sed -Ee 's/.*(rea|int|exp|rec|fai|ok).*/\1/') in
   int)
    ERR=2
    ERRORSTRING="${ERRORSTRING} / ${DEVICENAME}: DEGRADED"
    ;;
   fai)
    ERR=2
    ERRORSTRING="${ERRORSTRING} / ${DEVICENAME}: FAILED"
    ;;
   rec)
    if ! [ "${ERR}" = 2 ] || [ "${ERR}" = 3 ]; then ERR=1;fi
    ERRORSTRING="${ERRORSTRING} / ${DEVICENAME}: rebuilding"
    ;;
   exp)
    if ! [ "${ERR}" = 2 ] || [ "${ERR}" = 3 ]; then ERR=1;fi
    ERRORSTRING="${ERRORSTRING} / ${DEVICENAME}: expanding"
    ;;
   rea)
    if ! [ "${ERR}" = 2 ] || [ "${ERR}" = 3 ]; then ERR=1;fi
    ERRORSTRING="${ERRORSTRING} / ${DEVICENAME}: ready for recovery"
    ;;
   ok)
    OKSTRING="${OKSTRING} / ${DEVICENAME}: ok"
    ;;
   esac
 fi
done

if [ "${1}" ]
then
 if [ "${ERRORSTRING}" ]
 then
  echo "${ERRORSTRING} ${OKSTRING}"|sed s/"^\/ "//|mail -s "$(hostname -s): ${0} reports errors" -E "${@}"
 fi
else
if [ "${ERRORSTRING}" ] || [ "${OKSTRING}" ]
 then
  echo ${ERRORSTRING} ${OKSTRING}|sed s/"^\/ "//
  exit ${ERR}
 else
  echo no raid volumes found
  exit 3
 fi
fi