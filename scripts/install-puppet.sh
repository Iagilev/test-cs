#!/bin/bash

set -e

release=$(cat /etc/centos-release | awk '{print $4}' | awk -F. '{print $1}')

if ! which puppet >/dev/null 2>&1; then
    rpm -Uvh --force https://yum.puppet.com/puppet7-release-el-$release.noarch.rpm
    dnf -y install puppet-agent
fi
