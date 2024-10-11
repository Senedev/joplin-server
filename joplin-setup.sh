#!/bin/bash

# AUTOR:            Guilherme Henrique de Sene Oliveira
# CONTATO:          <guihenriquesene@gmail.com>
# DATA CRIAÇÃO:     05 Outubro 2024
# DATA ATUALIZAÇÃO: 06 Outubro 2024

# ======================

# [Controles]
ATUALIZAR=1                             # Atualizar o sistema?                            1=SIM 0=NÃO
DOCKER=1                                # Instalar o docker e o docker compose?           1=SIM 0=NÃO
PORTAINER=1                             # Instalar o portainer?                           1=SIM 0=NÃO
JOPLIN=1                                # Instalar o joplin?                              1=SIM 0=NÃO
FIREWALL=1                              # Instalar e configurar firewall?                 1=SIM 0=NÃO
REINICIAR=0                             # Reiniciar após as operações?                    1=SIM 0=NÃO

# [VARIÁVEIS]
URL_BASE="http://192.168.1.100:22300"   # Define qual será a URL base de acesso ao joplin
DB_CLIENT="pg"                          # Define qual banco de dados será utilizado (PostgreSQL)
POSTGRES_DB="joplindb"                  # Define o nome do banco de dados
POSTGRES_PORT="5432"                    # Define a porta utilizada pelo serviço PostgreSQL
POSTGRES_PASSWORD="8NffB$4]D01m"        # Define a senha para o banco de dados
POSTGRES_USER="joplin"                  # Define o usuário para o banco de dados
APP_PORT="22300"                        # Define a porta utilizada pela aplicação Joplin Server
PORTAINER_HTTP_PORT="8000"              # Porta para o agente HTTP do Portainer
PORTAINER_HTTPS_PORT="9443"             # Porta para o agente HTTPS do Portainer
SSH="9989"                              # Porta para conexão SSH

# ======================

# Passo 1: Atualizar o sistema e seus pacotes
if [[ "$ATUALIZAR" -eq 1 ]]; then
  echo -e "\e[33mPasso 1: Atualizando o sistema e seus pacotes\e[0m"
  sudo apt update && sudo apt upgrade -y
  sudo apt full-upgrade -y
  if command -v snap >/dev/null 2>&1; then
    sudo snap refresh
  fi
  echo -e "\e[92mO sistema operacional e seus pacotes foram atualizados com sucesso!\e[0m"
  echo ""
fi

# Passo 2: Instalar o docker e o docker compose
if [[ "$DOCKER" -eq 1 ]]; then
  echo -e "\e[33mPasso 2: Instalando o docker no sistema\e[0m"
  sudo curl -fsSL https://get.docker.com/ | sudo sh &&
    sudo COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d'"' -f4) &&
    sudo curl -L "https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &&
    sudo chmod +x /usr/local/bin/docker-compose &&
    sudo usermod -aG docker $USER
  echo -e "\e[92mO Docker ($(docker --version)) e o Docker Compose ($(docker-compose --version)) em suas versões mais recentes foram instalados com sucesso!\e[0m"
  sudo systemctl enable docker
  sudo systemctl start docker
  echo ""
fi

# Passo 3: Instalar o portainer
if [[ "$PORTAINER" -eq 1 ]]; then
  echo -e "\e[33mPasso 3: Instalando o portainer\e[0m"
  sudo usermod -aG docker $USER
  sudo docker volume create portainer_data
  sudo docker run -d -p 8000:8000 -p 9443:9443 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
  echo -e "\e[92mO portainer foi instalado com sucesso!\e[0m"
  echo ""
fi

# Passo 4: Instalando o Joplin Server
if [[ "$JOPLIN" -eq 1 ]]; then
  echo -e "\e[33mPasso 4: Instalando o Joplin Server\e[0m"
  cat <<EOF >docker-compose.yml
version: '3'
services:  
  db:  
    image: postgres:16  
    volumes:  
      - ./data/postgres:/var/lib/postgresql/data  
    ports:  
      - "${POSTGRES_PORT}:${POSTGRES_PORT}"  
    restart: unless-stopped  
    environment:  
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}  
      - POSTGRES_USER=${POSTGRES_USER}  
      - POSTGRES_DB=${POSTGRES_DB}  
  app:  
    image: joplin/server:latest  
    depends_on:  
      - db  
    ports:  
      - "${APP_PORT}:${APP_PORT}"  
    restart: unless-stopped  
    environment:  
      - APP_PORT=${APP_PORT}  
      - APP_BASE_URL=${URL_BASE}  
      - DB_CLIENT=${DB_CLIENT}  
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}  
      - POSTGRES_DATABASE=${POSTGRES_DB}  
      - POSTGRES_USER=${POSTGRES_USER}  
      - POSTGRES_PORT=${POSTGRES_PORT}  
      - POSTGRES_HOST=db
EOF
  sudo docker compose up -d
  echo -e "\e[92mO serviço foi instalado e está rodando no endereço: $URL_BASE\e[0m"
  echo ""
fi

# Passo 5: Instalando, habilitando o firewall e liberando as portas necessárias
if [[ "$FIREWALL" -eq 1 ]]; then
  echo -e "\e[33mPasso 4: Instalando o Joplin Server\e[0m"
  sudo apt update && sudo apt install ufw -y
  sudo ufw enable
  sudo ufw allow ${SSH}/tcp
  sudo ufw allow ${APP_PORT}/tcp
  sudo ufw allow ${POSTGRES_PORT}/tcp
  sudo ufw allow ${PORTAINER_HTTP_PORT}/tcp
  sudo ufw allow ${PORTAINER_HTTPS_PORT}/tcp
  echo -e "\e[92mO firewall foi habilitado e as portas necessárias foram liberadas.\e[0m"
fi

# Passo 6: Reiniciar o sistema operacional
if [[ "$REINICIAR" -eq 1 ]]; then
	echo -e "\e[33mPasso 6: Reiniciar o sistema operacional\e[0m"
	if grep -qi "Ubuntu" /etc/os-release; then
		sudo shutdown -r now
	elif grep -qi "Debian" /etc/os-release; then
		sudo systemctl poweroff
	fi
fi