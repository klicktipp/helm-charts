# rabbitmq-topology

Helm chart to manage RabbitMQ topology resources via RabbitMQ Topology Operator CRDs.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | `""` | Override for the Helm chart name. |
| fullnameOverride | string | `""` | Override for the fully-qualified release name. |
| rabbitmq.cluster.name | string | `""` | Target `RabbitmqCluster` resource name for all topology objects. If empty, chart fullname is used. |
| rabbitmq.topology.queueDefaults | object | `{"autoDelete":false,"binding":{"destinationType":"queue","enabled":true},"durable":true,"exchange":{"autoDelete":false,"durable":true,"enabled":true,"type":"fanout"},"type":"quorum","vhost":""}` | Default values applied to queue entries when not set per queue. Fallback chain: queue field -> queueDefaults field -> template fallback. |
| rabbitmq.topology.queueDefaults.type | string | `"quorum"` | Default queue type. Final template fallback: `quorum`. |
| rabbitmq.topology.queueDefaults.durable | bool | `true` | Default queue durable flag. Final template fallback: `true`. |
| rabbitmq.topology.queueDefaults.autoDelete | bool | `false` | Default queue autoDelete flag. Final template fallback: `false`. |
| rabbitmq.topology.queueDefaults.vhost | string | `""` | Default queue vhost. Final template fallback: selected default vhost (`/` if none marked default). |
| rabbitmq.topology.queueDefaults.exchange.enabled | bool | `true` | Default value for `queues.<name>.exchange.enabled` when not set per queue. Final template fallback: `true`. |
| rabbitmq.topology.queueDefaults.exchange.type | string | `"fanout"` | Default value for `queues.<name>.exchange.type`. Final template fallback: `fanout`. |
| rabbitmq.topology.queueDefaults.exchange.durable | bool | `true` | Default value for `queues.<name>.exchange.durable`. Final template fallback: `true`. |
| rabbitmq.topology.queueDefaults.exchange.autoDelete | bool | `false` | Default value for `queues.<name>.exchange.autoDelete`. Final template fallback: `false`. |
| rabbitmq.topology.queueDefaults.binding.enabled | bool | `true` | Default value for `queues.<name>.binding.enabled` when not set per queue. Final template fallback: `true`. |
| rabbitmq.topology.queueDefaults.binding.destinationType | string | `"queue"` | Default value for `queues.<name>.binding.destinationType`. Final template fallback: `queue`. |
| rabbitmq.topology.exchangeDefaults | object | `{"autoDelete":false,"durable":true,"type":"fanout","vhost":""}` | Default values applied to top-level exchange entries when not set per exchange. Fallback chain: exchange field -> exchangeDefaults field -> template fallback. |
| rabbitmq.topology.exchangeDefaults.type | string | `"fanout"` | Default exchange type. Final template fallback: `fanout`. |
| rabbitmq.topology.exchangeDefaults.durable | bool | `true` | Default exchange durable flag. Final template fallback: `true`. |
| rabbitmq.topology.exchangeDefaults.autoDelete | bool | `false` | Default exchange autoDelete flag. Final template fallback: `false`. |
| rabbitmq.topology.exchangeDefaults.vhost | string | `""` | Default exchange vhost. Final template fallback: selected default vhost (`/` if none marked default). |
| rabbitmq.topology.bindingDefaults | object | `{"destinationType":"queue","vhost":""}` | Default values applied to top-level binding entries when not set per binding. Fallback chain: binding field -> bindingDefaults field -> template fallback. |
| rabbitmq.topology.bindingDefaults.vhost | string | `""` | Default binding vhost. Final template fallback: selected default vhost (`/` if none marked default). |
| rabbitmq.topology.bindingDefaults.destinationType | string | `"queue"` | Default binding destinationType. Final template fallback: `queue`. |
| rabbitmq.topology.policyDefaults | object | `{"applyTo":"","priority":0,"vhost":""}` | Default values applied to top-level policy entries when not set per policy. Fallback chain: policy field -> policyDefaults field -> template fallback. |
| rabbitmq.topology.policyDefaults.vhost | string | `""` | Default policy vhost. Final template fallback: selected default vhost (`/` if none marked default). |
| rabbitmq.topology.policyDefaults.priority | int | `0` | Default policy priority. Final template fallback: `0`. |
| rabbitmq.topology.policyDefaults.applyTo | string | `""` | Optional default policy applyTo (`all`, `queues`, `exchanges`). Final template fallback: required on each policy if empty here. |
| rabbitmq.topology.queues | object | `{}` | Map of queue definitions. Per entry you can set `metadataName` to override Kubernetes `metadata.name`. |
| rabbitmq.topology.exchanges | object | `{}` | Map of exchange definitions. Per entry you can set `metadataName` to override Kubernetes `metadata.name`. |
| rabbitmq.topology.bindings | object | `{}` | Map of binding definitions. Per entry you can set `metadataName` to override Kubernetes `metadata.name`. |
| rabbitmq.topology.policies | object | `{}` | Map of policy definitions. Per entry you can set `metadataName` to override Kubernetes `metadata.name`. |
| rabbitmq.topology.users | object | `{}` | Map of user definitions. Per entry you can set `metadataName` for User and `permission.metadataName` for Permission. |
| rabbitmq.vhosts | object | `{}` | Map of vhost definitions. Per entry you can set `metadataName` to override Kubernetes `metadata.name`. |

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
    queueDefaults:
      exchange:
        enabled: false
      binding:
        enabled: false
    exchanges:
      app-events:
        type: direct
        vhost: app
    queues:
      email-request:
        name: email_request
        type: quorum
        vhost: app
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
    queueDefaults:
      exchange:
        enabled: false
      binding:
        enabled: false
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

### 4. Users from existing secrets (e.g. 1Password)

```yaml
rabbitmq:
  cluster:
    name: app-rabbitmq
  topology:
    users:
      app-user:
        metadataName: app-user
        existingSecret: rabbitmq-user-app
        permission:
          metadataName: app-user
          enabled: true
          vhost: "/"
          configure: ".*"
          write: ".*"
          read: ".*"
```

### 5. Preserve existing Kubernetes resource names (`metadata.name`)

```yaml
rabbitmq:
  cluster:
    name: app-rabbitmq
  vhosts:
    app:
      name: app
      metadataName: app
  topology:
    exchanges:
      app-events:
        name: app-events
        metadataName: app-events
        type: direct
        vhost: app
    queues:
      email-request:
        name: email_request
        metadataName: email-request
        vhost: app
        exchange:
          enabled: false
        binding:
          enabled: false
    bindings:
      email-request:
        metadataName: email-request
        source: app-events
        destination: email_request
        destinationType: queue
        vhost: app
    policies:
      app-exchanges-ae:
        name: app-exchanges-ae
        metadataName: app-exchanges-ae
        pattern: "^app-events$"
        applyTo: exchanges
        vhost: app
        definition:
          alternate-exchange: app-events-fallback
```
