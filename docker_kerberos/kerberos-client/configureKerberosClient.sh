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

echo "==================================================================================="
echo "==== Testing ======================================================================"
echo "==================================================================================="

until kadminCommand "add_principal +allow_forwardable +allow_proxiable +allow_svr +allow_tgs_req +ok_to_auth_as_delegate -pw $USER_PASSWORD $USER_PRINCIPAL@$REALM"; do
 >&2 eche "KDC is unavailable"
 sleep 1
done
echo "user created:"
echo ""
until kadminCommand "add_principal -requires_preauth -pw hostpw1 host/docker-kerberos_ngserv_1.docker-kerberos_default@$REALM"; do
 >&2 eche "KDC is unavailable"
 sleep 1
done
echo "user created:"
echo ""
until kadminCommand "add_principal -requires_preauth -pw hostpw2 HTTP/docker-kerberos_ngserv_1.docker-kerberos_default@$REALM"; do
 >&2 eche "KDC is unavailable"
 sleep 1
done
echo "user created:"

until kadminCommand "list_principals $KADMIN_PRINCIPAL_FULL"; do
  >&2 echo "KDC is unavailable - sleeping 1 sec"
  sleep 1
done
# Generate keytabs for service and user
printf "add_entry -password -p host/docker-kerberos_ngserv_1.docker-kerberos_default@EXAMPLE.COM -k 1 -e aes256-cts-hmac-sha1-96\nhostpw1\nadd_entry -password -p HTTP/docker-kerberos_ngserv_1.docker-kerberos_default@EXAMPLE.COM -k 1 -e aes256-cts-hmac-sha1-96\nhostpw2\nwkt /shared/krb5.keytab\nquit" | ktutil
printf "add_entry -password -p $USER_PRINCIPAL@EXAMPLE.COM -k 1 -e aes256-cts-hmac-sha1-96\n$USER_PASSWORD\nwkt /shared/user.keytab\nquit" | ktutil
echo "KDC and Kadmin are operational"
echo ""