#!/bin/bash


echo "Content-Type:text/html"
echo ""
echo "<html><head>"
echo "<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />"
echo "<meta http-equiv='refresh' content='50' />"
echo "<style type='text/css'>         
	a { text-decoration: none;color: green;}
        a:hover { color: red; text-decoration:none;border-bottom:0px solid red;display: inline-block; padding-bottom:0px;}
　　    a:link { text-decoration: none;color: red}
　　    a:active { text-decoration:blink; color: red}</style>"
　　    #a:visited { text-decoration: none;color: green}</style>"

echo "</head>"
python /var/www/html/cgi-bin/status.py

echo "</body></html>"
