#!/bin/bash
#
# regfish.com DynDNS Version 2 fuer Linux
# --------------------------------------------------
# Fuehren Sie dieses Script jede Minute mit Hilfe
# eines Cronjobs aus.
# --------------------------------------------------
# Version 2.05
# Letzte Aenderung: 08.06.2016
# Copyright (c) regfish.com
# --------------------------------------------------

# Folgende Werte muessen von Ihnen angepasst werden.
# --------------------------------------------------
# FQDN = Hostname (z.B. meinrechner.meinedomain.de.)
# TOKEN = Secure-Token zur Authentifizierung
# IPversion = ipv4 oder ipv46 (ipv4 und ipv6)
# --------------------------------------------------
FQDN=meinrechner.meinedomain.de.
TOKEN=9faff6adf27bebce294ea10d1e2661d4
IPversion=ipv46
# --------------------------------------------------

WGET=`type -p wget`
CAT=`type -p cat`


function update_ipv4 {
    aIPv4=`$WGET -4 -q -O - 'http://dyndns.regfish.de/show_myip.php'`
    SIPv4=`$CAT /tmp/regfish_myIPv4`

#
# Wenn die IP-Adresse sich geaendert hat, wird
# eine DynDNS-Aktualisierung durchgefuehrt.
#
    if [ "$aIPv4" = "$SIPv4" ];then
	exit 0
    else
	rCode=`$WGET -4 -q -O - --no-check-certificate 'https://dyndns.regfish.de/?fqdn='$FQDN'&thisipv4=1&forcehost=1&authtype=secure&token='$TOKEN`

	echo $rCode

	if [ "$rCode" = "success|100|update succeeded!" -o "$rCode" = "success|101|already up-to-date!" ];then
	    echo $aIPv4 > /tmp/regfish_myIPv4
	fi
    fi
}


function update_ipv46 {
    aIPv4=`$WGET -4 -q -O - 'http://dyndns.regfish.de/show_myip.php'`
    SIPv4=`$CAT /tmp/regfish_myIPv4`
    aIPv6=`$WGET -6 -q -O - 'http://dyndns6.regfish.de/show_myip.php'`
    SIPv6=`$CAT /tmp/regfish_myIPv6`

#
# Wenn die IP-Adresse sich geaendert hat, wird
# eine DynDNS-Aktualisierung durchgefuehrt.
#
    if [ "$aIPv4" = "$SIPv4" ] && [ "$aIPv6" = "$SIPv6" ];then
        exit 0
    else
        rCode=`$WGET -q -O - --no-check-certificate 'https://dyndns.regfish.de/?fqdn='$FQDN'&thisipv4=1&ipv6='$aIPv6'&forcehost=1&authtype=secure&token='$TOKEN`

        echo $rCode

        if [ "$rCode" = "success|100|update succeeded!" -o "$rCode" = "success|101|already up-to-date!" ];then
            echo $aIPv4 > /tmp/regfish_myIPv4
	    echo $aIPv6 > /tmp/regfish_myIPv6
        fi
    fi
}

if [ "$IPversion" = "ipv4" ];then
    update_ipv4
elif [ "$IPversion" = "ipv46" ];then
    update_ipv46
fi

exit 0