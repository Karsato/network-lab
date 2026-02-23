# Variables
compose_file := "docker-compose-firewall.yml"
firewall := "network-lab-firewall-1"
cliente := "network-lab-cliente-1"
servidor := "network-lab-servidor-1"

# Levantar el laboratorio completo
fw--up:
    docker compose -f {{compose_file}} up -d

# Destruir el laboratorio y limpiar redes
fw--down:
    docker compose -f {{compose_file}} down --remove-orphans

# Ver el estado de las reglas en el firewall
fw--status:
    @echo "--- [IPTABLES FORWARD] ---"
    docker exec {{firewall}} iptables -L FORWARD -n --line-numbers
    @echo "\n--- [NFTABLES RULESET] ---"
    docker exec {{firewall}} nft list ruleset

# Bloqueo total (Limpia reglas de Docker y pone política DROP)
fw--reset-strict:
    docker exec {{firewall}} iptables -F
    docker exec {{firewall}} iptables -X
    docker exec {{firewall}} iptables -t nat -F
    docker exec {{firewall}} iptables -P FORWARD DROP
    @echo "Escenario reseteado: Todo el tráfico de tránsito está BLOQUEADO."

# Bloqueo rápido (Inserta un DROP al principio sin borrar nada)
fw--block:
    docker exec {{firewall}} iptables -I FORWARD 1 -j DROP
    @echo "Regla DROP insertada en la posición 1."

# Abrir todo el tráfico
fw--allow-all:
    docker exec {{firewall}} iptables -P FORWARD ACCEPT
    docker exec {{firewall}} iptables -F
    @echo "Firewall abierto: Tráfico permitido."

# Test de conectividad (Ping desde el cliente al servidor)
fw--test-ping:
    @echo "Probando ping Cliente (10.0.1.10) -> Servidor (192.168.1.10)..."
    docker exec {{cliente}} ping -c 3 192.168.1.10
