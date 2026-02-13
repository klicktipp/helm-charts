# rabbitmq-cluster

![Version: 3.0.2](https://img.shields.io/badge/Version-3.0.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.19.0](https://img.shields.io/badge/AppVersion-2.19.0-informational?style=flat-square)

Helm chart to define a RabbitMQ cluster via official rabbitmq.com CRDs (RabbitmqCluster).

**Homepage:** <https://www.rabbitmq.com/kubernetes/operator/operator-overview.html>

## Source Code

* <https://github.com/klicktipp/helm-charts>
* <https://www.rabbitmq.com/kubernetes/operator/operator-overview.html>
* <https://github.com/rabbitmq/cluster-operator>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | `""` | Override for the Helm chart name. |
| fullnameOverride | string | `""` | Override for the fully-qualified release name. |
| image.registry | string | `""` | RabbitMQ container image registry (e.g. `docker.io`, `ghcr.io`, ECR registry host). Empty means no registry prefix. |
| image.repository | string | `"rabbitmq"` | RabbitMQ container image repository. |
| image.tag | string | `"4.2-management-alpine"` | RabbitMQ container image tag. |
| pdb.enabled | bool | `false` | Create a PodDisruptionBudget for RabbitMQ pods. |
| pdb.maxUnavailable | int | `1` | `maxUnavailable` for PodDisruptionBudget (int or percentage string). |
| ingress.enabled | bool | `false` | Create an Ingress for RabbitMQ management UI. |
| ingress.className | string | `""` | IngressClass name. |
| ingress.annotations | object | `{}` | Additional annotations for Ingress. |
| ingress.hosts | list | `[{"host":"chart-example.local","paths":[{"path":"/","pathType":"Prefix"}]}]` | Ingress host/path rules. |
| ingress.tls | list | `[]` | TLS configuration entries for Ingress. |
| monitoring.enabled | bool | `false` | Enable monitoring resources created by this chart. |
| monitoring.serviceMonitor.enabled | bool | `false` | Create a ServiceMonitor (requires Prometheus Operator CRDs). |
| terminationGracePeriodSeconds | int | `600` | Pod termination grace period in seconds for RabbitMQ pods. |
| extraObjects | list | `[]` | Additional raw Kubernetes objects rendered as-is via `tpl`. |
| rabbitmq.cluster.enabled | bool | `true` | Create the `RabbitmqCluster` resource. |
| rabbitmq.cluster.name | string | `""` | Name of the `RabbitmqCluster` resource. If empty, chart fullname is used. |
| rabbitmq.cluster.replicas | int | `1` | Number of RabbitMQ replicas. |
| rabbitmq.cluster.delayStartSeconds | int | `10` | Delay in seconds before RabbitMQ node starts. |
| rabbitmq.cluster.persistence.enabled | bool | `false` | Enable persistent volume claim for RabbitMQ data. |
| rabbitmq.cluster.persistence.storage | string | `"10Gi"` | Persistent volume size. |
| rabbitmq.cluster.persistence.storageClassName | string | `""` | StorageClass name for persistence (empty = cluster default). |
| rabbitmq.cluster.resources | object | `{}` | Resource requests/limits for RabbitMQ container. |
| rabbitmq.cluster.configProfile | string | `nil` | Predefined RabbitMQ config profile (`PROD`, `STAGING`, `DEV`) or `null`. |
| rabbitmq.cluster.extraConfig | string | `""` | Additional RabbitMQ config appended to generated config. |
| rabbitmq.cluster.additionalPlugins | list | `["rabbitmq_management","rabbitmq_prometheus","rabbitmq_peer_discovery_k8s"]` | Default RabbitMQ plugins to enable. |
| rabbitmq.cluster.extraPlugins | list | `[]` | Extra RabbitMQ plugins to enable in addition to defaults. |
| rabbitmq.cluster.override | object | `{}` | Raw override merged into RabbitmqCluster spec. |
| rabbitmq.cluster.affinity | object | `{}` | Pod affinity/anti-affinity for RabbitMQ pods. |
| rabbitmq-topology.enabled | bool | `false` | Enable the `rabbitmq-topology` dependency chart. |
| rabbitmq-topology.rabbitmq.topology.queueDefaults | object | `{"arguments":{},"autoDelete":false,"binding":{"destinationType":"queue","enabled":true},"durable":true,"exchange":{"autoDelete":false,"durable":true,"enabled":true,"type":"fanout"},"vhost":""}` | Pass-through defaults for the rabbitmq-topology subchart. Fallback chain in subchart: object field -> these defaults -> template fallback. |
| rabbitmq-topology.rabbitmq.topology.queueDefaults.arguments | object | `{}` | Default value for `queues.<name>.arguments` in the topology subchart. Queue-level `arguments` override keys from this map. |
| rabbitmq-topology.rabbitmq.topology.queueDefaults.durable | bool | `true` | Default value for `queues.<name>.durable` in the topology subchart. Final template fallback: `true`. |
| rabbitmq-topology.rabbitmq.topology.queueDefaults.autoDelete | bool | `false` | Default value for `queues.<name>.autoDelete` in the topology subchart. Final template fallback: `false`. |
| rabbitmq-topology.rabbitmq.topology.queueDefaults.vhost | string | `""` | Default value for `queues.<name>.vhost` in the topology subchart. Final template fallback: selected default vhost (`/` if none marked default). |
| rabbitmq-topology.rabbitmq.topology.queueDefaults.exchange.enabled | bool | `true` | Default value for `queues.<name>.exchange.enabled` in the topology subchart. Final template fallback: `true`. |
| rabbitmq-topology.rabbitmq.topology.queueDefaults.exchange.type | string | `"fanout"` | Default value for `queues.<name>.exchange.type` in the topology subchart. Final template fallback: `fanout`. |
| rabbitmq-topology.rabbitmq.topology.queueDefaults.exchange.durable | bool | `true` | Default value for `queues.<name>.exchange.durable` in the topology subchart. Final template fallback: `true`. |
| rabbitmq-topology.rabbitmq.topology.queueDefaults.exchange.autoDelete | bool | `false` | Default value for `queues.<name>.exchange.autoDelete` in the topology subchart. Final template fallback: `false`. |
| rabbitmq-topology.rabbitmq.topology.queueDefaults.binding.enabled | bool | `true` | Default value for `queues.<name>.binding.enabled` in the topology subchart. Final template fallback: `true`. |
| rabbitmq-topology.rabbitmq.topology.queueDefaults.binding.destinationType | string | `"queue"` | Default value for `queues.<name>.binding.destinationType` in the topology subchart. Final template fallback: `queue`. |
| rabbitmq-topology.rabbitmq.topology.exchangeDefaults.type | string | `"fanout"` | Default value for `exchanges.<name>.type` in the topology subchart. Final template fallback: `fanout`. |
| rabbitmq-topology.rabbitmq.topology.exchangeDefaults.durable | bool | `true` | Default value for `exchanges.<name>.durable` in the topology subchart. Final template fallback: `true`. |
| rabbitmq-topology.rabbitmq.topology.exchangeDefaults.autoDelete | bool | `false` | Default value for `exchanges.<name>.autoDelete` in the topology subchart. Final template fallback: `false`. |
| rabbitmq-topology.rabbitmq.topology.exchangeDefaults.vhost | string | `""` | Default value for `exchanges.<name>.vhost` in the topology subchart. Final template fallback: selected default vhost (`/` if none marked default). |
| rabbitmq-topology.rabbitmq.topology.bindingDefaults.vhost | string | `""` | Default value for `bindings.<name>.vhost` in the topology subchart. Final template fallback: selected default vhost (`/` if none marked default). |
| rabbitmq-topology.rabbitmq.topology.bindingDefaults.destinationType | string | `"queue"` | Default value for `bindings.<name>.destinationType` in the topology subchart. Final template fallback: `queue`. |
| rabbitmq-topology.rabbitmq.topology.policyDefaults.vhost | string | `""` | Default value for `policies.<name>.vhost` in the topology subchart. Final template fallback: selected default vhost (`/` if none marked default). |
| rabbitmq-topology.rabbitmq.topology.policyDefaults.priority | int | `0` | Default value for `policies.<name>.priority` in the topology subchart. Final template fallback: `0`. |
| rabbitmq-topology.rabbitmq.topology.policyDefaults.applyTo | string | `""` | Default value for `policies.<name>.applyTo` in the topology subchart. Final template fallback: required on each policy if empty here. |
| rabbitmq-topology.rabbitmq.topology.permissionDefaults.referenceType | string | `"userReference"` | Default value for `users.<name>.permission.referenceType` in the topology subchart (`userReference` or `user`). Final template fallback: `userReference`. |
| rabbitmq-topology.rabbitmq.topology.permissionDefaults.enabled | bool | `true` | Default value for `users.<name>.permission.enabled` in the topology subchart. Final template fallback: `true`. |
| rabbitmq-topology.rabbitmq.topology.permissionDefaults.vhost | string | `""` | Default value for `users.<name>.permission.vhost` in the topology subchart. Final template fallback: selected default vhost (`/` if none marked default). |
| rabbitmq-topology.rabbitmq.topology.permissionDefaults.configure | string | `".*"` | Default value for `users.<name>.permission.configure` in the topology subchart. Final template fallback: `.*`. |
| rabbitmq-topology.rabbitmq.topology.permissionDefaults.write | string | `".*"` | Default value for `users.<name>.permission.write` in the topology subchart. Final template fallback: `.*`. |
| rabbitmq-topology.rabbitmq.topology.permissionDefaults.read | string | `".*"` | Default value for `users.<name>.permission.read` in the topology subchart. Final template fallback: `.*`. |
| rabbitmq-topology.rabbitmq.topology.queues | object | `{}` | Map of queue definitions. Per entry you can set `metadataName` to override Kubernetes `metadata.name`. |
| rabbitmq-topology.rabbitmq.topology.exchanges | object | `{}` | Map of exchange definitions. Per entry you can set `metadataName` to override Kubernetes `metadata.name`. |
| rabbitmq-topology.rabbitmq.topology.bindings | object | `{}` | Map of binding definitions. Per entry you can set `metadataName` to override Kubernetes `metadata.name`. |
| rabbitmq-topology.rabbitmq.topology.policies | object | `{}` | Map of policy definitions. Per entry you can set `metadataName` to override Kubernetes `metadata.name`. |
| rabbitmq-topology.rabbitmq.topology.users | object | `{}` | Map of user definitions. Per entry you can set `metadataName` for User and `permission.metadataName` for Permission. For migration, `permission.referenceType` supports `userReference` (default) or legacy `user`. |
| rabbitmq-topology.rabbitmq.vhosts | object | `{}` | Map of vhost definitions. Per entry you can set `metadataName` to override Kubernetes `metadata.name`. |

<!-- BEGIN AUTO EXAMPLES -->
## Examples

### 1. Cluster only

```yaml
rabbitmq:
  cluster:
    enabled: true
    name: app-rabbitmq
    replicas: 3
    persistence:
      enabled: true
      storage: 20Gi
      storageClassName: kt-gp3
```

### 2. Cluster + topology subchart

```yaml
rabbitmq:
  cluster:
    enabled: true
    name: app-rabbitmq

rabbitmq-topology:
  enabled: true
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
          durable: true
          autoDelete: false
          vhost: app
      queues:
        email-request:
          name: email_request
          durable: true
          autoDelete: false
          vhost: app
      bindings:
        email-request:
          source: app-events
          destination: email_request
          destinationType: queue
          routingKey: email_request
          vhost: app
```

### 3. Topology to external cluster

```yaml
rabbitmq:
  cluster:
    enabled: false

rabbitmq-topology:
  enabled: true
  rabbitmq:
    cluster:
      name: existing-rabbitmq
    topology:
      exchanges:
        app-events:
          type: topic
```

### 4. Users from existing secrets (e.g. 1Password)

```yaml
rabbitmq-topology:
  enabled: true
  rabbitmq:
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

### 5. Users with chart-managed secrets

```yaml
rabbitmq-topology:
  enabled: true
  rabbitmq:
    topology:
      users:
        smtp-user:
          metadataName: smtp-user
          password: "change-me"
          permission:
            referenceType: userReference
            metadataName: smtp-user
            enabled: true
            vhost: "/"
            configure: ".*"
            write: ".*"
            read: ".*"
```

### 6. Legacy Permission migration (`spec.user`)

```yaml
rabbitmq-topology:
  enabled: true
  rabbitmq:
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

### 7. Preserve existing Kubernetes resource names (`metadata.name`)

```yaml
rabbitmq-topology:
  enabled: true
  rabbitmq:
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
