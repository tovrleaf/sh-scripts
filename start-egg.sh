#!/bin/sh

# @author Niko Kivelä <niko@tovrleaf.com>
# @since Sun Aug 22 22:59:46 EEST 2010

# Check that eggdrop is running and if not, start it again.
# This script should be run with cron.

# NOTE: this same functionality could be be achieved by using the
# built-in script called `botchk`, see http://www.egghelp.org/setup.htm#config

# every confname needs to be unique per system
CONF='MyBotName.eggdrop.conf'
DIR='/path/to/eggdrop/'

if ps -ef | grep -v grep | grep $CONF ; then
        exit 0
else
        cd $DIR
        ./eggdrop $CONF &
        exit 0
fi
