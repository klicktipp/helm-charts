# rabbitmq-topology

Helm chart to manage RabbitMQ topology resources via RabbitMQ Topology Operator CRDs.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | `""` | Override for the Helm chart name. |
| fullnameOverride | string | `""` | Override for the fully-qualified release name. |
| rabbitmq.cluster.name | string | `""` | Target `RabbitmqCluster` resource name for all topology objects. If empty, chart fullname is used. |
| rabbitmq.topology.queues | object | `{}` | Map of queue definitions. |
| rabbitmq.topology.exchanges | object | `{}` | Map of exchange definitions. |
| rabbitmq.topology.bindings | object | `{}` | Map of binding definitions. |
| rabbitmq.topology.policies | object | `{}` | Map of policy definitions. |
| rabbitmq.topology.users | object | `{}` | Map of user definitions. |
| rabbitmq.vhosts | object | `{}` | Map of vhost definitions. |

## Examples

### 1. Minimal standalone topology

```yaml
rabbitmq:
  cluster:
    name: app-rabbitmq
  vhosts:
    app:
      enabled: true
      default: true
      name: app
  topology:
    exchanges:
      app-events:
        type: direct
        vhost: app
    queues:
      email-request:
        name: email_request
        type: quorum
        vhost: app
        exchange:
          enabled: false
        binding:
          enabled: false
    bindings:
      email-request:
        source: app-events
        destination: email_request
        destinationType: queue
        routingKey: email_request
        vhost: app
```

### 2. Add fallback queue and policy (alternate exchange)

```yaml
rabbitmq:
  cluster:
    name: app-rabbitmq
  topology:
    exchanges:
      app-events:
        type: direct
        vhost: app
      app-events-fallback:
        type: fanout
        vhost: app
    queues:
      app-events-fallback:
        name: app_events_fallback
        type: quorum
        vhost: app
        exchange:
          enabled: false
        binding:
          enabled: false
    bindings:
      app-events-fallback:
        source: app-events-fallback
        destination: app_events_fallback
        destinationType: queue
        vhost: app
    policies:
      app-exchanges-ae:
        pattern: "^app-events$"
        applyTo: exchanges
        vhost: app
        definition:
          alternate-exchange: app-events-fallback
```

### 3. Users and permissions

```yaml
rabbitmq:
  cluster:
    name: app-rabbitmq
  topology:
    users:
      app-user:
        password: change-me
        tags:
          - management
        permission:
          enabled: true
          vhost: app
          configure: ".*"
          write: ".*"
          read: ".*"
```
