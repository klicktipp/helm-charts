# rabbitmq-topology-operator

![Version: 0.1.4](https://img.shields.io/badge/Version-0.1.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.18.3](https://img.shields.io/badge/AppVersion-1.18.3-informational?style=flat-square)

Helm chart to deploy the official RabbitMQ Messaging Topology Operator.

**Homepage:** <https://www.rabbitmq.com/kubernetes/operator/using-topology-operator>

## Source Code

* <https://github.com/klicktipp/helm-charts>
* <https://www.rabbitmq.com/kubernetes/operator/using-topology-operator>
* <https://github.com/rabbitmq/messaging-topology-operator>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enabled | bool | `true` | Deploy the RabbitMQ Messaging Topology Operator. |
| image | object | `{"digest":"","pullPolicy":"IfNotPresent","pullSecrets":[],"registry":"docker.io","repository":"rabbitmqoperator/messaging-topology-operator","tag":""}` | Messaging Topology Operator image |
| image.registry | string | `"docker.io"` | RabbitMQ Messaging Topology Operator image registry |
| image.repository | string | `"rabbitmqoperator/messaging-topology-operator"` | RabbitMQ Messaging Topology Operator image repository |
| image.tag | string | `""` | RabbitMQ Messaging Topology Operator image tag. When empty, `.Chart.AppVersion` is used |
| image.digest | string | `""` | Messaging Topology Operator image digest in the form `sha256:...`; overrides `image.tag` when set |
| image.pullPolicy | string | `"IfNotPresent"` | RabbitMQ Messaging Topology Operator image pull policy |
| image.pullSecrets | list | `[]` | RabbitMQ Messaging Topology Operator image pull secrets |
| revisionHistoryLimit | int | `10` | Number of old ReplicaSets to retain |
| watchAllNamespaces | bool | `true` | Watch resources across all namespaces |
| watchNamespaces | list | `[]` | List of namespaces to watch when `watchAllNamespaces=false` |
| replicaCount | int | `1` | Number of RabbitMQ Messaging Topology Operator replicas to deploy |
| topologySpreadConstraints | list | `[]` | The value is evaluated as a template |
| schedulerName | string | `""` | Alternative scheduler |
| terminationGracePeriodSeconds | string | `""` | Time in seconds to allow the Messaging Topology Operator pod to terminate gracefully |
| hostNetwork | bool | `false` | Run the pod in the host network namespace |
| dnsPolicy | string | `"ClusterFirst"` | Alternative DNS policy |
| livenessProbe | object | `{"enabled":true,"failureThreshold":5,"initialDelaySeconds":5,"periodSeconds":30,"successThreshold":1,"timeoutSeconds":5}` | Health probes for the Messaging Topology Operator container |
| livenessProbe.enabled | bool | `true` | Enable livenessProbe on RabbitMQ Messaging Topology Operator nodes |
| livenessProbe.initialDelaySeconds | int | `5` | Initial delay seconds for livenessProbe |
| livenessProbe.periodSeconds | int | `30` | Period seconds for livenessProbe |
| livenessProbe.timeoutSeconds | int | `5` | Timeout seconds for livenessProbe |
| livenessProbe.successThreshold | int | `1` | Success threshold for livenessProbe |
| livenessProbe.failureThreshold | int | `5` | Failure threshold for livenessProbe |
| readinessProbe.enabled | bool | `true` | Enable readinessProbe on RabbitMQ Messaging Topology Operator nodes |
| readinessProbe.initialDelaySeconds | int | `5` | Initial delay seconds for readinessProbe |
| readinessProbe.periodSeconds | int | `30` | Period seconds for readinessProbe |
| readinessProbe.timeoutSeconds | int | `5` | Timeout seconds for readinessProbe |
| readinessProbe.successThreshold | int | `1` | Success threshold for readinessProbe |
| readinessProbe.failureThreshold | int | `5` | Failure threshold for readinessProbe |
| startupProbe.enabled | bool | `false` | Enable startupProbe on RabbitMQ Messaging Topology Operator nodes |
| startupProbe.initialDelaySeconds | int | `5` | Initial delay seconds for startupProbe |
| startupProbe.periodSeconds | int | `30` | Period seconds for startupProbe |
| startupProbe.timeoutSeconds | int | `5` | Timeout seconds for startupProbe |
| startupProbe.successThreshold | int | `1` | Success threshold for startupProbe |
| startupProbe.failureThreshold | int | `5` | Failure threshold for startupProbe |
| customLivenessProbe | object | `{}` | Custom livenessProbe that overrides the default one |
| customReadinessProbe | object | `{}` | Custom readinessProbe that overrides the default one |
| customStartupProbe | object | `{}` | Custom startupProbe that overrides the default one |
| skipCreateAdmissionWebhookConfig | bool | `false` | Skip creation of the ValidatingWebhookConfiguration |
| existingWebhookCertSecret | string | `""` | Name of an existing secret containing the webhook certificates |
| existingWebhookCertCABundle | string | `""` | PEM-encoded CA Bundle of the existing secret provided in existingWebhookCertSecret (only if useCertManager=false) |
| useCertManager | bool | `false` | Deploy cert-manager objects (Issuer and Certificate) for webhooks |
| crdUpgrade | object | `{"annotations":{},"backoffLimit":1,"enabled":true,"image":{"digest":"","pullPolicy":"IfNotPresent","pullSecrets":[],"registry":"docker.io","repository":"bitnamilegacy/kubectl","tag":"1.32.4"},"resources":{}}` | CRD upgrade hook configuration. |
| crdUpgrade.enabled | bool | `true` | Enable the pre-upgrade hook that reapplies CRDs with kubectl. |
| crdUpgrade.image | object | `{"digest":"","pullPolicy":"IfNotPresent","pullSecrets":[],"registry":"docker.io","repository":"bitnamilegacy/kubectl","tag":"1.32.4"}` | Kubectl image used by the CRD upgrade hook. |
| crdUpgrade.image.registry | string | `"docker.io"` | Kubectl image registry. |
| crdUpgrade.image.repository | string | `"bitnamilegacy/kubectl"` | Kubectl image repository. |
| crdUpgrade.image.tag | string | `"1.32.4"` | Kubectl image tag. |
| crdUpgrade.image.digest | string | `""` | Kubectl image digest in the form `sha256:...`; overrides `crdUpgrade.image.tag` when set. |
| crdUpgrade.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy for the CRD upgrade hook. |
| crdUpgrade.image.pullSecrets | list | `[]` | Image pull secrets for the CRD upgrade hook. |
| crdUpgrade.annotations | object | `{}` | Annotations added to CRD upgrade hook resources. |
| crdUpgrade.resources | object | `{}` | Resource requests and limits for the CRD upgrade hook job. |
| crdUpgrade.backoffLimit | int | `1` | Number of retries before the CRD upgrade hook job is marked as failed. |
| resources | object | `{}` | Container resource requests and limits. |
| pdb | object | `{"create":true,"maxUnavailable":"","minAvailable":""}` | PodDisruptionBudget settings for the Messaging Topology Operator |
| pdb.create | bool | `true` | Enable a Pod Disruption Budget creation |
| pdb.minAvailable | string | `""` | Minimum number/percentage of pods that should remain scheduled |
| pdb.maxUnavailable | string | `""` | Maximum number/percentage of pods that may be made unavailable |
| podSecurityContext | object | `{"enabled":true,"fsGroup":1001,"fsGroupChangePolicy":"Always","supplementalGroups":[],"sysctls":[]}` | Pod security context for the Messaging Topology Operator pod |
| podSecurityContext.enabled | bool | `true` | Enable the pod security context for the Messaging Topology Operator |
| podSecurityContext.fsGroupChangePolicy | string | `"Always"` | Set filesystem group change policy |
| podSecurityContext.sysctls | list | `[]` | Set kernel settings using the sysctl interface |
| podSecurityContext.supplementalGroups | list | `[]` | Set filesystem extra groups |
| podSecurityContext.fsGroup | int | `1001` | Set RabbitMQ Messaging Topology Operator pod's Security Context fsGroup |
| containerSecurityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"enabled":true,"privileged":false,"readOnlyRootFilesystem":true,"runAsGroup":1001,"runAsNonRoot":true,"runAsUser":1001,"seLinuxOptions":{},"seccompProfile":{"type":"RuntimeDefault"}}` | Container security context for the Messaging Topology Operator container |
| containerSecurityContext.enabled | bool | `true` | Enable the container security context for the Messaging Topology Operator |
| containerSecurityContext.seLinuxOptions | object | `{}` | Set SELinux options in container |
| containerSecurityContext.runAsUser | int | `1001` | Set containers' Security Context runAsUser |
| containerSecurityContext.runAsGroup | int | `1001` | Set containers' Security Context runAsGroup |
| containerSecurityContext.runAsNonRoot | bool | `true` | Set container's Security Context runAsNonRoot |
| containerSecurityContext.privileged | bool | `false` | Set container's Security Context privileged |
| containerSecurityContext.readOnlyRootFilesystem | bool | `true` | Set container's Security Context readOnlyRootFilesystem |
| containerSecurityContext.allowPrivilegeEscalation | bool | `false` | Set container's Security Context allowPrivilegeEscalation |
| containerSecurityContext.capabilities.drop | list | `["ALL"]` | List of capabilities to be dropped |
| containerSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` | Set container's Security Context seccomp profile |
| command | list | `[]` | Override the default container command |
| args | list | `[]` | Override the default container arguments |
| automountServiceAccountToken | bool | `true` | Mount the service account token into the pod |
| hostAliases | list | `[]` | https://kubernetes.io/docs/concepts/services-networking/add-entries-to-pod-etc-hosts-with-host-aliases/ |
| podLabels | object | `{}` | Additional labels for Messaging Topology Operator pods |
| podAnnotations | object | `{}` | Additional annotations for Messaging Topology Operator pods |
| affinity | object | `{}` | Affinity rules for Messaging Topology Operator pods |
| nodeSelector | object | `{}` | Node selector for Messaging Topology Operator pods |
| tolerations | list | `[]` | Tolerations for Messaging Topology Operator pods |
| updateStrategy | object | `{"type":"RollingUpdate"}` | Deployment update strategy for the Messaging Topology Operator |
| updateStrategy.type | string | `"RollingUpdate"` | Can be set to RollingUpdate or OnDelete |
| priorityClassName | string | `""` | PriorityClass name for Messaging Topology Operator pods |
| lifecycleHooks | object | `{}` | Lifecycle hooks for the Messaging Topology Operator container |
| containerPorts | object | `{"metrics":8080}` | Metrics port exposed by the Messaging Topology Operator container |
| extraEnvVars | list | `[]` | Additional environment variables for the container. |
| extraEnvVarsCM | string | `""` | Name of an existing ConfigMap with extra environment variables for the Messaging Topology Operator |
| extraEnvVarsSecret | string | `""` | Name of an existing Secret with extra environment variables for the Messaging Topology Operator |
| extraVolumes | list | `[]` | Additional volumes for Messaging Topology Operator pods |
| extraVolumeMounts | list | `[]` | Additional volume mounts for the Messaging Topology Operator container |
| sidecars | list | `[]` | Additional sidecar containers for the pod. |
| initContainers | list | `[]` | Additional init containers for the pod. |
| service | object | `{"annotations":{},"clusterIP":"","externalTrafficPolicy":"Cluster","extraPorts":[],"loadBalancerIP":"","loadBalancerSourceRanges":[],"nodePorts":{"http":""},"ports":{"webhook":443},"sessionAffinity":"None","sessionAffinityConfig":{},"type":"ClusterIP"}` | Webhook Service settings |
| service.type | string | `"ClusterIP"` | Kubernetes Service type for the webhook service |
| service.ports | object | `{"webhook":443}` | Service port for the webhook endpoint |
| service.nodePorts | object | `{"http":""}` | Node ports to expose. |
| service.clusterIP | string | `""` | ClusterIP for the webhook service. |
| service.loadBalancerIP | string | `""` | LoadBalancer IP for the webhook Service |
| service.extraPorts | list | `[]` | Additional ports to expose on the webhook Service |
| service.loadBalancerSourceRanges | list | `[]` | Allowed source ranges for the webhook service load balancer. |
| service.externalTrafficPolicy | string | `"Cluster"` | External traffic policy for the webhook service. |
| service.annotations | object | `{}` | Additional annotations for the webhook Service |
| service.sessionAffinity | string | `"None"` | If "ClientIP", consecutive client requests will be directed to the same Pod |
| service.sessionAffinityConfig | object | `{}` | Session affinity configuration. |
| networkPolicy | object | `{"allowExternal":true,"allowExternalEgress":true,"enabled":true,"extraEgress":[],"extraIngress":[],"ingressNSMatchLabels":{},"ingressNSPodMatchLabels":{},"kubeAPIServerPorts":[443,6443,8443]}` | NetworkPolicy settings for the Messaging Topology Operator |
| networkPolicy.enabled | bool | `true` | Create a NetworkPolicy for the Messaging Topology Operator |
| networkPolicy.kubeAPIServerPorts | list | `[443,6443,8443]` | List of Kubernetes API server ports to allow |
| networkPolicy.allowExternal | bool | `true` | When set to false, ingress is limited to explicitly allowed sources. |
| networkPolicy.allowExternalEgress | bool | `true` | Allow unrestricted egress traffic |
| networkPolicy.extraIngress | list | `[]` | - frontend |
| networkPolicy.extraEgress | list | `[]` | - frontend |
| networkPolicy.ingressNSMatchLabels | object | `{}` | Pod labels to match to allow traffic from other namespaces |
| rbac | object | `{"clusterRole":{"customRules":[],"extraRules":[]},"create":true}` | RBAC configuration |
| rbac.create | bool | `true` | Specifies whether RBAC resources should be created |
| rbac.clusterRole | object | `{"customRules":[],"extraRules":[]}` | ClusterRole configuration. |
| rbac.clusterRole.customRules | list | `[]` | Custom access rules for the ClusterRole. |
| rbac.clusterRole.extraRules | list | `[]` | Extra access rules appended to the default ClusterRole. |
| serviceAccount | object | `{"annotations":{},"automountServiceAccountToken":false,"create":true,"name":""}` | ServiceAccount configuration |
| serviceAccount.create | bool | `true` | Specifies whether a ServiceAccount should be created |
| serviceAccount.name | string | `""` | If not set and create is true, a name is generated using the rabbitmq-topology-operator.fullname template |
| serviceAccount.annotations | object | `{}` | Add annotations |
| serviceAccount.automountServiceAccountToken | bool | `false` | Mount API credentials into the service account. |
| metrics.service | object | `{"annotations":{"prometheus.io/port":"{{ .Values.metrics.service.ports.http }}","prometheus.io/scrape":"true"},"clusterIP":"","enabled":false,"externalTrafficPolicy":"Cluster","extraPorts":[],"loadBalancerIP":"","loadBalancerSourceRanges":[],"nodePorts":{"http":""},"ports":{"http":80},"sessionAffinity":"None","sessionAffinityConfig":{},"type":"ClusterIP"}` | Metrics service configuration. |
| metrics.service.enabled | bool | `false` | Create a Service for the Messaging Topology Operator metrics endpoint |
| metrics.service.type | string | `"ClusterIP"` | Kubernetes Service type for the Messaging Topology Operator metrics endpoint |
| metrics.service.ports | object | `{"http":80}` | Service port for the Messaging Topology Operator metrics endpoint |
| metrics.service.nodePorts | object | `{"http":""}` | Node ports to expose. |
| metrics.service.clusterIP | string | `""` | ClusterIP for the metrics service. |
| metrics.service.extraPorts | list | `[]` | Additional ports to expose on the metrics Service |
| metrics.service.loadBalancerIP | string | `""` | LoadBalancer IP for the Messaging Topology Operator metrics service |
| metrics.service.loadBalancerSourceRanges | list | `[]` | Allowed source ranges for the metrics service load balancer. |
| metrics.service.externalTrafficPolicy | string | `"Cluster"` | External traffic policy for the metrics service. |
| metrics.service.annotations | object | `{"prometheus.io/port":"{{ .Values.metrics.service.ports.http }}","prometheus.io/scrape":"true"}` | Additional annotations for the Messaging Topology Operator metrics service |
| metrics.service.sessionAffinity | string | `"None"` | If "ClientIP", consecutive client requests will be directed to the same Pod |
| metrics.service.sessionAffinityConfig | object | `{}` | Session affinity configuration. |
| metrics.serviceMonitor.enabled | bool | `false` | Create a ServiceMonitor for the metrics service. |
| metrics.serviceMonitor.namespace | string | `""` | Namespace in which to create the ServiceMonitor. |
| metrics.serviceMonitor.jobLabel | string | `"app.kubernetes.io/name"` | Label to use as the Prometheus job name |
| metrics.serviceMonitor.selector | object | `{}` | Additional selector labels for the ServiceMonitor. |
| metrics.serviceMonitor.honorLabels | bool | `false` | Honor metrics labels |
| metrics.serviceMonitor.scrapeTimeout | string | `""` | Timeout for a single scrape request. |
| metrics.serviceMonitor.interval | string | `""` | Scrape interval; uses the Prometheus default when empty |
| metrics.serviceMonitor.metricRelabelings | list | `[]` | Metric relabeling rules |
| metrics.serviceMonitor.relabelings | list | `[]` | Target relabeling rules |
| metrics.serviceMonitor.labels | object | `{}` | Additional labels for the ServiceMonitor |
| metrics.podMonitor.enabled | bool | `false` | Create a PodMonitor resource for scraping Messaging Topology Operator metrics |
| metrics.podMonitor.jobLabel | string | `"app.kubernetes.io/name"` | Label to use as the Prometheus job name |
| metrics.podMonitor.namespace | string | `""` | Namespace in which to create the PodMonitor |
| metrics.podMonitor.honorLabels | bool | `false` | Honor metrics labels |
| metrics.podMonitor.selector | object | `{}` | Additional selector labels for the PodMonitor |
| metrics.podMonitor.interval | string | `"30s"` | Specify the interval at which metrics should be scraped |
| metrics.podMonitor.scrapeTimeout | string | `"30s"` | Specify the timeout after which the scrape is ended |
| metrics.podMonitor.additionalLabels | object | `{}` | Additional labels for the PodMonitor |
| metrics.podMonitor.relabelings | list | `[]` | Target relabeling rules |
| metrics.podMonitor.metricRelabelings | list | `[]` | Metric relabeling rules |
| global | object | `{"imagePullSecrets":[],"imageRegistry":""}` | Global image settings shared with this chart. |
| global.imageRegistry | string | `""` | Global Docker image registry |
| global.imagePullSecrets | list | `[]` | Global Docker registry secret names as an array |
| nameOverride | string | `""` | Override the chart name used in resource names |
| fullnameOverride | string | `""` | Fully override the generated resource names |
| commonLabels | object | `{}` | Additional labels to add to all rendered resources |
| commonAnnotations | object | `{}` | Additional annotations to add to all rendered resources |
| clusterDomain | string | `"cluster.local"` | Kubernetes cluster domain name |
| diagnosticMode | object | `{"enabled":false}` | Enable diagnostic mode in the operator deployment |
| diagnosticMode.enabled | bool | `false` | Enable diagnostic mode (all probes will be disabled) |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
