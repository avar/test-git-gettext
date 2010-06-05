#!/bin/sh

git clone git://github.com/avar/git.git git-gettext
cd git-gettext
git checkout -b gettext remotes/origin/topic/git-gettext

# Use GNU make
MAKE=make
gmake --version | grep GNU && MAKE=gmake

# Test with and without gettext
make prefix=/tmp all test NO_GETTEXT=YesPlease
git clean -qdX > /dev/null
make prefix=/tmp all test NO_GETTEXT=YesPlease