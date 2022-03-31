#!/bin/sh


iptables -A INPUT   -p tcp --syn -m limit --limit 1/s --limit-burst 5 -j ACCEPT
iptables -A FORWARD -p tcp --syn -m limit --limit 1/s --limit-burst 5 -j ACCEPT
iptables -A FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s -j ACCEPT
iptables -I INPUT -p tcp  -m connlimit --connlimit-above 500 -j REJECT 


cd /root/minerProxy
sleep 5s

while true; do
    ./minerProxy 
    sleep 10s
done



