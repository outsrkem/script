#!/bin/bash
packagesdir=base/Packages
reponame=rpms
for fn in `find ${packagesdir} -type f`;do
    sha=`sha256sum $fn`
    pd=$reponame/RPMS/${sha:0:2}/${sha:2:2}
    [ -d "$pd" ] || mkdir -p $pd
    if [ ! -f $pd/$fn ];then
        mv ${fn} $pd
    fi
done
