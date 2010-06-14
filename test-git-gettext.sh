#!/bin/sh

git clone git://github.com/avar/git.git git-gettext
cd git-gettext
git pull # in case git-gettext was here already
git checkout -b gettext remotes/origin/gettext

# Use GNU make
MAKE=make
gmake --version | grep GNU && MAKE=gmake

# Test data
LOG=/tmp/git-gettext.txt
uname -a > $LOG

# Test with and without gettext
git clean -dxf > /dev/null
$MAKE prefix=/tmp all NO_CURL=YesPlease NO_GETTEXT=YesPlease
echo "With NO_GETTEXT=YesPlease" >> $LOG
echo "With NO_GETTEXT=YesPlease" >> "$LOG-raw"
(cd t && for test in ./t02*sh; do ./$test; done) | sed 's/^/    /' >> $LOG 2>&1
(cd t && for test in ./t02*sh; do ./$test -d -v; done) | sed 's/^/    /' >> "$LOG-raw" 2>&1

git clean -dxf > /dev/null
$MAKE prefix=/tmp all NO_CURL=YesPlease
echo "Without NO_GETTEXT=YesPlease" >> $LOG
echo "Without NO_GETTEXT=YesPlease" >> "$LOG-raw"
(cd t && for test in ./t02*sh; do ./$test; done) | sed 's/^/    /' >> $LOG 2>&1
(cd t && for test in ./t02*sh; do ./$test -d -v; done) | sed 's/^/    /' >> "$LOG-raw" 2>&1

echo "Without NO_GETTEXT=YesPlease and TEST_GIT_I18N_EXHAUSTIVE=1 set" >> $LOG
echo "Without NO_GETTEXT=YesPlease and TEST_GIT_I18N_EXHAUSTIVE=1 set" >> "$LOG-raw"
(cd t && for test in ./t02*sh; do TEST_GIT_I18N_EXHAUSTIVE=1 ./$test; done) | sed 's/^/    /' >> $LOG 2>&1
(cd t && for test in ./t02*sh; do TEST_GIT_I18N_EXHAUSTIVE=1 ./$test -d -v; done) | sed 's/^/    /' >> "$LOG-raw" 2>&1

# Gimme test data
cat "$LOG-raw" >> $LOG
rm "$LOG-raw"
echo "Feed $LOG to a pastebin please"
