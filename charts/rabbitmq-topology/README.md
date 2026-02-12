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
    name: halon-rabbitmq
  vhosts:
    halon:
      enabled: true
      default: true
      name: halon
  topology:
    exchanges:
      halon-events:
        type: direct
        vhost: halon
    queues:
      email-request:
        name: email_request
        type: quorum
        vhost: halon
        exchange:
          enabled: false
        binding:
          enabled: false
    bindings:
      email-request:
        source: halon-events
        destination: email_request
        destinationType: queue
        routingKey: email_request
        vhost: halon
```

### 2. Add fallback queue and policy (alternate exchange)

```yaml
rabbitmq:
  cluster:
    name: halon-rabbitmq
  topology:
    exchanges:
      halon-events:
        type: direct
        vhost: halon
      halon-events-fallback:
        type: fanout
        vhost: halon
    queues:
      halon-events-fallback:
        name: halon_events_fallback
        type: quorum
        vhost: halon
        exchange:
          enabled: false
        binding:
          enabled: false
    bindings:
      halon-events-fallback:
        source: halon-events-fallback
        destination: halon_events_fallback
        destinationType: queue
        vhost: halon
    policies:
      halon-exchanges-ae:
        pattern: "^halon-events$"
        applyTo: exchanges
        vhost: halon
        definition:
          alternate-exchange: halon-events-fallback
```

### 3. Users and permissions

```yaml
rabbitmq:
  cluster:
    name: halon-rabbitmq
  topology:
    users:
      app-user:
        password: change-me
        tags:
          - management
        permission:
          enabled: true
          vhost: halon
          configure: ".*"
          write: ".*"
          read: ".*"
```
