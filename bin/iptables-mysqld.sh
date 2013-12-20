#!/bin/sh
 
# iptablesの設定初期化
/sbin/iptables -F
/sbin/iptables -X
 
# デフォルトルールを設定(IN:NG/OUT:OK/FW:NG)
/sbin/iptables -P INPUT DROP
/sbin/iptables -P OUTPUT ACCEPT
/sbin/iptables -P FORWARD DROP

# ローカルホストは受け付ける 
/sbin/iptables -A INPUT -i lo -j ACCEPT
/sbin/iptables -A OUTPUT -o lo -j ACCEPT

# ステートフルインスペクションを有効化 
/sbin/iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# 同一ネットワークからの接続を弾く(外部設置サーバ用)
#/sbin/iptables -A INPUT -s 10.0.0.0/8 -j DROP
#/sbin/iptables -A INPUT -s 172.16.0.0/12 -j DROP
#/sbin/iptables -A INPUT -s 192.168.0.0/16 -j DROP
 
# フラグメントをドロップ
/sbin/iptables -A INPUT -f -j LOG --log-level debug --log-prefix 'FRAGMENT DROP:'
/sbin/iptables -A INPUT -f -j DROP

# PINGを許可(1分に10回のみ解答)
/sbin/iptables -A INPUT -p icmp --icmp-type echo-request -m hashlimit --hashlimit-name t_icmp --hashlimit 1/m --hashlimit-burst 10 --hashlimit-mode srcip --hashlimit-htable-expire 120000 -j ACCEPT

# IDENTをドロップ
/sbin/iptables -A INPUT -p tcp --dport 113 -j REJECT --reject-with tcp-reset

# マルチキャストをドロップ
/sbin/iptables -A INPUT -d 255.255.255.255 -j DROP
/sbin/iptables -A INPUT -d 224.0.0.1 -j DROP

# zabbix-agentを許可
/sbin/iptables -A INPUT -p tcp --dport 10050 -j ACCEPT

# FTPを許可（5分に5回のアクセス失敗時はブロック）
#/sbin/iptables -A INPUT -p tcp --dport 20 -j ACCEPT
#/sbin/iptables -A INPUT -p tcp --syn --dport 20 -m recent --name ftpattack --set
#/sbin/iptables -A INPUT -p tcp --syn --dport 20 -m recent --name ftpattack --rcheck --seconds 300 --hitcount 5 -j LOG --log-prefix 'FTP attack'
#/sbin/iptables -A INPUT -p tcp --syn --dport 20 -m recent --name ftpattack --rcheck --seconds 300 --hitcount 5 -j DROP

#/sbin/iptables -A INPUT -p tcp --dport 21 -j ACCEPT
#/sbin/iptables -A INPUT -p tcp --syn --dport 21 -m recent --name ftpattack --set
#/sbin/iptables -A INPUT -p tcp --syn --dport 21 -m recent --name ftpattack --rcheck --seconds 300 --hitcount 5 -j LOG --log-prefix 'FTP attack'
#/sbin/iptables -A INPUT -p tcp --syn --dport 21 -m recent --name ftpattack --rcheck --seconds 300 --hitcount 5 -j DROP

# SSHを許可（5分に5回のアクセス失敗時はブロック）
/sbin/iptables -A INPUT -p tcp --dport 22 -j ACCEPT
/sbin/iptables -A INPUT -p tcp --syn --dport 22 -m recent --name sshattack --set
/sbin/iptables -A INPUT -p tcp --syn --dport 22 -m recent --name sshattack --rcheck --seconds 300 --hitcount 5 -j LOG --log-prefix 'SSH attack'
/sbin/iptables -A INPUT -p tcp --syn --dport 22 -m recent --name sshattack --rcheck --seconds 300 --hitcount 5 -j DROP

# HTTP/HTTPS設定
#/sbin/iptables -A INPUT -p tcp --dport 80 -j ACCEPT
#/sbin/iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# メール設定
#/sbin/iptables -A INPUT -p tcp --dport 25 -j ACCEPT
#/sbin/iptables -A INPUT -p tcp --dport 110 -j ACCEPT
#/sbin/iptables -A INPUT -p tcp --dport 143 -j ACCEPT

# MySQL設定
/sbin/iptables -A INPUT -p tcp --dport 3306 -j ACCEPT

# VRRPパケット
/sbin/iptables -A INPUT -p vrrp -j ACCEPT
/sbin/iptables -A OUTPUT -p vrrp -J ACCEPT

# iptables再起動
/etc/rc.d/init.d/iptables save
/sbin/service iptables restart
