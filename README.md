
# Joplin Server Setup e Configuração do Sistema

## Visão Geral

Este script automatiza a configuração e instalação de um servidor Joplin, juntamente com outras configurações de sistema em servidores Ubuntu e Debian. Ele ajuda a instalar Docker, Docker Compose, Portainer, e configurar um firewall, além de outros serviços essenciais. O script foi projetado para simplificar o processo de configuração do servidor, garantindo segurança e eficiência operacional.

## Funcionalidades Principais

- **Atualização do Sistema**: Atualiza automaticamente os pacotes do sistema.
- **Instalação do Docker e Docker Compose**: Instala Docker e Docker Compose para gerenciamento de containers.
- **Instalação do Portainer**: Instala o Portainer para gerenciar containers Docker via interface web.
- **Configuração do Servidor Joplin**: Configura o servidor Joplin utilizando Docker Compose, incluindo a configuração do banco de dados PostgreSQL.
- **Configuração de Firewall**: Habilita o UFW e configura para permitir as portas necessárias para o Joplin, PostgreSQL, SSH, e Portainer.
- **Reinicialização Opcional**: Reinicia automaticamente o sistema após todas as configurações serem concluídas (com base na escolha do usuário).

## Opções de Configuração

O script permite personalização através das seguintes variáveis:

- **URL_BASE**: URL base para acessar o servidor Joplin (padrão: `http://192.168.1.100:22300`).
- **DB_CLIENT**: Cliente de banco de dados a ser utilizado (padrão: PostgreSQL `pg`).
- **POSTGRES_DB**: Nome do banco de dados PostgreSQL (padrão: `joplindb`).
- **POSTGRES_PORT**: Porta do serviço PostgreSQL (padrão: `5432`).
- **POSTGRES_PASSWORD**: Senha para o banco de dados PostgreSQL.
- **POSTGRES_USER**: Usuário do banco de dados PostgreSQL (padrão: `joplin`).
- **APP_PORT**: Porta da aplicação Joplin Server (padrão: `22300`).
- **PORTAINER_HTTP_PORT**: Porta HTTP para o Portainer (padrão: `8000`).
- **PORTAINER_HTTPS_PORT**: Porta HTTPS para o Portainer (padrão: `9443`).
- **SSH**: Porta SSH (padrão: `9989`).

Além disso, você pode habilitar/desabilitar as seguintes funcionalidades ajustando as variáveis correspondentes para `1` (habilitado) ou `0` (desabilitado):
- **ATUALIZAR**: Atualização do sistema.
- **DOCKER**: Instalação do Docker e Docker Compose.
- **PORTAINER**: Instalação do Portainer.
- **JOPLIN**: Configuração do servidor Joplin.
- **FIREWALL**: Configuração do firewall UFW.
- **REINICIAR**: Reiniciar o sistema após as configurações.

## Como Executar

### Pré-requisitos

- Ubuntu 18.04+ ou Debian 10+.
- Privilégios de sudo ou acesso root.

### Instruções

1. **Clonar ou Baixar o Script**:

   Clone o repositório ou faça o download do script diretamente:

   ```bash
   git clone https://bitbucket.org/guilhermesene/joplin-server-setup.git
   ```

2. **Tornar o Script Executável**:

   Navegue até o diretório onde o script está localizado e conceda permissão de execução:

   ```bash
   chmod +x joplin-setup.sh
   ```

3. **Editar as Opções de Configuração**:

   Abra o script em um editor de texto e modifique as variáveis de configuração no início do arquivo de acordo com suas necessidades.

4. **Executar o Script**:

   Para executar o script com privilégios de sudo, use o seguinte comando:

   ```bash
   sudo ./joplin-setup.sh
   ```

5. **Acompanhar o Progresso**:

   O script exibirá as saídas de cada etapa conforme progride, incluindo atualização do sistema, instalação do Docker, configuração do Joplin, e do firewall.

## Observações

- Certifique-se de que seu sistema tenha acesso à internet durante a execução do script, pois ele fará o download de pacotes e imagens Docker necessários.
- O firewall (UFW) será configurado para permitir tráfego nas portas SSH, Joplin, PostgreSQL e Portainer. Certifique-se de atualizar as variáveis de porta se estiver usando portas personalizadas.
- Se habilitado, o sistema será reiniciado automaticamente ao final do processo de configuração.