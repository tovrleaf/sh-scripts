#!/bin/sh

# @author Niko Kivelä <niko@tovrleaf.com>
# @since Sun Dec 13 23:49:23 EEST 2009

# Backup mysql per dump in $HOME/backups/<daynumber>/<dump>
# Run via cron, or manually when feel like it.

DAY=`/bin/date +%u`

function dumpsql()
{
    /usr/bin/mysqldump -hlocalhost -u$1 -e -p$2 $1 > $HOME/backups/mysqldump-$1.sql && gzip $HOME/backups/mysqldump-$1.sql
    if [ -f $HOME/backups/$DAY/mysqldump-$1.sql.gz ]
    then
        rm $HOME/backups/$DAY/mysqldump-$1.sql.gz
    fi
    mv $HOME/backups/mysqldump-$1.sql.gz $HOME/backups/$DAY/mysqldump-$1.sql.gz
}

# dumpsql <database> <password>
