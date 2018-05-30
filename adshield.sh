#!/usr/bin/env bash
#
#
# AdShield Script
# Written by Benjamin Chafe
echo "AdShield 1.0"




CONFADD="https://raw.githubusercontent.com/bchafe/adshield/master/.adshieldrc"
# CONFIG - This variable holds the location of the config
# file. This file holds different settings for variables you can change.
CONF="$SUDO_USER/.adshieldrc"
source $CONF




if  ! [ -e $CONF ]
then


  echo "No config file found! Downloading config file"
  touch $CONF
  curl  $CONFADD > $CONF
  if [ $? == 0 ]
  then
    echo "Config successfully downloaded."

  else
    echo "Error: Downloading config file failed. Make sure 'curl' is"
    echo "installed, your internet connection is active and this address"
    echo "is accesible: $ADDRESS"
    exit 1
  fi
fi

if ! [ -e $DIR ]
then
  echo "$DIR not found, Making directory..."
  mkdir $DIR


  if [ $? == 0]
  then

    echo "Successful."

  else

    echo "Failed."
    exit 1

  fi


  echo "Copying hosts file to hosts.old..."
  cat $HOSTSFILE > $HOSTSOLD

  if [ $? == 0 ]
  then

    echo "Successful."

  else

    echo "Failed."
    exit 1

  fi
  echo "Downloading patch file..."
  curl $ADDRESS > $PATCH
  if [ $? == 0 ]
  then

    echo "Successful."

  else

    echo "Failed."
    exit 1

  fi

  echo "Updating hosts file..."
  cat $HOSTSOLD > $HOSTSFILE

  if ! [ $? == 0 ]
  then
    echo "Failed."
    exit 1

  fi
  cat $PATCH >> $HOSTSFILE

  if [ $? == 0 ]
  then

    echo "Successful."

  else

  echo "Failed."
    exit 1

  fi
  echo "Setup Complete. So long, ads!"




elif [ "curl $ADDRESS | diff $PATCH -" == 1 ]
then


  curl $ADDRESS > $PATCH
  if [ $? == 0 ]
  then

    echo "Successful."

  else

    echo "Failed."
    exit 1

  fi

  echo "Updating hosts file..."
  cat $HOSTSOLD > $HOSTSFILE

  if ! [ $? == 0 ]
  then
    echo "Failed."
    exit 1

  fi
  cat $PATCH >> $HOSTSFILE

  if [ $? == 0 ]
  then

    echo "Successful."

  else

  echo "Failed."
    exit 1

  fi
  echo "Update Complete!"

else


  echo "No updates found."


fi
