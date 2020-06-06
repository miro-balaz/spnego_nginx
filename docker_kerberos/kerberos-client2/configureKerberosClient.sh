#!/bin/bash
echo "==================================================================================="
echo "==== Kerberos Client =============================================================="
echo "==================================================================================="
KADMIN_PRINCIPAL_FULL=$KADMIN_PRINCIPAL@$REALM

echo "REALM: $REALM"
echo "KADMIN_PRINCIPAL_FULL: $KADMIN_PRINCIPAL_FULL"
echo "KADMIN_PASSWORD: $KADMIN_PASSWORD"
echo ""

function kadminCommand {
    kadmin -p $KADMIN_PRINCIPAL_FULL -w $KADMIN_PASSWORD -q "$1"
}
function kadminCommandLocal {
    kadmin.local -p $KADMIN_PRINCIPAL_FULL -w $KADMIN_PASSWORD -q "$1"
}
echo "==================================================================================="
echo "==== /etc/krb5.conf ==============================================================="
echo "==================================================================================="
tee /etc/krb5.conf <<EOF
[libdefaults]
	default_realm = $REALM

[realms]
	$REALM = {
		kdc = kdc-kadmin
		admin_server = kdc-kadmin
	}
EOF
echo ""

kinit -5 -V -k -t /shared/user.keytab $USER_PRINCIPAL@$REALM
klist
curl -i --negotiate -u : http://ngserv/index.html
echo "finished"