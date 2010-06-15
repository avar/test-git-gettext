#!/bin/sh

git clone git://github.com/avar/git.git git-gettext
cd git-gettext
git pull # in case git-gettext was here already
git checkout -b gettext remotes/origin/gettext

# Use GNU make
MAKE=make
MYSHELL=/bin/sh
gmake --version | grep GNU && MAKE=gmake
test `uname -s` = "SunOS" && MYSHELL=/usr/bin/ksh

echo "Using make $MAKE and shell $MYSHELL"

# Test data
LOG=/tmp/git-gettext.txt
uname -a > $LOG

# Test with and without gettext
git clean -dxf > /dev/null
$MAKE -j4 prefix=/tmp all NO_CURL=YesPlease NO_GETTEXT=YesPlease
echo "With NO_GETTEXT=YesPlease" >> $LOG
echo "With NO_GETTEXT=YesPlease" >> "$LOG-raw"
(cd t && for test in ./t02*sh; do echo "  $test" && $MYSHELL ./$test 2>&1       | sed 's/^/    /'; done) >> $LOG 2>&1
(cd t && for test in ./t02*sh; do echo "  $test" && $MYSHELL ./$test -d -v 2>&1 | sed 's/^/    /'; done) >> "$LOG-raw" 2>&1

git clean -dxf > /dev/null
$MAKE -j4 prefix=/tmp all NO_CURL=YesPlease
echo "Without NO_GETTEXT=YesPlease" >> $LOG
echo "Without NO_GETTEXT=YesPlease" >> "$LOG-raw"
(cd t && for test in ./t02*sh; do echo "  $test" && $MYSHELL ./$test 2>&1       | sed 's/^/    /'; done) >> $LOG 2>&1
(cd t && for test in ./t02*sh; do echo "  $test" && $MYSHELL ./$test -d -v 2>&1 | sed 's/^/    /'; done) >> "$LOG-raw" 2>&1

echo "Without NO_GETTEXT=YesPlease and TEST_GIT_I18N_EXHAUSTIVE=1 set" >> $LOG
echo "Without NO_GETTEXT=YesPlease and TEST_GIT_I18N_EXHAUSTIVE=1 set" >> "$LOG-raw"
(cd t && for test in ./t02*sh; do TEST_GIT_I18N_EXHAUSTIVE=1 echo "  $test" && $MYSHELL ./$test 2>&1       | sed 's/^/    /'; done) >> $LOG 2>&1
(cd t && for test in ./t02*sh; do TEST_GIT_I18N_EXHAUSTIVE=1 echo "  $test" && $MYSHELL ./$test -d -v 2>&1 | sed 's/^/    /'; done) >> "$LOG-raw" 2>&1

# Gimme test data
cat "$LOG-raw" >> $LOG
rm "$LOG-raw"
echo "Feed $LOG to a pastebin please"
