#!/usr/bin/env bash
set -euo pipefail

CERTS_DIR="$(cd "$(dirname "$0")/.." && pwd)/certs"
mkdir -p "$CERTS_DIR"

# CA
openssl genrsa -out "$CERTS_DIR/ca-key.pem" 2048
openssl req -new -x509 -days 3650 -key "$CERTS_DIR/ca-key.pem" \
  -out "$CERTS_DIR/server-ca.pem" -subj "/CN=dev-ca"

# Server cert (CN=db matches the docker-compose service name)
openssl genrsa -out "$CERTS_DIR/server-key.pem" 2048
openssl req -new -key "$CERTS_DIR/server-key.pem" -out "$CERTS_DIR/server.csr" -subj "/CN=db"
openssl x509 -req -days 3650 -in "$CERTS_DIR/server.csr" \
  -CA "$CERTS_DIR/server-ca.pem" -CAkey "$CERTS_DIR/ca-key.pem" -CAcreateserial \
  -out "$CERTS_DIR/server-cert.pem"
rm "$CERTS_DIR/server.csr"

# Client cert
openssl genrsa -out "$CERTS_DIR/client-key.pem" 2048
openssl req -new -key "$CERTS_DIR/client-key.pem" -out "$CERTS_DIR/client.csr" -subj "/CN=postgres"
openssl x509 -req -days 3650 -in "$CERTS_DIR/client.csr" \
  -CA "$CERTS_DIR/server-ca.pem" -CAkey "$CERTS_DIR/ca-key.pem" -CAcreateserial \
  -out "$CERTS_DIR/client-cert.pem"
rm "$CERTS_DIR/client.csr"

chmod 600 "$CERTS_DIR/server-key.pem" "$CERTS_DIR/client-key.pem"
echo "Dev certs written to $CERTS_DIR"
