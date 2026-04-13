#!/bin/bash

DATA=$(date +%Y-%m-%d)

ORIGEM="/home"
DESTINO="/mnt/raid/backups"

mkdir -p $DESTINO

tar -czvf $DESTINO/backup-$DATA.tar.gz $ORIGEM

echo "Backup realizado em $DATA"