#!/bin/sh
#
# zfsuserrefs.sh: Calculates the sum of all ZFS userrefs
# (C) 2016 Joseph Benden <joe@benden.us>
#
# This script calculates the total count of all ZFS userrefs (created
# from calling zfs hold/release) on the ZFS pool/volume/dataset and
# its decendents, for the named snapshot given.
#
# This calculation is critically necessary before removing any ZFS
# snapshot, as removing a snapshot must NOT happen when the system's
# administrator has held a snapshot for their own purposes.
#
#######################################################################
# Scripts required parameters:
#
# Args $1 = ZFS volume/dataset
# Args $2 = lpreserver auto-created snapshot name
#######################################################################

# Source our functions
PROGDIR="/usr/local/share/lpreserver"

# Source our variables
. /usr/local/share/pcbsd/scripts/functions.sh
. ${PROGDIR}/backend/functions.sh

set -euf

DATASET="${1}"
SNAPSHOT="${2}"

if [ -z "${DATASET}" ]; then
  exit_err "No dataset specified!"
fi

if [ -z "${SNAPSHOT}" ]; then
  exit_err "No snapshot specified!"
fi

countZFSUserRefs()
{
  TPIPE=/tmp/zfs-userrefs-$$
  CNT=0

  mkfifo ${TPIPE}
  chmod 0600 ${TPIPE}

  zfs list -Hp -r -t filesystem,volume -o name,mounted "${1}" > ${TPIPE} &

  while read ZNAME ZMNTSTAT; do
    #echo "ZNAME=${ZNAME}"
    #echo "ZMNTSTAT=${ZMNTSTAT}"
    if [ "${ZMNTSTAT}" != "yes" ]; then
      continue
    fi

    item_count=$(zfs list -Hp -d 1 -t snapshot -o userrefs ${ZNAME}@${2} 2>/dev/null || echo 0)
    if [ $? -eq 0 -a "x$item_count" != "x" ]; then
      CNT=$(($CNT + $item_count))
    fi

    echo_log "INFO: ${ZNAME} has ${item_count} references held"
  done < ${TPIPE}

  rm ${TPIPE}

  echo $CNT
}

countZFSUserRefs "${DATASET}" "${SNAPSHOT}"
