iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X

iptables -P INPUT ACCEPT    #There will be a line at the bottom of the chain to reject default package
iptables -P FORWARD DROP #By default, do not act as a router
iptables -P OUTPUT ACCEPT #By default, assume the server is secured, thus allow all outgoing traffic. could be hardened in future

iptables -I FORWARD -d 10.8.0.0/24 -j ACCEPT
#iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -j SNAT --to vps_ip
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p icmp  -i venet0 -m icmp --icmp-type 8 -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -i tap+ -j ACCEPT
iptables -A INPUT -i tun+ -j ACCEPT
iptables -A FORWARD -i tap+ -j ACCEPT
iptables -A FORWARD -i tun+ -j ACCEPT
iptables -A INPUT -p tcp -i venet0 --dport ssh_port -j ACCEPT
iptables -A INPUT -p tcp -i venet0 --dport mysql_port -j ACCEPT
iptables -A INPUT -p tcp -i venet0 --dport openvpn_port -j ACCEPT
iptables -A INPUT -p tcp -i venet0 --dport 443 -j ACCEPT
iptables -A INPUT -p tcp -i venet0 --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -i venet0 --dport 21 -j ACCEPT
iptables -A INPUT -j DROP

iptables-save > /etc/iptables.rules
