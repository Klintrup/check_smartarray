#!/bin/sh
# NRPE check for Proliant SmartArray Controllers (ciss)
# Written by: Søren Klintrup <soren at klintrup.dk>
# version 1.3.1

PATH=/sbin:/bin:/usr/sbin:/usr/bin
DEVICES=$(camcontrol devlist|grep "COMPAQ"|sed -Ee 's/.*(pass[0-9]{1,3}).*/\1/')
unset ERRORSTRING
unset OKSTRING

for DEVICE in ${DEVICES}
do
 DEVICENAME="$(camcontrol devlist|grep ${DEVICE}|sed -Ee 's/.*(da[0-9]{1,3}).*/\1/')"
 DEVICESTRING=$(camcontrol inquiry ${DEVICE} -D|cut -d '<' -f 2|cut -d '>' -f 1)
 case $(echo ${DEVICESTRING}|tr A-Z a-z|sed -Ee 's/.*(rea|int|rec|fai|ok).*/\1/') in
  int)
   ERR=2
   ERRORSTRING="${ERRORSTRING} | ${DEVICENAME}: DEGRADED"
   ;;
  fai)
   ERR=2
   ERRORSTRING="${ERRORSTRING} | ${DEVICENAME}: FAILED"
   ;;
  rec)
   if ! [ "${ERR}" = 2 ]; then ERR=1;fi
   ERRORSTRING="${ERRORSTRING} | ${DEVICENAME}: rebuilding"
   ;;
  rea)
   if ! [ "${ERR}" = 2 ]; then ERR=1;fi
   ERRORSTRING="${ERRORSTRING} | ${DEVICENAME}: ready for recovery"
   ;;
  ok)
   OKSTRING="${OKSTRING} | ${DEVICENAME}: ok"
   ;;
  esac
done
if [ "${ERRORSTRING}" -o "${OKSTRING}" ]
then
 echo ${ERRORSTRING} ${OKSTRING}|sed s/"^| "//
 exit ${ERR}
else
 echo no raid volumes found
 exit 3
fi
