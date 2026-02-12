## 1. IDENTIDAD
uci set system.@system[0].hostname='L0R0'
uci commit system
/etc/init.d/system reload

## 2. RED (Interfaces)
# Limpiamos interfaces antiguas para evitar conflictos
for i in lan wan lan0 lan1 lan2 lan3 lan4; do uci delete network.$i 2>/dev/null; done

# WAN - Salida a Internet
uci set network.wan=interface
uci set network.wan.device='eth0'
uci set network.wan.proto='static'
uci set network.wan.ipaddr='172.50.0.10'
uci set network.wan.netmask='255.255.255.0'
uci set network.wan.gateway='172.50.0.1'
uci set network.wan.dns='8.8.8.8 1.1.1.1'

# LANs - Redes Internas
uci set network.lan1=interface
uci set network.lan1.device='eth1'
uci set network.lan1.proto='static'
uci set network.lan1.ipaddr='10.0.1.1'
uci set network.lan1.netmask='255.255.255.0'

uci set network.lan2=interface
uci set network.lan2.device='eth2'
uci set network.lan2.proto='static'
uci set network.lan2.ipaddr='10.0.2.1'
uci set network.lan2.netmask='255.255.255.0'

uci set network.lan3=interface
uci set network.lan3.device='eth3'
uci set network.lan3.proto='static'
uci set network.lan3.ipaddr='10.0.3.1'
uci set network.lan3.netmask='255.255.255.0'

uci commit network
/etc/init.d/network restart

## 3. FIREWALL (Limpieza y Zonas)
# Reseteamos las zonas para usar los índices estándar [0]=LAN, [1]=WAN
uci set firewall.@zone[0].name='lan'
uci set firewall.@zone[0].network='lan1 lan2 lan3'
uci set firewall.@zone[0].input='ACCEPT'
uci set firewall.@zone[0].forward='ACCEPT'
uci set firewall.@zone[0].output='ACCEPT'

uci set firewall.@zone[1].name='wan'
uci set firewall.@zone[1].network='wan'
uci set firewall.@zone[1].masq='1'
uci set firewall.@zone[1].mtu_fix='1'
uci set firewall.@zone[1].input='REJECT'
uci set firewall.@zone[1].forward='REJECT'
uci set firewall.@zone[1].output='ACCEPT'

# Regla de Forwarding: Permitir que LAN salga a WAN
# Borramos posibles duplicados y creamos la ruta limpia
uci delete firewall.@forwarding[0] 2>/dev/null
uci add firewall forwarding
uci set firewall.@forwarding[-1].src='lan'
uci set firewall.@forwarding[-1].dest='wan'

uci commit firewall
/etc/init.d/firewall restart