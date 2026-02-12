.PHONY: help docker--up podman--up docker--down podman--down gns3--importar-imagenes lab--start

# Variable para detectar si existe firefox, si no usar xdg-open o similar
BROWSER := firefox

help: ## Muestra este menu de ayuda
	@echo "Uso: make [comando]"
	@echo ""
	@echo "Comandos disponibles:"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2}'

gns3--importar-imagenes: ## Descarga y prepara imagenes de OpenWRT
	./setup.sh

docker--up: gns3--importar-imagenes ## Levanta los contenedores con Docker
	docker compose -f docker-compose.yml up -d

podman--up: gns3--importar-imagenes ## Levanta los contenedores con Podman
	podman-compose -f podman-compose.yml up -d

lab--start: ## Abre GNS3 y Wireshark en Firefox
	@echo "Esperando a que los servicios suban..."
	@sleep 3
	$(BROWSER) http://localhost:3080/ http://localhost:3001/ > /dev/null 2>&1 &

docker--down: ## Detiene y borra volumenes con Docker
	docker compose -f docker-compose.yml down -v

podman--down: ## Detiene y borra volumenes con Podman
	podman-compose -f podman-compose.yml down -v
