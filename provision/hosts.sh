#!/bin/bash

# Report to shell the new rule domain
echo "# hosts"
echo "$1    $2 $3"

# Add domain in orchester hosts file
gh="$1    $2 $3"
sed -i "/# ENV-START/a $gh" /etc/hosts