#!/bin/sh

git clone git://github.com/avar/git.git git-gettext
cd git-gettext
git checkout -b gettext remotes/origin/topic/git-gettext

# Use GNU make
MAKE=make
gmake --version | grep GNU && MAKE=gmake

# Test data
LOG=/tmp/git-gettext.txt
uname -a > $LOG

# Test with and without gettext
$MAKE prefix=/tmp all NO_GETTEXT=YesPlease
(cd t && for test in ./t02*sh; do ./$test; done) >> $LOG
git clean -dxf > /dev/null
$MAKE prefix=/tmp all
(cd t && for test in ./t02*sh; do ./$test; done) >> $LOG

# Gimme test data
cat $LOG
