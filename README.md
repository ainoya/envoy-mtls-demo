# mTLS Authentication Demo Repository Using Envoy

This repository contains a sample configuration for trying out mTLS authentication (TLS server certificate and client certificate authentication) using Envoy. It communicates with the application server via gRPC. To test the behavior of load balancing, multiple replicas of backend servers and Envoy are configured.

## Setup Instructions

1. Ensure that `cfssl` and `cfssljson` are installed.
2. Run `./setup-certs.sh` to generate server and client certificates.
3. Use `docker-compose up --build` to launch the Envoy and gRPC server.

## Testing Communication

Please install Evans beforehand from <https://github.com/ktr0731/evans>.

### Successful Authentication Case

An Envoy configured with a valid client certificate is listening on port 2443. Accessing this will allow correct communication with the gRPC server.

```bash
$ echo '{"name": "aaa"}' | evans --host localhost --port 2443 -r cli call SayHello
{
  "message": "Hello, aaa!"
}
```

### Client Authentication Failure Case

An Envoy configured with a client certificate, which doesn't have the accepted SAN set by the server, is listening on port 2444. Accessing this will result in a communication error.

```bash
$ echo '{"name": "aaa"}' | evans --host localhost --port 2444 -r cli call SayHello
evans: failed to run CLI mode: 1 error occurred:

* failed to instantiate the spec: failed to list packages by gRPC reflection: failed to list services from reflection enabled gRPC server: rpc error: code = Unavailable desc = connection error: desc = "error reading server preface: EOF"
```

```bash
mtls-docker-compose-demo-proxy-app-backend-1  | [2024-01-14 04:13:53.836][30][debug][connection] [source/extensions/transport_sockets/tls/cert_validator/default_validator.cc:248] verify cert failed: SAN matcher
mtls-docker-compose-demo-proxy-app-backend-1  | [2024-01-14 04:13:53.837][30][debug][connection] [source/extensions/transport_sockets/tls/ssl_socket.cc:241] [Tags: "ConnectionId":"2"] remote address:172.20.0.4:58824,TLS_error:|268435581:SSL routines:OPENSSL_internal:CERTIFICATE_VERIFY_FAILED:TLS_error_end
```

### References

- [double proxy](https://github.com/envoyproxy/envoy/tree/main/examples/double-proxy)

