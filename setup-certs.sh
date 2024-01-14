#!/usr/bin/env bash
set -xe
# This script is used to setup the certificates for the server and client

# Create the CA key and certificate with cfssl, cfssljson
cd certs/ca
cfssl genkey -initca ca-csr.json | cfssljson -bare ca

# Create the server key and certificate with cfssl, cfssljson
cd -
cd certs/server
cfssl gencert -ca=../ca/ca.pem -ca-key=../ca/ca-key.pem \
  -config=./server-config.json server.json | cfssljson -bare server

# Create the client key and certificate with cfssl, cfssljson
cd -
cd certs/client
cfssl gencert -ca=../ca/ca.pem -ca-key=../ca/ca-key.pem \
  -config=./client-config.json client.json | cfssljson -bare client


cd -
cd certs/client-invalid-san
cfssl gencert -ca=../ca/ca.pem -ca-key=../ca/ca-key.pem \
  -config=./client-config.json client.json | cfssljson -bare client

