#!/bin/bash
# Copyright 2018, Anthony Wharton
# Single script that can be called that generates certificates using the 
# certbotFreeDNSAuthHook.sh and certbotFreeDNSCleanupHook.sh scripts.

# This should be used as guidence of my usage, and changed to your needs. Note 
# the generic `/path/to/...` and `DOMAIN.COM`, which should be replaced with 
# your script location and domain respectively.

certbot certonly                                                    \
	--dry-run                                                   \
	--agree-tos                                                 \
	--manual-public-ip-logging-ok                               \
	--renew-by-default                                          \
	--manual                                                    \
	--preferred-challenges=dns                                  \
	--manual-auth-hook /path/to/certbotFreeDNSAuthHook.sh       \
	--manual-cleanup-hook /path/to/certbotFreeDNSCleanupHook.sh \
	-d "*.DOMAIN.COM"                                           \
	--server https://acme-v02.api.letsencrypt.org/directory