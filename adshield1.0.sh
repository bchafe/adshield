#!/usr/bin/env bash
#
#
# AdShield Script
# Written by Benjamin Chafe
echo "AdShield 1.0"





# CONFIG - This variable holds the location of the config
# file. This file holds different settings for variables you can change.
CONF="$SUDO_USER/.adshieldrc"
source $CONF


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
