So the name of project has to be docker_kerberos, because it is used in SPNs. Therfore everything is in that directory
This docker compose setup is just for testing Nginx with SPNEGO module.

I used this [repository](https://github.com/ist-dsi/docker-kerberos) as basis for this project.

**Sample nginx configuration**
```
user root;
error_log /var/log/nginx/dbg debug;
events {}
http {
    server {
      # for production enable ssl, authentication without ssl is not safe at all.
      #listen 443 ssl;
      #ssl_certificate /shared/example.crt;
      #ssl_certificate_key /shared/example.key;
      server_name docker-kerberos_ngserv_1.docker-kerberos_default;
         location / {  # This location requires authentication too
      	    
            auth_gss on;
            auth_gss_allow_basic_fallback off;
            auth_gss_realm EXAMPLE.COM;
            auth_gss_keytab /shared/krb5.keytab;
            auth_gss_service_name HTTP/docker-kerberos_ngserv_1.docker-kerberos_default;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Authorized-User $remote_user;
            # proxy_pass  <upstream>
            root /data/www;
            index index.html;
            
         }
    }
}
```
