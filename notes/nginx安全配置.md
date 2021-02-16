```
http { port_in_redirect off; }
http { server_tokens off; }
http { add_header X-Frame-Options SAMEORIGIN; }
http { add_header X-XSS-Protection "1; mode=block"; }
http { add_header X-Content-Type-Options nosniff; }
http { autoindex off; }


server {
	client_body_timeout ...
	client_header_timeout 60s
	keepalive_timeout ...
	send_timeout 60;
}
```