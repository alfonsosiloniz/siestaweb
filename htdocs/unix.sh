#!/bin/sh

# This script will give exec permissions to all files under htdocs
# and will remove suversion files if present

echo "Removing Subversion Files"
find . |grep svn | awk '{print "rm -rf "$0}' | sh
echo "Done"
echo "Giving execution permissions"
chmod -R +x *
echo "Done"

