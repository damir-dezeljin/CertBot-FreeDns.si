#!/bin/bash
# Copyright 2018, Anthony Wharton
# Script that logs into FreeDNS.afraid.org and cleans up the _acme-challenge
# TXT record as created by the certbotFreeDNSAuthHook.sh script.
# This was made for my need to automate wildcard renewals which cannot work
# automatically.

# TODO: Update to your FreeDNS.afraid.org username and password.
USERNAME='user%40domain.com'  # Username for FreeDNS
PASSWORD='verysecurepassword' # Password for FreeDNS

# Ok, stop modifying now :P
WORKINGDIR="/tmp/CERTBOT_$CERTBOT_DOMAIN"
COOKIEFILE="$WORKINGDIR/cookies.tmp"
TXTID_FILE="$WORKINGDIR/TXT_ID"

echo "==============================================="
echo "Cleaning up..."
if [ ! -f $COOKIESFILE ]; then
	echo "No saved cookies found... Logging in..."
	curl -s "https://freedns.afraid.org/zc.php?step=2 " -c $COOKIEFILE -d "action=auth" -d "submit=Login" -d "username=$USERNAME" -d "password=$PASSWORD"
fi

if [ -f $TXTID_FILE ]; then
	TXT_ID=$(cat $TXTID_FILE)
	echo "Deleting TXT record ID ($TXT_ID)..."
	curl -s "https://freedns.afraid.org/subdomain/delete2.php?data_id%5B%5D=$TXT_ID&submit=delete+selected" -b $COOKIEFILE
fi

rm -vrf $WORKINGDIR
echo "DONE"
echo "==============================================="