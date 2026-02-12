# rabbitmq-cluster

Helm chart to define a RabbitMQ cluster via official rabbitmq.com CRDs (RabbitmqCluster).

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
| ingress.hosts | list | `[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}]` | Ingress host/path rules. |
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
| rabbitmq-topology.rabbitmq.topology.queues | object | `{}` | Map of queue definitions. |
| rabbitmq-topology.rabbitmq.topology.exchanges | object | `{}` | Map of exchange definitions. |
| rabbitmq-topology.rabbitmq.topology.bindings | object | `{}` | Map of binding definitions. |
| rabbitmq-topology.rabbitmq.topology.policies | object | `{}` | Map of policy definitions. |
| rabbitmq-topology.rabbitmq.topology.users | object | `{}` | Map of user definitions. |
| rabbitmq-topology.rabbitmq.vhosts | object | `{}` | Map of vhost definitions. |

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
      exchanges:
        app-events:
          type: direct
          durable: true
          autoDelete: false
          vhost: app
      queues:
        email-request:
          name: email_request
          type: quorum
          durable: true
          autoDelete: false
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
