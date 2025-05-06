#!/bin/sh
###############################################################
# Solves a problem with GUI apps that require root privileges #
# for DISPLAY and XAUTHORITY local environment variables,     #
# but for some reason, Void doesn't escale these privileges.  #
# The same apps, namely Timeshift and Grub Customizer, seem   #
# to work just fine in Ubuntu with xfce (xUbuntu).            #
#                                                             #
# Name the script pkexec, place it in /usr/local/bin and      #
# chmod +x it to make it executable.                          #
###############################################################
/bin/pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY "$@"
