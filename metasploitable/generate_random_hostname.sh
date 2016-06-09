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

# Replace the string "metasploitable" with $newhost variable in the file /root/newhostfile.txt
sed -i "s/metasploitable/$newhost/g" /root/newhostsfile.txt

# NOTE there is a Carriage Return Line Feed that is added in sed for some reason in this distro of Ubuntu 8.04... 
# It needs to be removed!
# Remove carriage return line feed from /root/newhostsfile.txt and overwrite the /etc/hosts file
tr -d '\r' < /root/newhostsfile.txt > /etc/hosts

# Remove carriage return line feed from /root/newname.txt and overwrite the /etc/hostname file
tr -d '\r' < /root/newname.txt > /etc/hostname

# Delete this script after running once
rm -r /root/generate_random_hostname.sh


