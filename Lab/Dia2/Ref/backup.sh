#!/bin/bash
export AWS_ACCESS_KEY_ID=AKIAJQTI36MB3A4ZXAUQ
export AWS_SECRET_ACCESS_KEY=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

FCH=$(date +%H-%M)
echo "Backup Mysql"
mysqldump -u root -h dbaws -pdbaws sugar > /tmp/bk_sugar-$(hostname)-$FCH.sql

echo "Subiendo backup"
aws s3 cp /tmp/bk_sugar-$(hostname)-$FCH.sql s3://dbawsu
