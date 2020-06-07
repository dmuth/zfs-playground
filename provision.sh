#!/bin/bash
#
# This script is used to confiure our Linux instance.
# It is built to be idempotent, which means it can be run as many times as is needed.
#

# Errors are fatal
set -e

UPDATE_FILE=/var/run/apt-update-last-run


echo "# "
echo "# Making sure apt is up to date..."
echo "# "

#
# Check to see if apt update was run within the last day.
#
FOUND=$(find /var/run/apt-update-last-run -mtime -1 || true)

if test "${FOUND}"
then
	echo "# Oh, apt update was run within the last day, skipping!"

else
	apt update
	touch $UPDATE_FILE

fi


echo "# "
echo "# Installing ZFS..."
echo "# "

FOUND=$(dpkg -l | grep zfsutils || true)

if test ! "${FOUND}"
then
	apt install -y zfsutils-linux

else
	echo "# Oh, ZFS is already installed!  Let's move on..."

fi

echo "# "
echo "# Updating \$PATH for vagrant user..."
echo "# "
FOUND=$( grep "/vagrant/bin" /home/vagrant/.bashrc || true)

if test "${FOUND}"
then
	echo "# Oh, \$PATH is already updated..."

else
	echo "" >> /home/vagrant/.bashrc
	echo 'PATH=$PATH:/vagrant/bin' >> /home/vagrant/.bashrc

fi


echo "# Disabling dynamic MOTD if not done already..."
FOUND=$(grep "session.*motd=/run/motd.dynamic" /etc/pam.d/login || true)
if test ! "${FOUND}"
then
	echo "# Disabling dynamic MOTD from /etc/pam.d/login..."
	sed -i '/^session.*motd=\/run\/motd.dynamic/s/^/### /' /etc/pam.d/login
fi

FOUND=$(grep "session.*motd=/run/motd.dynamic" /etc/pam.d/sshd || true)
if test ! "${FOUND}"
then
	echo "# Disabling dynamic MOTD from /etc/pam.d/sshd..."
	sed -i '/^session.*motd=\/run\/motd.dynamic/s/^/### /' /etc/pam.d/sshd
fi

if test ! -f /etc/motd
then
	echo "# Writing custom /etc/motd file..."
	cat << EOF > /etc/motd
#
# Welcome to the ZFS testing playground!
#
# All relevant scripts are in /vagrant/bin/ which is also in your \$PATH!
#
EOF

fi
