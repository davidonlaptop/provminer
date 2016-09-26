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

# TODO: run as sudo


# Example output:
#lrwxrwxrwx     	15     	root   	root   	0      	1474920411     	'/dev/stdout' -> '/proc/self/fd/1'
#crw-rw-rw-     	0      	root   	root   	0      	1474920411     	'/dev/tty'
#drwxr-xr-x     	4284   	UNKNOWN	staff  	0      	1474920640     	'/home'
#-rw-r--r--     	0      	root   	root   	0      	1474921197     	'emptyfile'
#drwxr-xr-x     	4096   	root   	root   	0      	1474921188     	'mydir'
#-rw-r--r--     	6      	root   	root   	0      	1474921170     	'myfile'
#lrwxrwxrwx     	6      	root   	root   	0      	1474921210     	'mylink' -> 'myfile'
#lrwxrwxrwx     	6      	root   	root   	0      	1474921219     	'mylink2' -> 'mylink'

#TODO:
# TODO: Add error handling
# TODO: resolve symlinks

