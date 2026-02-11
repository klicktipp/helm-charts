# rabbitmq-cluster

![Version: 2.4.1](https://img.shields.io/badge/Version-2.4.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 4.2-management](https://img.shields.io/badge/AppVersion-4.2--management-informational?style=flat-square)

Helm chart to define a RabbitMQ cluster via official rabbitmq.com CRDs (RabbitmqCluster).

**Homepage:** <https://www.rabbitmq.com/kubernetes/operator/operator-overview.html>

## Source Code

* <https://github.com/CloudPirates-io/helm-charts/tree/main/charts/rabbitmq-cluster-operator>

## Requirements

Kubernetes: `>= 1.33.0-0`

| Repository | Name | Version |
|------------|------|---------|
| https://klicktipp.github.io/helm-charts/ | klicktipp-common | 1.0.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | `""` | Partially override generated resource names. |
| fullnameOverride | string | `""` | Fully override generated resource names. |
| image | object | `{"repository":"rabbitmq","tag":"4.2-management-alpine"}` | Container image configuration. |
| image.repository | string | `"rabbitmq"` | Container image repository. |
| image.tag | string | `"4.2-management-alpine"` | Container image tag. |
| pdb | object | `{"enabled":false,"maxUnavailable":1}` | Set pdb. |
| pdb.enabled | bool | `false` | Enable this feature. |
| pdb.maxUnavailable | int | `1` | Set pdb.maxUnavailable. |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}],"tls":[]}` | Ingress configuration. |
| ingress.enabled | bool | `false` | Enable this feature. |
| ingress.className | string | `""` | Set ingress.className. |
| ingress.annotations | object | `{}` | Annotations map. |
| ingress.hosts | list | `[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}]` | Host definitions. |
| ingress.hosts[0].paths | list | `[{"path":"/","pathType":"ImplementationSpecific"}]` | Ingress path definitions. |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` | Ingress path type. |
| ingress.tls | list | `[]` | TLS configuration. |
| monitoring | object | `{"enabled":false,"serviceMonitor":{"enabled":false}}` | Set monitoring. |
| monitoring.enabled | bool | `false` | Enable this feature. |
| monitoring.serviceMonitor | object | `{"enabled":false}` | Set monitoring.serviceMonitor. |
| monitoring.serviceMonitor.enabled | bool | `false` | Enable this feature. |
| terminationGracePeriodSeconds | int | `600` | Termination grace period in seconds. |
| rabbitmq | object | `{"cluster":{"additionalPlugins":["rabbitmq_management","rabbitmq_prometheus","rabbitmq_peer_discovery_k8s"],"affinity":{},"configProfile":null,"delayStartSeconds":10,"enabled":true,"extraConfig":"","extraPlugins":[],"name":"","override":{},"persistence":{"enabled":false,"storage":"10Gi","storageClassName":""},"replicas":1,"resources":{}},"topology":{"enabled":false,"policies":{},"queues":{},"users":{}},"vhosts":{}}` | Set rabbitmq. |
| rabbitmq.cluster | object | `{"additionalPlugins":["rabbitmq_management","rabbitmq_prometheus","rabbitmq_peer_discovery_k8s"],"affinity":{},"configProfile":null,"delayStartSeconds":10,"enabled":true,"extraConfig":"","extraPlugins":[],"name":"","override":{},"persistence":{"enabled":false,"storage":"10Gi","storageClassName":""},"replicas":1,"resources":{}}` | Set rabbitmq.cluster. |
| rabbitmq.cluster.enabled | bool | `true` | Enable this feature. |
| rabbitmq.cluster.name | string | `""` | Set rabbitmq.cluster.name. |
| rabbitmq.cluster.replicas | int | `1` | Configure rabbitmq.cluster.replicas. |
| rabbitmq.cluster.delayStartSeconds | int | `10` | Configure rabbitmq.cluster.delayStartSeconds. |
| rabbitmq.cluster.persistence | object | `{"enabled":false,"storage":"10Gi","storageClassName":""}` | Persistence configuration. |
| rabbitmq.cluster.persistence.enabled | bool | `false` | Enable this feature. |
| rabbitmq.cluster.persistence.storage | string | `"10Gi"` | Set rabbitmq.cluster.persistence.storage. |
| rabbitmq.cluster.persistence.storageClassName | string | `""` | Set rabbitmq.cluster.persistence.storageClassName. |
| rabbitmq.cluster.resources | object | `{}` | Container resource requests and limits. |
| rabbitmq.cluster.configProfile | string | `nil` | Set rabbitmq.cluster.configProfile. |
| rabbitmq.cluster.extraConfig | string | `""` | Set rabbitmq.cluster.extraConfig. |
| rabbitmq.cluster.additionalPlugins | list | `["rabbitmq_management","rabbitmq_prometheus","rabbitmq_peer_discovery_k8s"]` | Configure rabbitmq.cluster.additionalPlugins. |
| rabbitmq.cluster.extraPlugins | list | `[]` | Configure rabbitmq.cluster.extraPlugins. |
| rabbitmq.cluster.override | object | `{}` | Set rabbitmq.cluster.override. |
| rabbitmq.cluster.affinity | object | `{}` | Affinity rules for pod scheduling. |
| rabbitmq.topology | object | `{"enabled":false,"policies":{},"queues":{},"users":{}}` | Set rabbitmq.topology. |
| rabbitmq.topology.enabled | bool | `false` | Enable this feature. |
| rabbitmq.topology.queues | object | `{}` | Configure rabbitmq.topology.queues. |
| rabbitmq.topology.policies | object | `{}` | Configure rabbitmq.topology.policies. |
| rabbitmq.topology.users | object | `{}` | Configure rabbitmq.topology.users. |
| rabbitmq.vhosts | object | `{}` | Configure rabbitmq.vhosts. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
