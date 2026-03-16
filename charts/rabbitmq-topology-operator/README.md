# rabbitmq-topology-operator

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.18.3](https://img.shields.io/badge/AppVersion-1.18.3-informational?style=flat-square)

Helm chart to deploy the official RabbitMQ Messaging Topology Operator.

**Homepage:** <https://www.rabbitmq.com/kubernetes/operator/using-topology-operator>

## Source Code

* <https://github.com/klicktipp/helm-charts>
* <https://github.com/rabbitmq/messaging-topology-operator>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enabled | bool | `true` |  |
| image.registry | string | `"docker.io"` |  |
| image.repository | string | `"rabbitmqoperator/messaging-topology-operator"` |  |
| image.tag | string | `""` |  |
| image.digest | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.pullSecrets | list | `[]` |  |
| revisionHistoryLimit | int | `10` |  |
| watchAllNamespaces | bool | `true` |  |
| watchNamespaces | list | `[]` |  |
| replicaCount | int | `1` |  |
| topologySpreadConstraints | list | `[]` |  |
| schedulerName | string | `""` |  |
| terminationGracePeriodSeconds | string | `""` |  |
| hostNetwork | bool | `false` |  |
| dnsPolicy | string | `"ClusterFirst"` |  |
| livenessProbe.enabled | bool | `true` |  |
| livenessProbe.initialDelaySeconds | int | `5` |  |
| livenessProbe.periodSeconds | int | `30` |  |
| livenessProbe.timeoutSeconds | int | `5` |  |
| livenessProbe.successThreshold | int | `1` |  |
| livenessProbe.failureThreshold | int | `5` |  |
| readinessProbe.enabled | bool | `true` |  |
| readinessProbe.initialDelaySeconds | int | `5` |  |
| readinessProbe.periodSeconds | int | `30` |  |
| readinessProbe.timeoutSeconds | int | `5` |  |
| readinessProbe.successThreshold | int | `1` |  |
| readinessProbe.failureThreshold | int | `5` |  |
| startupProbe.enabled | bool | `false` |  |
| startupProbe.initialDelaySeconds | int | `5` |  |
| startupProbe.periodSeconds | int | `30` |  |
| startupProbe.timeoutSeconds | int | `5` |  |
| startupProbe.successThreshold | int | `1` |  |
| startupProbe.failureThreshold | int | `5` |  |
| customLivenessProbe | object | `{}` |  |
| customReadinessProbe | object | `{}` |  |
| customStartupProbe | object | `{}` |  |
| skipCreateAdmissionWebhookConfig | bool | `false` |  |
| existingWebhookCertSecret | string | `""` |  |
| existingWebhookCertCABundle | string | `""` |  |
| useCertManager | bool | `false` |  |
| resources | object | `{}` |  |
| pdb.create | bool | `true` |  |
| pdb.minAvailable | string | `""` |  |
| pdb.maxUnavailable | string | `""` |  |
| podSecurityContext.enabled | bool | `true` |  |
| podSecurityContext.fsGroupChangePolicy | string | `"Always"` |  |
| podSecurityContext.sysctls | list | `[]` |  |
| podSecurityContext.supplementalGroups | list | `[]` |  |
| podSecurityContext.fsGroup | int | `1001` |  |
| containerSecurityContext.enabled | bool | `true` |  |
| containerSecurityContext.seLinuxOptions | object | `{}` |  |
| containerSecurityContext.runAsUser | int | `1001` |  |
| containerSecurityContext.runAsGroup | int | `1001` |  |
| containerSecurityContext.runAsNonRoot | bool | `true` |  |
| containerSecurityContext.privileged | bool | `false` |  |
| containerSecurityContext.readOnlyRootFilesystem | bool | `true` |  |
| containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| containerSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| fullnameOverride | string | `""` |  |
| command | list | `[]` |  |
| args | list | `[]` |  |
| automountServiceAccountToken | bool | `true` |  |
| hostAliases | list | `[]` |  |
| podLabels | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| affinity | object | `{}` |  |
| nodeSelector | object | `{}` |  |
| tolerations | list | `[]` |  |
| updateStrategy.type | string | `"RollingUpdate"` |  |
| priorityClassName | string | `""` |  |
| lifecycleHooks | object | `{}` |  |
| containerPorts.metrics | int | `8080` |  |
| extraEnvVars | list | `[]` |  |
| extraEnvVarsCM | string | `""` |  |
| extraEnvVarsSecret | string | `""` |  |
| extraVolumes | list | `[]` |  |
| extraVolumeMounts | list | `[]` |  |
| sidecars | list | `[]` |  |
| initContainers | list | `[]` |  |
| service.type | string | `"ClusterIP"` |  |
| service.ports.webhook | int | `443` |  |
| service.nodePorts.http | string | `""` |  |
| service.clusterIP | string | `""` |  |
| service.loadBalancerIP | string | `""` |  |
| service.extraPorts | list | `[]` |  |
| service.loadBalancerSourceRanges | list | `[]` |  |
| service.externalTrafficPolicy | string | `"Cluster"` |  |
| service.annotations | object | `{}` |  |
| service.sessionAffinity | string | `"None"` |  |
| service.sessionAffinityConfig | object | `{}` |  |
| networkPolicy.enabled | bool | `true` |  |
| networkPolicy.kubeAPIServerPorts[0] | int | `443` |  |
| networkPolicy.kubeAPIServerPorts[1] | int | `6443` |  |
| networkPolicy.kubeAPIServerPorts[2] | int | `8443` |  |
| networkPolicy.allowExternal | bool | `true` |  |
| networkPolicy.allowExternalEgress | bool | `true` |  |
| networkPolicy.extraIngress | list | `[]` |  |
| networkPolicy.extraEgress | list | `[]` |  |
| networkPolicy.ingressNSMatchLabels | object | `{}` |  |
| networkPolicy.ingressNSPodMatchLabels | object | `{}` |  |
| rbac.create | bool | `true` |  |
| rbac.clusterRole.customRules | list | `[]` |  |
| rbac.clusterRole.extraRules | list | `[]` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automountServiceAccountToken | bool | `false` |  |
| metrics.service.enabled | bool | `false` |  |
| metrics.service.type | string | `"ClusterIP"` |  |
| metrics.service.ports.http | int | `80` |  |
| metrics.service.nodePorts.http | string | `""` |  |
| metrics.service.clusterIP | string | `""` |  |
| metrics.service.extraPorts | list | `[]` |  |
| metrics.service.loadBalancerIP | string | `""` |  |
| metrics.service.loadBalancerSourceRanges | list | `[]` |  |
| metrics.service.externalTrafficPolicy | string | `"Cluster"` |  |
| metrics.service.annotations."prometheus.io/scrape" | string | `"true"` |  |
| metrics.service.annotations."prometheus.io/port" | string | `"{{ .Values.metrics.service.ports.http }}"` |  |
| metrics.service.sessionAffinity | string | `"None"` |  |
| metrics.service.sessionAffinityConfig | object | `{}` |  |
| metrics.serviceMonitor.enabled | bool | `false` |  |
| metrics.serviceMonitor.namespace | string | `""` |  |
| metrics.serviceMonitor.jobLabel | string | `"app.kubernetes.io/name"` |  |
| metrics.serviceMonitor.selector | object | `{}` |  |
| metrics.serviceMonitor.honorLabels | bool | `false` |  |
| metrics.serviceMonitor.scrapeTimeout | string | `""` |  |
| metrics.serviceMonitor.interval | string | `""` |  |
| metrics.serviceMonitor.metricRelabelings | list | `[]` |  |
| metrics.serviceMonitor.relabelings | list | `[]` |  |
| metrics.serviceMonitor.labels | object | `{}` |  |
| metrics.podMonitor.enabled | bool | `false` |  |
| metrics.podMonitor.jobLabel | string | `"app.kubernetes.io/name"` |  |
| metrics.podMonitor.namespace | string | `""` |  |
| metrics.podMonitor.honorLabels | bool | `false` |  |
| metrics.podMonitor.selector | object | `{}` |  |
| metrics.podMonitor.interval | string | `"30s"` |  |
| metrics.podMonitor.scrapeTimeout | string | `"30s"` |  |
| metrics.podMonitor.additionalLabels | object | `{}` |  |
| metrics.podMonitor.relabelings | list | `[]` |  |
| metrics.podMonitor.metricRelabelings | list | `[]` |  |
| global.imageRegistry | string | `""` |  |
| global.imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| commonLabels | object | `{}` |  |
| commonAnnotations | object | `{}` |  |
| clusterDomain | string | `"cluster.local"` |  |
| diagnosticMode.enabled | bool | `false` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
