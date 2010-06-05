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
NO_SVN_TESTS=1 $MAKE prefix=/tmp all test NO_GETTEXT=YesPlease
(cd t && for test in ./t02*sh; do ./$test; done) >> $LOG
git clean -qdX > /dev/null
NO_SVN_TESTS=1 $MAKE prefix=/tmp all test 
(cd t && for test in ./t02*sh; do ./$test; done) >> $LOG

# Gimme test data
cat $LOG