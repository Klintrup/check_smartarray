#!/bin/sh
# NRPE check for Proliant SmartArray Controllers (ciss)
# Written by: Søren Klintrup <soren at klintrup.dk>
# version 1.4.4

PATH="/sbin:/bin:/usr/sbin:/usr/bin"
DEVICES="$(camcontrol devlist|grep "COMPAQ RAID"|sed -Ee 's/.*(pass[0-9]{1,3}).*/\1/')"
unset ERRORSTRING
unset OKSTRING
unset ERR

for DEVICE in ${DEVICES}
do
 DEVICENAME="$(camcontrol devlist|grep ${DEVICE}|sed -Ee 's/.*(da[0-9]{1,3}).*/\1/')"
 DEVICESTRING="$(camcontrol inquiry ${DEVICE} -D|sed -n -e 's/^[^<]*<\([^>]*\)>.*$/\1/p')"
 if [ "$(echo ${DEVICESTRING}|tr [:upper:] [:lower:]|sed -Ee 's/.*(rea|int|exp|rec|fai|ok).*/\1/')" = "" ]
 then
  ERRORSTRING="${ERRORSTRING} / ${DEVICENAME}: unknown state"
  if ! [ "${ERR}" = 2 ];then ERR=3;fi
 else
  case $(echo ${DEVICESTRING}|tr [:upper:] [:lower:]|sed -Ee 's/.*(rea|int|exp|rec|fai|ok).*/\1/') in
   int)
    ERR=2
    ERRORSTRING="${ERRORSTRING} / ${DEVICENAME}: DEGRADED"
    ;;
   fai)
    ERR=2
    ERRORSTRING="${ERRORSTRING} / ${DEVICENAME}: FAILED"
    ;;
   rec)
    if ! [ "${ERR}" = 2 -o "${ERR}" = 3 ]; then ERR=1;fi
    ERRORSTRING="${ERRORSTRING} / ${DEVICENAME}: rebuilding"
    ;;
   exp)
    if ! [ "${ERR}" = 2 -o "${ERR}" = 3 ]; then ERR=1;fi
    ERRORSTRING="${ERRORSTRING} / ${DEVICENAME}: expanding"
    ;;
   rea)
    if ! [ "${ERR}" = 2 -o "${ERR}" = 3 ]; then ERR=1;fi
    ERRORSTRING="${ERRORSTRING} / ${DEVICENAME}: ready for recovery"
    ;;
   ok)
    OKSTRING="${OKSTRING} / ${DEVICENAME}: ok"
    ;;
   esac
 fi
done
if [ "${ERRORSTRING}" -o "${OKSTRING}" ]
then
 echo ${ERRORSTRING} ${OKSTRING}|sed s/"^\/ "//
 exit ${ERR}
else
 echo no raid volumes found
 exit 3
fi

