#!/bin/bash
# Generate random hostname from a list
# 1. Run as root
# 2. Make this file executable before running: chmod +x generate_random_hostname.sh
# 3. Have a list in the root directory called: hostnamelist.txt
# 4. Run: bash generate_random_hostname.sh
# 5. Append line to /etc/rc.local:
#       nohup /root/generate_random_hostname.sh &
#       This must be before: exit 0

# Random Sort the hostnamelist.txt file, then pipe the first line on the list and output it the file /root/newname.txt
sort -R /root/hostnamelist.txt | head -n 1 > /root/newname.txt

# New hostname is declared by concatenating the contents of /root/newname.txt file
newhost=$(cat /root/newname.txt)
newhost=$newhost$RANDOM

# Backup /etc/hosts & /etc/hostname files
cp /etc/hosts /root/hosts.old
cp /etc/hostname /root/hostname.old

# Replace the string "metasploitable" with $newhost variable in the file /root/newhostfile.txt
# This is used for testing purposes
#sed -i "s/metasploitable/$newhost/g" /root/testme
sed -i "s/metasploitable/$newhost/g" /etc/hosts

# NOTE there is a Carriage Return Line Feed that is added in sed for some reason in this distro of Ubuntu 8.04...
# It needs to be removed!
# Remove carriage return line feed from /root/newhostsfile.txt and overwrite the /etc/hosts file
tr -d '\r' < /etc/hosts > /root/hosts.new
cat /root/hosts.new > /etc/hosts

# Remove carriage return line feed from /root/newname.txt and overwrite the /etc/hostname file
echo $newhost > /root/notnewname.txt
tr -d '\r' < /root/notnewname.txt > /root/hostname.new
cat /root/hostname.new > /etc/hostname

# Update hostname now
updatehostname=$(cat /etc/hostname)
hostname $updatehostname

# Reset Monit ID, adding sleep random between 1 - 30 because we do not want to wait long
randomnumber=$(echo $((1 + RANDOM % 30)))
echo "Waiting $randomnumber Seconds to reset Monit ID"
sleep $randomnumber && yes | monit -r

# Delete this script after running once
rm -r /root/generate_random_hostname.sh

# Reboot machine
reboot
