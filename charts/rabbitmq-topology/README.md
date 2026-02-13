# rabbitmq-topology

![Version: 1.0.1](https://img.shields.io/badge/Version-1.0.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.18.2](https://img.shields.io/badge/AppVersion-1.18.2-informational?style=flat-square)

Helm chart to manage RabbitMQ topology resources via RabbitMQ Topology Operator CRDs.

**Homepage:** <https://www.rabbitmq.com/kubernetes/operator/using-topology-operator>

## Source Code

* <https://github.com/klicktipp/helm-charts>
* <https://www.rabbitmq.com/kubernetes/operator/using-topology-operator>
* <https://github.com/rabbitmq/messaging-topology-operator>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | `""` | Override for the Helm chart name. |
| fullnameOverride | string | `""` | Override for the fully-qualified release name. |
| rabbitmq.cluster.name | string | `""` | Target `RabbitmqCluster` resource name for all topology objects. If empty, chart fullname is used. |
| rabbitmq.topology.queueDefaults | object | `{"arguments":{},"autoDelete":false,"binding":{"destinationType":"queue","enabled":true},"durable":true,"exchange":{"autoDelete":false,"durable":true,"enabled":true,"type":"fanout"},"vhost":""}` | Default values applied to queue entries when not set per queue. Fallback chain: queue field -> queueDefaults field -> template fallback. |
| rabbitmq.topology.queueDefaults.arguments | object | `{}` | Default queue arguments merged into each queue's `arguments`. Queue-level `arguments` override keys from this map. |
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
| rabbitmq.topology.permissionDefaults | object | `{"configure":".*","enabled":true,"read":".*","referenceType":"userReference","vhost":"","write":".*"}` | Default values applied to user permission entries when not set per user. Fallback chain: user.permission field -> permissionDefaults field -> template fallback. |
| rabbitmq.topology.permissionDefaults.referenceType | string | `"userReference"` | Default value for `users.<name>.permission.referenceType` (`userReference` or `user`). Final template fallback: `userReference`. |
| rabbitmq.topology.permissionDefaults.enabled | bool | `true` | Default value for `users.<name>.permission.enabled`. Final template fallback: `true`. |
| rabbitmq.topology.permissionDefaults.vhost | string | `""` | Default value for `users.<name>.permission.vhost`. Final template fallback: selected default vhost (`/` if none marked default). |
| rabbitmq.topology.permissionDefaults.configure | string | `".*"` | Default value for `users.<name>.permission.configure`. Final template fallback: `.*`. |
| rabbitmq.topology.permissionDefaults.write | string | `".*"` | Default value for `users.<name>.permission.write`. Final template fallback: `.*`. |
| rabbitmq.topology.permissionDefaults.read | string | `".*"` | Default value for `users.<name>.permission.read`. Final template fallback: `.*`. |
| rabbitmq.topology.users | object | `{}` | Map of user definitions. Per entry you can set `metadataName` for User and `permission.metadataName` for Permission. For migration, `permission.referenceType` supports `userReference` (default) or legacy `user`. |
| rabbitmq.vhosts | object | `{}` | Map of vhost definitions. Per entry you can set `metadataName` to override Kubernetes `metadata.name`. |

<!-- BEGIN AUTO EXAMPLES -->
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
      arguments:
        x-queue-type: quorum
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
        arguments:
          x-queue-type: quorum
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
          referenceType: userReference
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
          referenceType: userReference
          metadataName: app-user
          enabled: true
          vhost: "/"
          configure: ".*"
          write: ".*"
          read: ".*"
```

### 5. Legacy Permission migration (`spec.user`)

Use this if an existing Permission object was originally created with `spec.user` and you want to avoid immutable-field update errors during migration.

```yaml
rabbitmq:
  cluster:
    name: app-rabbitmq
  topology:
    users:
      app-user:
        name: app-user
        existingSecret: rabbitmq-user-app
        permission:
          metadataName: app-user
          referenceType: user
          user: app-user
          vhost: "/"
```

### 6. Preserve existing Kubernetes resource names (`metadata.name`)

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

<!-- END AUTO EXAMPLES -->
