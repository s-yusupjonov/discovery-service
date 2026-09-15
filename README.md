# discovery-service

Spring Cloud Netflix Eureka Server for the training-management microservices
system. This service has no business logic of its own; it is the registry
that `trainer-workload-service` and `gym-crm` register with and discover each
other through.

## Stack

- Java 17
- Spring Boot 3.3.4
- Spring Cloud 2023.0.3
- Maven, packaged as a runnable jar

## Running locally

```bash
mvn clean package
java -jar target/discovery-service-0.0.1-SNAPSHOT.jar
```

The server starts on port `8761`. Open the dashboard at:

```
http://localhost:8761
```

Check health:

```bash
curl http://localhost:8761/actuator/health
```

## Running with Docker

Build the image:

```bash
docker build -t discovery-service .
```

Run it:

```bash
docker run -p 8761:8761 discovery-service
```

## Configuration

`eureka.client.register-with-eureka` and `eureka.client.fetch-registry` are
both set to `false`, since this instance is the registry itself and should
not try to register with or pull a registry from another server.

`eureka.server.enable-self-preservation` is disabled, which is appropriate
for a single-instance local/dev or academic setup where renewal thresholds
would otherwise trigger false alarms.

## Pointing other services at this registry

Any service that should register with or discover services through this
server (`gym-crm`, `trainer-workload-service`) needs Eureka client
dependencies plus the following property:

```properties
eureka.client.service-url.defaultZone=http://localhost:8761/eureka/
```

When running these services in Docker on the same network, replace
`localhost` with the discovery-service container's hostname, e.g.:

```properties
eureka.client.service-url.defaultZone=http://discovery-service:8761/eureka/
```
# discovery-service
