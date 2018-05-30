#!/usr/bin/env bash
echo "AdScript 1.4"
# TO DO: fix error with checking for updates on line 45
# TO DO: use user ${HOME} folder instead of root's for the
# domains file




# DOMAIN - Variable for location to store domain file. This
# variable holds the location where the domain file, which
# holds the desired domains to block. A blocked domain will
# have '127.0.0.1' before it in the list.
DOMAIN="${HOME}/.ad_domains"


# HOSTFILE - Variable for the location of the hosts file.
# on most systems it should be located at /etc/hosts.
# this file is where our domain file will be linked,
# which is what actually does the blocking.
HOSTFILE="/etc/hosts"


# ADDRESS - Variable for the address of the hosts file
# used for the ad blocking. these types of files are
# already formatted to directly append the system hosts
# file.
ADDRESS="https://hosts-file.net/ad_servers.txt"


if  ! [ -e $DOMAIN ]
then


  echo "No domains file found! Downloading domains file..."
  touch $DOMAIN
  curl  $ADDRESS > $DOMAIN
  if [ $? == 0 ]
  then
    echo "linking domains file in /etc/hosts..."
    sudo sh -c 'echo source $DOMAIN >> /etc/hosts'
    if [ $? == 0 ]
    then

      echo "Ad blocking complete! Run this script again to check for domains file updates."

    else
      echo "Error: Linking to /etc/hosts failed. Check if your system has 'sudo' installed and try again."
    fi


  else
    echo "Error: Downloading domains file failed. Make sure 'curl' is"
    echo "installed, your internet connection is active and this address"
    echo "is accesible: $ADDRESS"
  fi


elif [ "curl $ADDRESS | diff $DOMAIN -" == 1 ]
then


  echo "Updates found. Updating domains file..."
  wget -O $DOMAIN $ADDRESS


else


  echo "No updates found."


fi
