#!/bin/sh

git clone git://github.com/avar/git.git git-gettext
cd git-gettext
git pull # in case git-gettext was here already
git checkout -b gettext remotes/origin/topic/git-gettext

# Use GNU make
MAKE=make
gmake --version | grep GNU && MAKE=gmake

# Test data
LOG=/tmp/git-gettext.txt
uname -a > $LOG

# Test with and without gettext
git clean -dxf > /dev/null
$MAKE prefix=/tmp all NO_GETTEXT=YesPlease
(cd t && for test in ./t02*sh; do ./$test -d -v; done) >> $LOG 2>&1
git clean -dxf > /dev/null
$MAKE prefix=/tmp all
(cd t && for test in ./t02*sh; do ./$test -d -v; done) >> $LOG 2>&1

# Gimme test data
cat $LOG
echo "Feed $LOG to a pastebin please"
