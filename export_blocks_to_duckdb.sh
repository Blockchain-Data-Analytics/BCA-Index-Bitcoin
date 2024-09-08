#!/bin/sh

set -e

if [ -z "${STARTBLOCKHEIGHT}" ]; then echo "missing \$STARTBLOCKHEIGHT"; exit 1; fi
if [ -z "${NUMBLOCKS}" ]; then echo "missing \$NUMBLOCKS"; exit 1; fi

ls -l /workspace/ca-cert/ca.crt
ls -l /workspace/minio-credentials/
MINIO_USER=$(cat /workspace/minio-credentials/minio-user | base64 -d)
MINIO_PASSWORD=$(cat /workspace/minio-credentials/minio-password | base64 -d)
MINIO_HOST=$(cat /workspace/minio-credentials/minio-host | base64 -d)
MINIO_PORT=$(cat /workspace/minio-credentials/minio-port | base64 -d)
MINIO_BUCKET=$(cat /workspace/minio-credentials/minio-bucket | base64 -d)
MINIO_URL="https://${MINIO_HOST}:${MINIO_PORT}/${MINIO_BUCKET}"

DBSTEM="btc_${STARTBLOCKHEIGHT}_${NUMBLOCKS}"

time { ./lsblocks.sh ${STARTBLOCKHEIGHT} ${NUMBLOCKS} | ./json2duckdb.sh ${DBSTEM}; }

if [ -e ${DBSTEM}-tx.parquet -a -e ${DBSTEM}-block.parquet ]; then
   curl -X PUT --cacert /workspace/ca-cert/ca.crt -T ${DBSTEM}-tx.parquet --aws-sigv4 "aws:amz:us-east-1:s3" --user "${MINIO_USER}:${MINIO_PASSWORD}" "${MINIO_URL}/${DBSTEM}-tx.parquet"
   curl -X PUT --cacert /workspace/ca-cert/ca.crt -T ${DBSTEM}-block.parquet --aws-sigv4 "aws:amz:us-east-1:s3" --user "${MINIO_USER}:${MINIO_PASSWORD}" "${MINIO_URL}/${DBSTEM}-block.parquet"
   rm -v ${DBSTEM}-tx.parquet ${DBSTEM}-block.parquet
fi
