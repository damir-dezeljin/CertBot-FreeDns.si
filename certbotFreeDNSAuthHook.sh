#!/bin/bash
# Copyright 2018, Anthony Wharton
# Script that logs into FreeDNS.afraid.org and puts in the _acme-challenge TXT
# record as required by certbot for let's encrypt certificates.
# This was made for my need to automate wildcard renewals which cannot work
# automatically.

# TODO: Update to your FreeDNS.afraid.org username and password.
USERNAME='user%40domain.com'  # Username for FreeDNS
PASSWORD='verysecurepassword' # Password for FreeDNS

WORKINGDIR="/tmp/CERTBOT_$CERTBOT_DOMAIN"
COOKIEFILE="$WORKINGDIR/cookies.tmp"
TXTID_FILE="$WORKINGDIR/TXT_ID"

if [ ! -d $WORKINGDIR ]; then
	mkdir -m 0700 $WORKINGDIR
fi

echo "==============================================="
echo "Logging in..."
curl -s "https://freedns.afraid.org/zc.php?step=2 " -c $COOKIEFILE -d "action=auth" -d "submit=Login" -d "username=$USERNAME" -d "password=$PASSWORD"

echo "Getting domain ID..."
DOM_ID=$(curl -s "https://freedns.afraid.org/subdomain/" -b $COOKIEFILE | sed --posix "s/.*$CERTBOT_DOMAIN.*domain_id=\\([0-9]*\\).*/\\1/;t;d")
echo "Domain ID: $DOM_ID"

echo "Getting current TXT record ID (if existent)..."
TXT_ID=$(curl -s "https://freedns.afraid.org/subdomain/" -b $COOKIEFILE | sed --posix 's/.*data_id=\([0-9]*\)>_acme-challenge.*/\1/;t;d')

echo "Creating/Updaing TXT record..."
curl -s "https://freedns.afraid.org/subdomain/save.php?step=2" -b $COOKIEFILE -d "type=TXT" -d "subdomain=_acme-challenge" -d "domain_id=$DOM_ID" -d "address=%22$CERTBOT_VALIDATION%22" -d "data_id=$TXT_ID" -d "send=Save%21"

TXT_ID=$(curl -s "https://freedns.afraid.org/subdomain/" -b $COOKIEFILE | sed --posix 's/.*data_id=\([0-9]*\)>_acme-challenge.*/\1/;t;d')
echo "TXT record ID: $TXT_ID"
echo Saving ID for cleanup...
echo $TXT_ID > $TXTID_FILE

echo Auth Step DONE, Sleeping to allow for DNS records to proporgate
sleep 15
echo "==============================================="