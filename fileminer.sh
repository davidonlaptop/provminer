#!/bin/bash

###############
# VARIABLES
###############
# mode size(bytes) user group ctime mtime path
FORMAT="%A\t%s\t%U\t%G\t%W\t%Y\t%N\n"

# Directory where this script is stored in
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Directory where to store the output of this script
OUTPUT_DIR="$SCRIPT_DIR/output"
LOGFILE="$OUTPUT_DIR/paths.log"
CSVFILE="$OUTPUT_DIR/paths.csv"
ERRFILE="$OUTPUT_DIR/paths.errors"


###############
# FUNCTIONS
###############
timestamp() {
	date +"%T"
}
log() {
	MSG="$@"
	echo -e `timestamp` "\t$MSG"
	echo -e `timestamp` "\t$MSG" >> $LOGFILE
}

parsedir() {
	SCANPATH="$1"
	find $SCANPATH -exec stat --printf $FORMAT {} \+  >>  $CSVFILE  2>>  $ERRFILE
}



###############
# MAIN LOOP
###############
mkdir -p $OUTPUT_DIR
rm -f $LOGFILE $CSVFILE $ERRFILE

log "*** Scanning for all files in: $@"
log "*** Logging process to file $LOGFILE"
log "*** Logging results to file $CSVFILE"
log "*** Logging errors to file $ERRFILE"

for scanpath in "$@"
do
    realScanpath=$(realpath "$scanpath")

    log "Now scanning $realScanpath ..."
    parsedir "$realScanpath"
done
log "*** Scan completed. See $LOGFILE for more details."

# Warn if errors were found (file size > 0)
if [ -s $ERRFILE ]; then
	log "*** WARNING. Some **ERRORS** occured. See $ERRFILE for more details"
fi

#FIXME: compression works, but sometimes leave the file intact
FILESIZE=$(stat -c%s "$CSVFILE")
#log "*** Compressing $CSVFILE ($FILESIZE bytes) ..."
#gzip $CSFILE
#
#FILESIZE=$(stat -c%s "$CSVFILE.gz")
#log "*** Compressed $CSVFILE.gz ($FILESIZE bytes)."

