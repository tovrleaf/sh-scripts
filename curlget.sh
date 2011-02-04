#!/bin/sh

# @author Niko Kivelä <niko@tovrleaf.com>
# @since Tue Jan 01 23:50:57 EEST 2011

#
# curlget [options] <URL> [output]
#
# Project started as an alias for curl -O as a substitute for missing wget functionality from OSX.
# curl -O has an option -o to rename the output file, but it overwrites existing names.
# To add more functionality, e.g. recursive fetching - it's easier to just download
# and compile wget :)
#
# using: basename, pwd, curl, mv
#


# 1. functions
function get_free_filename()
{
    NEWNAME=$1
    i=1
    until [ ! -f $NEWNAME ]; do
        NEWNAME="$1.$i"             # imitiate wget's behavior when avoidin overwrite
        i=$(( i + 1 ))
    done
    echo $NEWNAME
}

function display_help_exit()
{
    echo "NAME:         curlget - transfer a URL"
    echo "SYNOPSIS:     Usage: curlget: [-h] [-N] <URL> [output]"
    echo "DESCRIPTION:  Partial copy of wget by using curl."
    echo "              Allows to download single file, define output"
    echo "              and prevents unintentional overwriting of files."
    echo "OPTIONS:      -h Display this help."
    echo "              -N Overwrite file, if it exists with a same name."
    echo "              <URL> Remote file name to use for saving is extracted from"
    echo "                    the given URL."
    echo "              [output] Write output to a user given name instead of stdout."
    exit 0
}

function display_usage()
{
    printf "Usage: %s: [-h] [-N] <URL> [output]\n" $(basename $0) >&2
}

if [ -z "$1" ]; then
    display_usage
    exit 1
fi

# 2. options
OPT_OVERWRITE=0
while getopts 'Nh' OPTION
do
    case $OPTION in
    N) OPT_OVERWRITE=1 ;;
    h) display_help_exit ;;
    ?)  display_usage
        exit 2;
        ;;
    esac
done
# The variable $OPTIND is an index into the arguments that getopts uses to
# keep track of where it is when it parses.
shift $(($OPTIND - 1))


# 3. variables
REMOTEFILE=$1
OUTPUT=$2

FILENAME=`basename $REMOTEFILE`
TEMPNAME=/tmp/$RANDOM
while [ -f $TEMPNAME ]; do
    TEMPNAME=/tmp/$RANDOM           # generate a new random name, it's taken
done


# 4. the program: curlget
if [ $OUTPUT ]; then
    if [ -d $OUTPUT ]; then
        MOVETO="$OUTPUT/$FILENAME"
    else
        MOVETO=$OUTPUT              # user given name to file
    fi
else
    MOVETO="`pwd`/$FILENAME"
fi

curl -o $TEMPNAME $REMOTEFILE

# file name exists, generate a new one
if [ -f $MOVETO -a $OPT_OVERWRITE -eq 0 ]; then
    MOVETO=`get_free_filename $MOVETO`
fi

mv $TEMPNAME $MOVETO                # move file to its final destination

exit 0
