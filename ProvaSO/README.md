# Infraestrutura de Dados e Serviços Escaláveis com Linux

## Descrição do Projeto

Este projeto demonstra a implementação de uma infraestrutura de servidor baseada em tecnologias amplamente utilizadas em ambientes corporativos. O objetivo é integrar conceitos de armazenamento redundante, administração remota e conteinerização de serviços utilizando o sistema operacional **Linux**.

A solução utiliza RAID por software para garantir redundância de dados, administração remota via **Webmin**, e conteinerização de aplicações utilizando **Docker** com um servidor web **Nginx**.

Essa arquitetura simula um ambiente corporativo onde serviços precisam ser altamente disponíveis, seguros e fáceis de administrar.

---

# Arquitetura do Sistema

A infraestrutura é composta pelas seguintes camadas:

1. **Sistema Operacional**

   * Servidor Linux responsável pelo gerenciamento de hardware e processos.

2. **Camada de Armazenamento**

   * RAID 1 configurado com dois discos virtuais utilizando `mdadm`.

3. **Camada de Administração**

   * Gerenciamento do servidor via interface web com Webmin.

4. **Camada de Aplicação**

   * Container Docker executando um servidor web Nginx.

Fluxo simplificado da arquitetura:

```
Usuário → Navegador
        ↓
Servidor Linux
        ↓
Docker Container (Nginx)
        ↓
Arquivos armazenados no RAID
```

---

# Tecnologias Utilizadas

* **Sistema Operacional:** Linux
* **Virtualização:** Oracle VM VirtualBox
* **Gerenciamento RAID:** mdadm
* **Administração do Servidor:** Webmin
* **Containerização:** Docker
* **Servidor Web:** Nginx

---

# Estrutura do Projeto

```
/mnt/raid
│
├── site
│   └── index.html
│
├── backups
│
└── scripts
    └── backup.sh
```

---

# Configuração do RAID

O sistema utiliza **RAID 1 (espelhamento)**.

No RAID 1, os dados são gravados simultaneamente em dois discos, garantindo redundância em caso de falha de hardware.

Exemplo conceitual:

```
Disco 1 → Dados
Disco 2 → Cópia exata dos dados
```

Caso um disco falhe, o sistema continua operando utilizando o disco restante.

---

# Script de Backup

Foi desenvolvido um script em Shell para automatizar o processo de backup.

Funções do script:

* Compactar arquivos
* Armazenar backups no RAID
* Organizar arquivos por data

Exemplo de script:

```bash
#!/bin/bash

DATA=$(date +%Y-%m-%d)

ORIGEM="/home"
DESTINO="/mnt/raid/backups"

mkdir -p $DESTINO

tar -czvf $DESTINO/backup-$DATA.tar.gz $ORIGEM

echo "Backup realizado em $DATA"
```

---

# Implementação do Projeto

## 1. Preparação da Máquina Virtual

No VirtualBox foram adicionados dois discos virtuais extras para criação do RAID.

Discos identificados no sistema:

```
/dev/sdb
/dev/sdc
```

---

## 2. Instalação do mdadm

```bash
sudo apt update
sudo apt install mdadm
```

---

## 3. Criação do RAID

```bash
sudo mdadm --create --verbose /dev/md127 --level=1 --raid-devices=2 /dev/sdb /dev/sdc
```

Verificação do RAID:

```bash
cat /proc/mdstat
```

---

## 4. Formatação do RAID

```bash
sudo mkfs.ext4 /dev/md127
```

---

## 5. Montagem do RAID

Criar diretório:

```bash
sudo mkdir /mnt/raid
```

Montar RAID:

```bash
sudo mount /dev/md127 /mnt/raid
```

Verificar montagem:

```bash
df -h
```

---

## 6. Montagem Automática

Editar arquivo `fstab`:

```bash
sudo nano /etc/fstab
```

Adicionar:

```
/dev/md127 /mnt/raid ext4 defaults 0 0
```

---

## 7. Instalação do Webmin

Download:

```bash
wget https://prdownloads.sourceforge.net/webadmin/webmin_2.105_all.deb
```

Instalação:

```bash
sudo dpkg -i webmin_2.105_all.deb
sudo apt -f install
```

Acesso:

```
https://IP_DO_SERVIDOR:10000
```

---

## 8. Instalação do Docker

```bash
sudo apt install docker.io
```

Iniciar serviço:

```bash
sudo systemctl start docker
```

---

## 9. Criação do Servidor Web

Criar diretório do site:

```bash
mkdir /mnt/raid/site
```

Criar página HTML:

```bash
nano /mnt/raid/site/index.html
```

Exemplo de conteúdo:

```html
<h1>Servidor Corporativo Ativo</h1>
<p>Infraestrutura Linux com RAID e Docker</p>
```

---

## 10. Execução do Container

```bash
docker run -d -p 80:80 -v /mnt/raid/site:/usr/share/nginx/html --name servidor-web nginx
```

Verificar container:

```bash
docker ps
```

---

# Teste do Servidor

Para visualizar o servidor funcionando:

1. Descobrir o IP do servidor:

```bash
ip a
```

2. Acessar no navegador:

```
http://IP_DO_SERVIDOR
```

A página criada no `index.html` será exibida.

---

# Verificação do RAID

Para verificar o funcionamento do RAID:

```bash
cat /proc/mdstat
```

Verificar discos:

```bash
lsblk
```

Verificar montagem:

```bash
df -h
```

---

# Conclusão

Este projeto demonstrou a implementação de uma infraestrutura de servidor moderna utilizando tecnologias open source amplamente adotadas em ambientes corporativos.

A integração entre RAID para redundância de dados, Webmin para administração remota e Docker para conteinerização de aplicações resultou em um sistema robusto, escalável e de fácil gerenciamento.

Essa arquitetura permite maior confiabilidade dos dados e facilita a manutenção e expansão dos serviços hospedados no servidor.