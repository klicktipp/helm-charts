# rabbitmq-cluster-operator

![Version: 0.1.8](https://img.shields.io/badge/Version-0.1.8-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.19.2](https://img.shields.io/badge/AppVersion-2.19.2-informational?style=flat-square)

Helm chart to deploy the official RabbitMQ Cluster Operator and optionally include the Messaging Topology Operator chart.

**Homepage:** <https://www.rabbitmq.com/kubernetes/operator/operator-overview.html>

## Source Code

* <https://github.com/klicktipp/helm-charts>
* <https://www.rabbitmq.com/kubernetes/operator/operator-overview.html>
* <https://github.com/rabbitmq/cluster-operator>
* <https://github.com/rabbitmq/messaging-topology-operator>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| file://../rabbitmq-topology-operator | msgTopologyOperator(rabbitmq-topology-operator) | 0.2.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global | object | `{"compatibility":{"openshift":{"adaptSecurityContext":"auto"}},"defaultStorageClass":"","imagePullSecrets":[],"imageRegistry":"","storageClass":""}` | Global settings that override per-image configuration where supported. |
| global.imageRegistry | string | `""` | Global Docker image registry |
| global.imagePullSecrets | list | `[]` | Global Docker registry secret names as an array. |
| global.defaultStorageClass | string | `""` | Global default StorageClass for Persistent Volume(s) |
| global.storageClass | string | `""` | Compatibility alias for the global default StorageClass |
| global.compatibility | object | `{"openshift":{"adaptSecurityContext":"auto"}}` | Compatibility settings for specific Kubernetes platforms |
| global.compatibility.openshift | object | `{"adaptSecurityContext":"auto"}` | Compatibility settings for OpenShift |
| global.compatibility.openshift.adaptSecurityContext | string | `"auto"` | Adjust securityContext settings for OpenShift restricted-v2 SCC. Possible values: auto, force, disabled. |
| kubeVersion | string | `""` | Override Kubernetes version |
| nameOverride | string | `""` | Override the chart name used in resource names |
| fullnameOverride | string | `""` | Fully override the generated resource names |
| commonLabels | object | `{}` | Additional labels to add to all rendered resources |
| commonAnnotations | object | `{}` | Additional annotations to add to all rendered resources |
| clusterDomain | string | `"cluster.local"` | Kubernetes cluster domain name |
| extraDeploy | list | `[]` | Additional Kubernetes manifests to deploy with this release |
| diagnosticMode | object | `{"enabled":false}` | Enable diagnostic mode in the operator deployments |
| diagnosticMode.enabled | bool | `false` | Enable diagnostic mode (all probes will be disabled) |
| rabbitmqImage.registry | string | `"docker.io"` | RabbitMQ Image registry |
| rabbitmqImage.repository | string | `"library/rabbitmq"` | RabbitMQ Image repository |
| rabbitmqImage.tag | string | `"4.2.4-management-alpine"` | RabbitMQ Image tag (immutable tags are recommended) |
| rabbitmqImage.digest | string | `""` | RabbitMQ image digest in the form `sha256:...`; overrides `rabbitmqImage.tag` when set |
| rabbitmqImage.pullSecrets | list | `[]` | RabbitMQ Image pull secrets |
| credentialUpdaterImage | object | `{"digest":"","pullSecrets":[],"registry":"docker.io","repository":"rabbitmqoperator/default-user-credential-updater","tag":"1.0.12"}` | RabbitMQ Default User Credential Updater image |
| credentialUpdaterImage.registry | string | `"docker.io"` | RabbitMQ Default User Credential Updater image registry |
| credentialUpdaterImage.repository | string | `"rabbitmqoperator/default-user-credential-updater"` | RabbitMQ Default User Credential Updater image repository |
| credentialUpdaterImage.tag | string | `"1.0.12"` | RabbitMQ Default User Credential Updater image tag (immutable tags are recommended) |
| credentialUpdaterImage.digest | string | `""` | Credential updater image digest in the form `sha256:...`; overrides `credentialUpdaterImage.tag` when set |
| credentialUpdaterImage.pullSecrets | list | `[]` | RabbitMQ Default User Credential Updater image pull secrets |
| clusterOperator | object | `{"affinity":{},"args":[],"automountServiceAccountToken":true,"command":[],"containerPorts":{"metrics":9782},"containerSecurityContext":{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"enabled":true,"privileged":false,"readOnlyRootFilesystem":true,"runAsGroup":1001,"runAsNonRoot":true,"runAsUser":1001,"seLinuxOptions":{},"seccompProfile":{"type":"RuntimeDefault"}},"crdUpgrade":{"annotations":{},"backoffLimit":1,"enabled":true,"image":{"digest":"","pullPolicy":"IfNotPresent","pullSecrets":[],"registry":"docker.io","repository":"bitnamilegacy/kubectl","tag":"1.32.4"},"resources":{}},"customLivenessProbe":{},"customReadinessProbe":{},"customStartupProbe":{},"extraEnvVars":[],"extraEnvVarsCM":"","extraEnvVarsSecret":"","extraVolumeMounts":[],"extraVolumes":[],"hostAliases":[],"image":{"digest":"","pullPolicy":"IfNotPresent","pullSecrets":[],"registry":"docker.io","repository":"rabbitmqoperator/cluster-operator","tag":""},"initContainers":[],"lifecycleHooks":{},"livenessProbe":{"enabled":true,"failureThreshold":5,"initialDelaySeconds":5,"periodSeconds":30,"successThreshold":1,"timeoutSeconds":5},"metrics":{"podMonitor":{"additionalLabels":{},"enabled":false,"honorLabels":false,"interval":"30s","jobLabel":"app.kubernetes.io/name","metricRelabelings":[],"namespace":"","params":{},"path":"","relabelings":[],"scrapeTimeout":"30s","selector":{}},"service":{"annotations":{"prometheus.io/port":"{{ .Values.clusterOperator.metrics.service.ports.http }}","prometheus.io/scrape":"true"},"clusterIP":"","enabled":false,"externalTrafficPolicy":"Cluster","extraPorts":[],"loadBalancerIP":"","loadBalancerSourceRanges":[],"nodePorts":{"http":""},"ports":{"http":80},"sessionAffinity":"None","sessionAffinityConfig":{},"type":"ClusterIP"},"serviceMonitor":{"enabled":false,"honorLabels":false,"interval":"","jobLabel":"app.kubernetes.io/name","labels":{},"metricRelabelings":[],"namespace":"","params":{},"path":"","relabelings":[],"scrapeTimeout":"","selector":{}}},"networkPolicy":{"allowExternal":true,"allowExternalEgress":true,"enabled":true,"extraEgress":[],"extraIngress":[],"ingressNSMatchLabels":{},"ingressNSPodMatchLabels":{},"kubeAPIServerPorts":[443,6443,8443]},"nodeSelector":{},"pdb":{"create":true,"maxUnavailable":"","minAvailable":""},"podAnnotations":{},"podLabels":{},"podSecurityContext":{"enabled":true,"fsGroup":1001,"fsGroupChangePolicy":"Always","supplementalGroups":[],"sysctls":[]},"priorityClassName":"","rbac":{"clusterRole":{"customRules":[],"extraRules":[]},"create":true},"readinessProbe":{"enabled":true,"failureThreshold":5,"initialDelaySeconds":5,"periodSeconds":30,"successThreshold":1,"timeoutSeconds":5},"replicaCount":1,"resources":{},"revisionHistoryLimit":10,"schedulerName":"","serviceAccount":{"annotations":{},"automountServiceAccountToken":false,"create":true,"name":""},"sidecars":[],"startupProbe":{"enabled":false,"failureThreshold":5,"initialDelaySeconds":5,"periodSeconds":30,"successThreshold":1,"timeoutSeconds":5},"terminationGracePeriodSeconds":"","tolerations":[],"topologySpreadConstraints":[],"updateStrategy":{"type":"RollingUpdate"},"watchAllNamespaces":true,"watchNamespaces":[]}` | Cluster Operator image |
| clusterOperator.image.registry | string | `"docker.io"` | RabbitMQ Cluster Operator image registry |
| clusterOperator.image.repository | string | `"rabbitmqoperator/cluster-operator"` | RabbitMQ Cluster Operator image repository |
| clusterOperator.image.tag | string | `""` | RabbitMQ Cluster Operator image tag. When empty, `.Chart.AppVersion` is used |
| clusterOperator.image.digest | string | `""` | Cluster Operator image digest in the form `sha256:...`; overrides `clusterOperator.image.tag` when set |
| clusterOperator.image.pullPolicy | string | `"IfNotPresent"` | Kubernetes image pull policy |
| clusterOperator.image.pullSecrets | list | `[]` | RabbitMQ Cluster Operator image pull secrets |
| clusterOperator.crdUpgrade | object | `{"annotations":{},"backoffLimit":1,"enabled":true,"image":{"digest":"","pullPolicy":"IfNotPresent","pullSecrets":[],"registry":"docker.io","repository":"bitnamilegacy/kubectl","tag":"1.32.4"},"resources":{}}` | CRD upgrade hook configuration. |
| clusterOperator.crdUpgrade.enabled | bool | `true` | Enable the pre-upgrade hook that reapplies CRDs with kubectl. |
| clusterOperator.crdUpgrade.image | object | `{"digest":"","pullPolicy":"IfNotPresent","pullSecrets":[],"registry":"docker.io","repository":"bitnamilegacy/kubectl","tag":"1.32.4"}` | Kubectl image used by the CRD upgrade hook. |
| clusterOperator.crdUpgrade.image.registry | string | `"docker.io"` | Kubectl image registry. |
| clusterOperator.crdUpgrade.image.repository | string | `"bitnamilegacy/kubectl"` | Kubectl image repository. |
| clusterOperator.crdUpgrade.image.tag | string | `"1.32.4"` | Kubectl image tag. |
| clusterOperator.crdUpgrade.image.digest | string | `""` | Kubectl image digest in the form `sha256:...`; overrides `clusterOperator.crdUpgrade.image.tag` when set. |
| clusterOperator.crdUpgrade.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy for the CRD upgrade hook. |
| clusterOperator.crdUpgrade.image.pullSecrets | list | `[]` | Image pull secrets for the CRD upgrade hook. |
| clusterOperator.crdUpgrade.annotations | object | `{}` | Annotations added to CRD upgrade hook resources. |
| clusterOperator.crdUpgrade.resources | object | `{}` | Resource requests and limits for the CRD upgrade hook job. |
| clusterOperator.crdUpgrade.backoffLimit | int | `1` | Number of retries before the CRD upgrade hook job is marked as failed. |
| clusterOperator.revisionHistoryLimit | int | `10` | Number of old ReplicaSets to retain |
| clusterOperator.watchAllNamespaces | bool | `true` | Watch resources across all namespaces |
| clusterOperator.watchNamespaces | list | `[]` | List of namespaces to watch when `clusterOperator.watchAllNamespaces=false` |
| clusterOperator.replicaCount | int | `1` | Number of RabbitMQ Cluster Operator replicas to deploy |
| clusterOperator.schedulerName | string | `""` | Scheduler name to use for Cluster Operator pods |
| clusterOperator.topologySpreadConstraints | list | `[]` | The value is evaluated as a template |
| clusterOperator.terminationGracePeriodSeconds | string | `""` | Time in seconds to allow the Cluster Operator pod to terminate gracefully |
| clusterOperator.livenessProbe | object | `{"enabled":true,"failureThreshold":5,"initialDelaySeconds":5,"periodSeconds":30,"successThreshold":1,"timeoutSeconds":5}` | Health probes for the Cluster Operator container |
| clusterOperator.livenessProbe.enabled | bool | `true` | Enable livenessProbe on RabbitMQ Cluster Operator nodes |
| clusterOperator.livenessProbe.initialDelaySeconds | int | `5` | Initial delay seconds for livenessProbe |
| clusterOperator.livenessProbe.periodSeconds | int | `30` | Period seconds for livenessProbe |
| clusterOperator.livenessProbe.timeoutSeconds | int | `5` | Timeout seconds for livenessProbe |
| clusterOperator.livenessProbe.failureThreshold | int | `5` | Failure threshold for livenessProbe |
| clusterOperator.livenessProbe.successThreshold | int | `1` | Success threshold for livenessProbe |
| clusterOperator.readinessProbe.enabled | bool | `true` | Enable readinessProbe on RabbitMQ Cluster Operator nodes |
| clusterOperator.readinessProbe.initialDelaySeconds | int | `5` | Initial delay seconds for readinessProbe |
| clusterOperator.readinessProbe.periodSeconds | int | `30` | Period seconds for readinessProbe |
| clusterOperator.readinessProbe.timeoutSeconds | int | `5` | Timeout seconds for readinessProbe |
| clusterOperator.readinessProbe.successThreshold | int | `1` | Success threshold for readinessProbe |
| clusterOperator.readinessProbe.failureThreshold | int | `5` | Failure threshold for readinessProbe |
| clusterOperator.startupProbe.enabled | bool | `false` | Enable startupProbe on RabbitMQ Cluster Operator nodes |
| clusterOperator.startupProbe.initialDelaySeconds | int | `5` | Initial delay seconds for startupProbe |
| clusterOperator.startupProbe.periodSeconds | int | `30` | Period seconds for startupProbe |
| clusterOperator.startupProbe.timeoutSeconds | int | `5` | Timeout seconds for startupProbe |
| clusterOperator.startupProbe.successThreshold | int | `1` | Success threshold for startupProbe |
| clusterOperator.startupProbe.failureThreshold | int | `5` | Failure threshold for startupProbe |
| clusterOperator.customLivenessProbe | object | `{}` | Custom livenessProbe that overrides the default one |
| clusterOperator.customReadinessProbe | object | `{}` | Custom readinessProbe that overrides the default one |
| clusterOperator.customStartupProbe | object | `{}` | Custom startupProbe that overrides the default one |
| clusterOperator.resources | object | `{}` | Container resource requests and limits. |
| clusterOperator.pdb | object | `{"create":true,"maxUnavailable":"","minAvailable":""}` | PodDisruptionBudget settings for the Cluster Operator |
| clusterOperator.pdb.create | bool | `true` | Enable a Pod Disruption Budget creation |
| clusterOperator.pdb.minAvailable | string | `""` | Minimum number/percentage of pods that should remain scheduled |
| clusterOperator.pdb.maxUnavailable | string | `""` | Maximum number/percentage of pods that may be made unavailable |
| clusterOperator.podSecurityContext | object | `{"enabled":true,"fsGroup":1001,"fsGroupChangePolicy":"Always","supplementalGroups":[],"sysctls":[]}` | Pod security context for the Cluster Operator pod |
| clusterOperator.podSecurityContext.enabled | bool | `true` | Enable the pod security context for the Cluster Operator |
| clusterOperator.podSecurityContext.fsGroupChangePolicy | string | `"Always"` | Set filesystem group change policy |
| clusterOperator.podSecurityContext.sysctls | list | `[]` | Set kernel settings using the sysctl interface |
| clusterOperator.podSecurityContext.supplementalGroups | list | `[]` | Set filesystem extra groups |
| clusterOperator.podSecurityContext.fsGroup | int | `1001` | Set RabbitMQ Cluster Operator pod's Security Context fsGroup |
| clusterOperator.containerSecurityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"enabled":true,"privileged":false,"readOnlyRootFilesystem":true,"runAsGroup":1001,"runAsNonRoot":true,"runAsUser":1001,"seLinuxOptions":{},"seccompProfile":{"type":"RuntimeDefault"}}` | Container security context for the Cluster Operator container |
| clusterOperator.containerSecurityContext.enabled | bool | `true` | Enable the container security context for the Cluster Operator |
| clusterOperator.containerSecurityContext.seLinuxOptions | object | `{}` | Set SELinux options in container |
| clusterOperator.containerSecurityContext.runAsUser | int | `1001` | Set containers' Security Context runAsUser |
| clusterOperator.containerSecurityContext.runAsGroup | int | `1001` | Set containers' Security Context runAsGroup |
| clusterOperator.containerSecurityContext.runAsNonRoot | bool | `true` | Set container's Security Context runAsNonRoot |
| clusterOperator.containerSecurityContext.privileged | bool | `false` | Set container's Security Context privileged |
| clusterOperator.containerSecurityContext.readOnlyRootFilesystem | bool | `true` | Set container's Security Context readOnlyRootFilesystem |
| clusterOperator.containerSecurityContext.allowPrivilegeEscalation | bool | `false` | Set container's Security Context allowPrivilegeEscalation |
| clusterOperator.containerSecurityContext.capabilities.drop | list | `["ALL"]` | List of capabilities to be dropped |
| clusterOperator.containerSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` | Set container's Security Context seccomp profile |
| clusterOperator.command | list | `[]` | Override the default container command |
| clusterOperator.args | list | `[]` | Override the default container arguments |
| clusterOperator.automountServiceAccountToken | bool | `true` | Mount the service account token into the pod |
| clusterOperator.hostAliases | list | `[]` | https://kubernetes.io/docs/concepts/services-networking/add-entries-to-pod-etc-hosts-with-host-aliases/ |
| clusterOperator.podLabels | object | `{}` | Additional labels for Cluster Operator pods |
| clusterOperator.podAnnotations | object | `{}` | Additional annotations for Cluster Operator pods |
| clusterOperator.affinity | object | `{}` | Affinity rules for Cluster Operator pods |
| clusterOperator.nodeSelector | object | `{}` | Node selector for Cluster Operator pods |
| clusterOperator.tolerations | list | `[]` | Tolerations for Cluster Operator pods |
| clusterOperator.updateStrategy | object | `{"type":"RollingUpdate"}` | Deployment update strategy for the Cluster Operator |
| clusterOperator.updateStrategy.type | string | `"RollingUpdate"` | Can be set to RollingUpdate or OnDelete |
| clusterOperator.priorityClassName | string | `""` | PriorityClass name for Cluster Operator pods |
| clusterOperator.lifecycleHooks | object | `{}` | Lifecycle hooks for the Cluster Operator container |
| clusterOperator.containerPorts | object | `{"metrics":9782}` | Metrics port exposed by the Cluster Operator container |
| clusterOperator.extraEnvVars | list | `[]` | Additional environment variables for the container. |
| clusterOperator.extraEnvVarsCM | string | `""` | Name of an existing ConfigMap with extra environment variables for the Cluster Operator |
| clusterOperator.extraEnvVarsSecret | string | `""` | Name of an existing Secret with extra environment variables for the Cluster Operator |
| clusterOperator.extraVolumes | list | `[]` | Additional volumes for Cluster Operator pods |
| clusterOperator.extraVolumeMounts | list | `[]` | Additional volume mounts for the Cluster Operator container |
| clusterOperator.sidecars | list | `[]` | Additional sidecar containers for the pod. |
| clusterOperator.initContainers | list | `[]` | Additional init containers for the pod. |
| clusterOperator.networkPolicy | object | `{"allowExternal":true,"allowExternalEgress":true,"enabled":true,"extraEgress":[],"extraIngress":[],"ingressNSMatchLabels":{},"ingressNSPodMatchLabels":{},"kubeAPIServerPorts":[443,6443,8443]}` | NetworkPolicy settings for the Cluster Operator |
| clusterOperator.networkPolicy.enabled | bool | `true` | Create a NetworkPolicy for the Cluster Operator |
| clusterOperator.networkPolicy.kubeAPIServerPorts | list | `[443,6443,8443]` | List of Kubernetes API server ports to allow |
| clusterOperator.networkPolicy.allowExternal | bool | `true` | When set to false, ingress is limited to explicitly allowed sources. |
| clusterOperator.networkPolicy.allowExternalEgress | bool | `true` | Allow unrestricted egress traffic |
| clusterOperator.networkPolicy.extraIngress | list | `[]` | - frontend |
| clusterOperator.networkPolicy.extraEgress | list | `[]` | - frontend |
| clusterOperator.networkPolicy.ingressNSMatchLabels | object | `{}` | Labels to match to allow traffic from other namespaces |
| clusterOperator.networkPolicy.ingressNSPodMatchLabels | object | `{}` | Pod labels to match to allow traffic from other namespaces |
| clusterOperator.rbac | object | `{"clusterRole":{"customRules":[],"extraRules":[]},"create":true}` | RBAC configuration |
| clusterOperator.rbac.create | bool | `true` | Specifies whether RBAC resources should be created |
| clusterOperator.rbac.clusterRole | object | `{"customRules":[],"extraRules":[]}` | ClusterRole configuration. |
| clusterOperator.rbac.clusterRole.customRules | list | `[]` | Custom access rules for the ClusterRole. |
| clusterOperator.rbac.clusterRole.extraRules | list | `[]` | Extra access rules appended to the default ClusterRole. |
| clusterOperator.serviceAccount | object | `{"annotations":{},"automountServiceAccountToken":false,"create":true,"name":""}` | ServiceAccount configuration |
| clusterOperator.serviceAccount.create | bool | `true` | Specifies whether a ServiceAccount should be created |
| clusterOperator.serviceAccount.name | string | `""` | If not set and create is true, a name is generated using the rabbitmq-cluster-operator.fullname template |
| clusterOperator.serviceAccount.annotations | object | `{}` | Add annotations |
| clusterOperator.serviceAccount.automountServiceAccountToken | bool | `false` | Mount API credentials into the service account. |
| clusterOperator.metrics | object | `{"podMonitor":{"additionalLabels":{},"enabled":false,"honorLabels":false,"interval":"30s","jobLabel":"app.kubernetes.io/name","metricRelabelings":[],"namespace":"","params":{},"path":"","relabelings":[],"scrapeTimeout":"30s","selector":{}},"service":{"annotations":{"prometheus.io/port":"{{ .Values.clusterOperator.metrics.service.ports.http }}","prometheus.io/scrape":"true"},"clusterIP":"","enabled":false,"externalTrafficPolicy":"Cluster","extraPorts":[],"loadBalancerIP":"","loadBalancerSourceRanges":[],"nodePorts":{"http":""},"ports":{"http":80},"sessionAffinity":"None","sessionAffinityConfig":{},"type":"ClusterIP"},"serviceMonitor":{"enabled":false,"honorLabels":false,"interval":"","jobLabel":"app.kubernetes.io/name","labels":{},"metricRelabelings":[],"namespace":"","params":{},"path":"","relabelings":[],"scrapeTimeout":"","selector":{}}}` | Metrics configuration. |
| clusterOperator.metrics.service | object | `{"annotations":{"prometheus.io/port":"{{ .Values.clusterOperator.metrics.service.ports.http }}","prometheus.io/scrape":"true"},"clusterIP":"","enabled":false,"externalTrafficPolicy":"Cluster","extraPorts":[],"loadBalancerIP":"","loadBalancerSourceRanges":[],"nodePorts":{"http":""},"ports":{"http":80},"sessionAffinity":"None","sessionAffinityConfig":{},"type":"ClusterIP"}` | Metrics service configuration. |
| clusterOperator.metrics.service.enabled | bool | `false` | Create a Service for the Cluster Operator metrics endpoint |
| clusterOperator.metrics.service.type | string | `"ClusterIP"` | Kubernetes Service type for the Cluster Operator metrics endpoint |
| clusterOperator.metrics.service.ports | object | `{"http":80}` | Service port for the Cluster Operator metrics endpoint |
| clusterOperator.metrics.service.nodePorts | object | `{"http":""}` | Node ports to expose. |
| clusterOperator.metrics.service.clusterIP | string | `""` | ClusterIP for the metrics service. |
| clusterOperator.metrics.service.extraPorts | list | `[]` | Additional ports to expose on the metrics Service |
| clusterOperator.metrics.service.loadBalancerIP | string | `""` | LoadBalancer IP for the Cluster Operator metrics Service |
| clusterOperator.metrics.service.loadBalancerSourceRanges | list | `[]` | Allowed source ranges for the metrics service load balancer. |
| clusterOperator.metrics.service.externalTrafficPolicy | string | `"Cluster"` | External traffic policy for the metrics service. |
| clusterOperator.metrics.service.annotations | object | `{"prometheus.io/port":"{{ .Values.clusterOperator.metrics.service.ports.http }}","prometheus.io/scrape":"true"}` | Additional annotations for the metrics Service |
| clusterOperator.metrics.service.sessionAffinity | string | `"None"` | If "ClientIP", consecutive client requests will be directed to the same Pod |
| clusterOperator.metrics.service.sessionAffinityConfig | object | `{}` | Session affinity configuration. |
| clusterOperator.metrics.serviceMonitor.enabled | bool | `false` | Create a ServiceMonitor for the metrics service. |
| clusterOperator.metrics.serviceMonitor.namespace | string | `""` | Namespace in which to create the ServiceMonitor. |
| clusterOperator.metrics.serviceMonitor.jobLabel | string | `"app.kubernetes.io/name"` | Label to use as the Prometheus job name |
| clusterOperator.metrics.serviceMonitor.honorLabels | bool | `false` | Honor metrics labels |
| clusterOperator.metrics.serviceMonitor.selector | object | `{}` | Additional selector labels for the ServiceMonitor. |
| clusterOperator.metrics.serviceMonitor.scrapeTimeout | string | `""` | Timeout for a single scrape request. |
| clusterOperator.metrics.serviceMonitor.interval | string | `""` | Scrape interval; uses the Prometheus default when empty |
| clusterOperator.metrics.serviceMonitor.metricRelabelings | list | `[]` | Metric relabeling rules |
| clusterOperator.metrics.serviceMonitor.relabelings | list | `[]` | Target relabeling rules |
| clusterOperator.metrics.serviceMonitor.labels | object | `{}` | Additional labels for the ServiceMonitor |
| clusterOperator.metrics.serviceMonitor.path | string | `""` | Path used by the ServiceMonitor to scrape metrics. |
| clusterOperator.metrics.serviceMonitor.params | object | `{}` | HTTP query parameters for scrape requests |
| clusterOperator.metrics.podMonitor.enabled | bool | `false` | Create a PodMonitor resource for scraping Cluster Operator metrics |
| clusterOperator.metrics.podMonitor.jobLabel | string | `"app.kubernetes.io/name"` | Label to use as the Prometheus job name |
| clusterOperator.metrics.podMonitor.namespace | string | `""` | Namespace in which to create the PodMonitor |
| clusterOperator.metrics.podMonitor.honorLabels | bool | `false` | Honor metrics labels |
| clusterOperator.metrics.podMonitor.selector | object | `{}` | Additional selector labels for the PodMonitor |
| clusterOperator.metrics.podMonitor.interval | string | `"30s"` | Specify the interval at which metrics should be scraped |
| clusterOperator.metrics.podMonitor.scrapeTimeout | string | `"30s"` | Specify the timeout after which the scrape is ended |
| clusterOperator.metrics.podMonitor.additionalLabels | object | `{}` | Additional labels for the PodMonitor |
| clusterOperator.metrics.podMonitor.path | string | `""` | Define HTTP path to scrape for metrics. |
| clusterOperator.metrics.podMonitor.relabelings | list | `[]` | Target relabeling rules |
| clusterOperator.metrics.podMonitor.metricRelabelings | list | `[]` | Metric relabeling rules |
| clusterOperator.metrics.podMonitor.params | object | `{}` | HTTP query parameters for scrape requests |
| msgTopologyOperator.enabled | bool | `true` | Deploy RabbitMQ Messaging Topology Operator as part of the installation |
| msgTopologyOperator.commonLabels | object | `{}` | Additional labels to add to all rendered Messaging Topology Operator resources |
| msgTopologyOperator.commonAnnotations | object | `{}` | Additional annotations to add to all rendered Messaging Topology Operator resources |
| msgTopologyOperator.clusterDomain | string | `"cluster.local"` | Kubernetes cluster domain name used by the Messaging Topology Operator webhooks |
| msgTopologyOperator.diagnosticMode | object | `{"enabled":false}` | Enable diagnostic mode in the Messaging Topology Operator deployment |
| msgTopologyOperator.diagnosticMode.enabled | bool | `false` | Enable diagnostic mode (all probes will be disabled) |
| msgTopologyOperator.image | object | `{"digest":"","pullPolicy":"IfNotPresent","pullSecrets":[],"registry":"docker.io","repository":"rabbitmqoperator/messaging-topology-operator","tag":""}` | Messaging Topology Operator image |
| msgTopologyOperator.image.registry | string | `"docker.io"` | RabbitMQ Messaging Topology Operator image registry |
| msgTopologyOperator.image.repository | string | `"rabbitmqoperator/messaging-topology-operator"` | RabbitMQ Messaging Topology Operator image repository |
| msgTopologyOperator.image.tag | string | `""` | RabbitMQ Messaging Topology Operator image tag. When empty, the subchart `.Chart.AppVersion` is used |
| msgTopologyOperator.image.digest | string | `""` | Messaging Topology Operator image digest in the form `sha256:...`; overrides `msgTopologyOperator.image.tag` when set |
| msgTopologyOperator.image.pullPolicy | string | `"IfNotPresent"` | RabbitMQ Messaging Topology Operator image pull policy |
| msgTopologyOperator.image.pullSecrets | list | `[]` | RabbitMQ Messaging Topology Operator image pull secrets |
| msgTopologyOperator.crdUpgrade | object | `{"annotations":{},"backoffLimit":1,"enabled":false,"image":{"digest":"","pullPolicy":"IfNotPresent","pullSecrets":[],"registry":"","repository":"","tag":""},"resources":{}}` | CRD upgrade hook configuration. |
| msgTopologyOperator.crdUpgrade.enabled | bool | `false` | Enable the pre-upgrade hook that reapplies CRDs with kubectl. |
| msgTopologyOperator.crdUpgrade.image | object | `{"digest":"","pullPolicy":"IfNotPresent","pullSecrets":[],"registry":"","repository":"","tag":""}` | Kubectl image used by the CRD upgrade hook. |
| msgTopologyOperator.crdUpgrade.image.registry | string | `""` | Kubectl image registry. |
| msgTopologyOperator.crdUpgrade.image.repository | string | `""` | Kubectl image repository. |
| msgTopologyOperator.crdUpgrade.image.tag | string | `""` | Kubectl image tag. |
| msgTopologyOperator.crdUpgrade.image.digest | string | `""` | Kubectl image digest in the form `sha256:...`; overrides `msgTopologyOperator.crdUpgrade.image.tag` when set. |
| msgTopologyOperator.crdUpgrade.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy for the CRD upgrade hook. |
| msgTopologyOperator.crdUpgrade.image.pullSecrets | list | `[]` | Image pull secrets for the CRD upgrade hook. |
| msgTopologyOperator.crdUpgrade.annotations | object | `{}` | Annotations added to CRD upgrade hook resources. |
| msgTopologyOperator.crdUpgrade.resources | object | `{}` | Resource requests and limits for the CRD upgrade hook job. |
| msgTopologyOperator.crdUpgrade.backoffLimit | int | `1` | Number of retries before the CRD upgrade hook job is marked as failed. |
| msgTopologyOperator.revisionHistoryLimit | int | `10` | Number of old ReplicaSets to retain |
| msgTopologyOperator.watchAllNamespaces | bool | `true` | Watch resources across all namespaces |
| msgTopologyOperator.watchNamespaces | list | `[]` | List of namespaces to watch when `msgTopologyOperator.watchAllNamespaces=false` |
| msgTopologyOperator.replicaCount | int | `1` | Number of RabbitMQ Messaging Topology Operator replicas to deploy |
| msgTopologyOperator.topologySpreadConstraints | list | `[]` | The value is evaluated as a template |
| msgTopologyOperator.schedulerName | string | `""` | Alternative scheduler |
| msgTopologyOperator.terminationGracePeriodSeconds | string | `""` | Time in seconds to allow the Messaging Topology Operator pod to terminate gracefully |
| msgTopologyOperator.hostNetwork | bool | `false` | Run the pod in the host network namespace |
| msgTopologyOperator.dnsPolicy | string | `"ClusterFirst"` | Alternative DNS policy |
| msgTopologyOperator.livenessProbe | object | `{"enabled":true,"failureThreshold":5,"initialDelaySeconds":5,"periodSeconds":30,"successThreshold":1,"timeoutSeconds":5}` | Health probes for the Messaging Topology Operator container on the dedicated health port |
| msgTopologyOperator.livenessProbe.enabled | bool | `true` | Enable livenessProbe on RabbitMQ Messaging Topology Operator nodes |
| msgTopologyOperator.livenessProbe.initialDelaySeconds | int | `5` | Initial delay seconds for livenessProbe |
| msgTopologyOperator.livenessProbe.periodSeconds | int | `30` | Period seconds for livenessProbe |
| msgTopologyOperator.livenessProbe.timeoutSeconds | int | `5` | Timeout seconds for livenessProbe |
| msgTopologyOperator.livenessProbe.successThreshold | int | `1` | Success threshold for livenessProbe |
| msgTopologyOperator.livenessProbe.failureThreshold | int | `5` | Failure threshold for livenessProbe |
| msgTopologyOperator.readinessProbe.enabled | bool | `true` | Enable readinessProbe on RabbitMQ Messaging Topology Operator nodes |
| msgTopologyOperator.readinessProbe.initialDelaySeconds | int | `5` | Initial delay seconds for readinessProbe |
| msgTopologyOperator.readinessProbe.periodSeconds | int | `30` | Period seconds for readinessProbe |
| msgTopologyOperator.readinessProbe.timeoutSeconds | int | `5` | Timeout seconds for readinessProbe |
| msgTopologyOperator.readinessProbe.successThreshold | int | `1` | Success threshold for readinessProbe |
| msgTopologyOperator.readinessProbe.failureThreshold | int | `5` | Failure threshold for readinessProbe |
| msgTopologyOperator.startupProbe.enabled | bool | `false` | Enable startupProbe on RabbitMQ Messaging Topology Operator nodes |
| msgTopologyOperator.startupProbe.initialDelaySeconds | int | `5` | Initial delay seconds for startupProbe |
| msgTopologyOperator.startupProbe.periodSeconds | int | `30` | Period seconds for startupProbe |
| msgTopologyOperator.startupProbe.timeoutSeconds | int | `5` | Timeout seconds for startupProbe |
| msgTopologyOperator.startupProbe.successThreshold | int | `1` | Success threshold for startupProbe |
| msgTopologyOperator.startupProbe.failureThreshold | int | `5` | Failure threshold for startupProbe |
| msgTopologyOperator.customLivenessProbe | object | `{}` | Custom livenessProbe that overrides the default one |
| msgTopologyOperator.customReadinessProbe | object | `{}` | Custom readinessProbe that overrides the default one |
| msgTopologyOperator.customStartupProbe | object | `{}` | Custom startupProbe that overrides the default one |
| msgTopologyOperator.skipCreateAdmissionWebhookConfig | bool | `false` | Skip creation of the ValidatingWebhookConfiguration |
| msgTopologyOperator.existingWebhookCertSecret | string | `""` | Name of an existing secret containing the webhook certificates |
| msgTopologyOperator.existingWebhookCertCABundle | string | `""` | PEM-encoded CA Bundle of the existing secret provided in existingWebhookCertSecret (only if useCertManager=false) |
| msgTopologyOperator.useCertManager | bool | `false` | Deploy cert-manager objects (Issuer and Certificate) for the Messaging Topology Operator webhooks |
| msgTopologyOperator.resources | object | `{}` | Container resource requests and limits. |
| msgTopologyOperator.pdb | object | `{"create":true,"maxUnavailable":"","minAvailable":""}` | PodDisruptionBudget settings for the Messaging Topology Operator |
| msgTopologyOperator.pdb.create | bool | `true` | Enable a Pod Disruption Budget creation |
| msgTopologyOperator.pdb.minAvailable | string | `""` | Minimum number/percentage of pods that should remain scheduled |
| msgTopologyOperator.pdb.maxUnavailable | string | `""` | Maximum number/percentage of pods that may be made unavailable |
| msgTopologyOperator.podSecurityContext | object | `{"enabled":true,"fsGroup":1001,"fsGroupChangePolicy":"Always","supplementalGroups":[],"sysctls":[]}` | Pod security context for the Messaging Topology Operator pod |
| msgTopologyOperator.podSecurityContext.enabled | bool | `true` | Enable the pod security context for the Messaging Topology Operator |
| msgTopologyOperator.podSecurityContext.fsGroupChangePolicy | string | `"Always"` | Set filesystem group change policy |
| msgTopologyOperator.podSecurityContext.sysctls | list | `[]` | Set kernel settings using the sysctl interface |
| msgTopologyOperator.podSecurityContext.supplementalGroups | list | `[]` | Set filesystem extra groups |
| msgTopologyOperator.podSecurityContext.fsGroup | int | `1001` | Set RabbitMQ Messaging Topology Operator pod's Security Context fsGroup |
| msgTopologyOperator.containerSecurityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"enabled":true,"privileged":false,"readOnlyRootFilesystem":true,"runAsGroup":1001,"runAsNonRoot":true,"runAsUser":1001,"seLinuxOptions":{},"seccompProfile":{"type":"RuntimeDefault"}}` | Container security context for the Messaging Topology Operator container |
| msgTopologyOperator.containerSecurityContext.enabled | bool | `true` | Enable the container security context for the Messaging Topology Operator |
| msgTopologyOperator.containerSecurityContext.seLinuxOptions | object | `{}` | Set SELinux options in container |
| msgTopologyOperator.containerSecurityContext.runAsUser | int | `1001` | Set containers' Security Context runAsUser |
| msgTopologyOperator.containerSecurityContext.runAsGroup | int | `1001` | Set containers' Security Context runAsGroup |
| msgTopologyOperator.containerSecurityContext.runAsNonRoot | bool | `true` | Set container's Security Context runAsNonRoot |
| msgTopologyOperator.containerSecurityContext.privileged | bool | `false` | Set container's Security Context privileged |
| msgTopologyOperator.containerSecurityContext.readOnlyRootFilesystem | bool | `true` | Set container's Security Context readOnlyRootFilesystem |
| msgTopologyOperator.containerSecurityContext.allowPrivilegeEscalation | bool | `false` | Set container's Security Context allowPrivilegeEscalation |
| msgTopologyOperator.containerSecurityContext.capabilities.drop | list | `["ALL"]` | List of capabilities to be dropped |
| msgTopologyOperator.containerSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` | Set container's Security Context seccomp profile |
| msgTopologyOperator.fullnameOverride | string | `""` | String to fully override the generated Messaging Topology Operator fullname |
| msgTopologyOperator.command | list | `[]` | Override the default container command |
| msgTopologyOperator.args | list | `[]` | Override the default container arguments |
| msgTopologyOperator.automountServiceAccountToken | bool | `true` | Mount the service account token into the pod |
| msgTopologyOperator.hostAliases | list | `[]` | https://kubernetes.io/docs/concepts/services-networking/add-entries-to-pod-etc-hosts-with-host-aliases/ |
| msgTopologyOperator.podLabels | object | `{}` | Additional labels for Messaging Topology Operator pods |
| msgTopologyOperator.podAnnotations | object | `{}` | Additional annotations for Messaging Topology Operator pods |
| msgTopologyOperator.affinity | object | `{}` | Affinity rules for Messaging Topology Operator pods |
| msgTopologyOperator.nodeSelector | object | `{}` | Node selector for Messaging Topology Operator pods |
| msgTopologyOperator.tolerations | list | `[]` | Tolerations for Messaging Topology Operator pods |
| msgTopologyOperator.updateStrategy | object | `{"type":"RollingUpdate"}` | Deployment update strategy for the Messaging Topology Operator |
| msgTopologyOperator.updateStrategy.type | string | `"RollingUpdate"` | Can be set to RollingUpdate or OnDelete |
| msgTopologyOperator.priorityClassName | string | `""` | PriorityClass name for Messaging Topology Operator pods |
| msgTopologyOperator.lifecycleHooks | object | `{}` | Lifecycle hooks for the Messaging Topology Operator container |
| msgTopologyOperator.containerPorts | object | `{"health":8081,"metrics":8443}` | Container ports exposed by the Messaging Topology Operator |
| msgTopologyOperator.containerPorts.metrics | int | `8443` | HTTPS metrics port exposed by the Messaging Topology Operator |
| msgTopologyOperator.containerPorts.health | int | `8081` | HTTP health probe port exposed by the Messaging Topology Operator |
| msgTopologyOperator.extraEnvVars | list | `[]` | Additional environment variables for the container. |
| msgTopologyOperator.extraEnvVarsCM | string | `""` | Name of an existing ConfigMap with extra environment variables for the Messaging Topology Operator |
| msgTopologyOperator.extraEnvVarsSecret | string | `""` | Name of an existing Secret with extra environment variables for the Messaging Topology Operator |
| msgTopologyOperator.extraVolumes | list | `[]` | Additional volumes for Messaging Topology Operator pods |
| msgTopologyOperator.extraVolumeMounts | list | `[]` | Additional volume mounts for the Messaging Topology Operator container |
| msgTopologyOperator.sidecars | list | `[]` | Additional sidecar containers for the pod. |
| msgTopologyOperator.initContainers | list | `[]` | Additional init containers for the pod. |
| msgTopologyOperator.service | object | `{"annotations":{},"clusterIP":"","externalTrafficPolicy":"Cluster","extraPorts":[],"loadBalancerIP":"","loadBalancerSourceRanges":[],"nodePorts":{"http":""},"ports":{"webhook":443},"sessionAffinity":"None","sessionAffinityConfig":{},"type":"ClusterIP"}` | Webhook Service settings |
| msgTopologyOperator.service.type | string | `"ClusterIP"` | Kubernetes Service type for the webhook service |
| msgTopologyOperator.service.ports | object | `{"webhook":443}` | Service port for the webhook endpoint |
| msgTopologyOperator.service.nodePorts | object | `{"http":""}` | Node ports to expose. |
| msgTopologyOperator.service.clusterIP | string | `""` | ClusterIP for the webhook service. |
| msgTopologyOperator.service.loadBalancerIP | string | `""` | LoadBalancer IP for the webhook Service |
| msgTopologyOperator.service.extraPorts | list | `[]` | Additional ports to expose on the webhook Service |
| msgTopologyOperator.service.loadBalancerSourceRanges | list | `[]` | Allowed source ranges for the webhook service load balancer. |
| msgTopologyOperator.service.externalTrafficPolicy | string | `"Cluster"` | External traffic policy for the webhook service. |
| msgTopologyOperator.service.annotations | object | `{}` | Additional annotations for the webhook Service |
| msgTopologyOperator.service.sessionAffinity | string | `"None"` | If "ClientIP", consecutive client requests will be directed to the same Pod |
| msgTopologyOperator.service.sessionAffinityConfig | object | `{}` | Session affinity configuration. |
| msgTopologyOperator.networkPolicy | object | `{"allowExternal":true,"allowExternalEgress":true,"enabled":true,"extraEgress":[],"extraIngress":[],"ingressNSMatchLabels":{},"ingressNSPodMatchLabels":{},"kubeAPIServerPorts":[443,6443,8443]}` | NetworkPolicy settings for the Messaging Topology Operator |
| msgTopologyOperator.networkPolicy.enabled | bool | `true` | Create a NetworkPolicy for the Messaging Topology Operator |
| msgTopologyOperator.networkPolicy.kubeAPIServerPorts | list | `[443,6443,8443]` | List of Kubernetes API server ports to allow |
| msgTopologyOperator.networkPolicy.allowExternal | bool | `true` | When set to false, ingress is limited to explicitly allowed sources. |
| msgTopologyOperator.networkPolicy.allowExternalEgress | bool | `true` | Allow unrestricted egress traffic |
| msgTopologyOperator.networkPolicy.extraIngress | list | `[]` | - frontend |
| msgTopologyOperator.networkPolicy.extraEgress | list | `[]` | - frontend |
| msgTopologyOperator.networkPolicy.ingressNSMatchLabels | object | `{}` | Pod labels to match to allow traffic from other namespaces |
| msgTopologyOperator.rbac | object | `{"clusterRole":{"customRules":[],"extraRules":[]},"create":true}` | RBAC configuration |
| msgTopologyOperator.rbac.create | bool | `true` | Specifies whether RBAC resources should be created |
| msgTopologyOperator.rbac.clusterRole | object | `{"customRules":[],"extraRules":[]}` | ClusterRole configuration. |
| msgTopologyOperator.rbac.clusterRole.customRules | list | `[]` | Custom access rules for the ClusterRole. |
| msgTopologyOperator.rbac.clusterRole.extraRules | list | `[]` | Extra access rules appended to the default ClusterRole. |
| msgTopologyOperator.serviceAccount | object | `{"annotations":{},"automountServiceAccountToken":false,"create":true,"name":""}` | ServiceAccount configuration |
| msgTopologyOperator.serviceAccount.create | bool | `true` | Specifies whether a ServiceAccount should be created |
| msgTopologyOperator.serviceAccount.name | string | `""` | If not set and create is true, a name is generated using the rabbitmq-cluster-operator.fullname template |
| msgTopologyOperator.serviceAccount.annotations | object | `{}` | Add annotations |
| msgTopologyOperator.serviceAccount.automountServiceAccountToken | bool | `false` | Mount API credentials into the service account. |
| msgTopologyOperator.metrics | object | `{"podMonitor":{"additionalLabels":{},"enabled":false,"honorLabels":false,"interval":"30s","jobLabel":"app.kubernetes.io/name","metricRelabelings":[],"namespace":"","relabelings":[],"scheme":"https","scrapeTimeout":"30s","selector":{},"tlsConfig":{}},"service":{"annotations":{"prometheus.io/port":"{{ .Values.msgTopologyOperator.metrics.service.ports.http }}","prometheus.io/scheme":"https","prometheus.io/scrape":"true"},"clusterIP":"","enabled":false,"externalTrafficPolicy":"Cluster","extraPorts":[],"loadBalancerIP":"","loadBalancerSourceRanges":[],"nodePorts":{"http":""},"ports":{"http":80},"sessionAffinity":"None","sessionAffinityConfig":{},"type":"ClusterIP"},"serviceMonitor":{"enabled":false,"honorLabels":false,"interval":"","jobLabel":"app.kubernetes.io/name","labels":{},"metricRelabelings":[],"namespace":"","relabelings":[],"scheme":"https","scrapeTimeout":"","selector":{},"tlsConfig":{}}}` | Metrics configuration. |
| msgTopologyOperator.metrics.service | object | `{"annotations":{"prometheus.io/port":"{{ .Values.msgTopologyOperator.metrics.service.ports.http }}","prometheus.io/scheme":"https","prometheus.io/scrape":"true"},"clusterIP":"","enabled":false,"externalTrafficPolicy":"Cluster","extraPorts":[],"loadBalancerIP":"","loadBalancerSourceRanges":[],"nodePorts":{"http":""},"ports":{"http":80},"sessionAffinity":"None","sessionAffinityConfig":{},"type":"ClusterIP"}` | Metrics service configuration. |
| msgTopologyOperator.metrics.service.enabled | bool | `false` | Create a Service for the Messaging Topology Operator metrics endpoint |
| msgTopologyOperator.metrics.service.type | string | `"ClusterIP"` | Kubernetes Service type for the Messaging Topology Operator metrics endpoint |
| msgTopologyOperator.metrics.service.ports | object | `{"http":80}` | Service port for the Messaging Topology Operator metrics endpoint |
| msgTopologyOperator.metrics.service.nodePorts | object | `{"http":""}` | Node ports to expose. |
| msgTopologyOperator.metrics.service.clusterIP | string | `""` | ClusterIP for the metrics service. |
| msgTopologyOperator.metrics.service.extraPorts | list | `[]` | Additional ports to expose on the metrics Service |
| msgTopologyOperator.metrics.service.loadBalancerIP | string | `""` | LoadBalancer IP for the Messaging Topology Operator metrics service |
| msgTopologyOperator.metrics.service.loadBalancerSourceRanges | list | `[]` | Allowed source ranges for the metrics service load balancer. |
| msgTopologyOperator.metrics.service.externalTrafficPolicy | string | `"Cluster"` | External traffic policy for the metrics service. |
| msgTopologyOperator.metrics.service.annotations | object | `{"prometheus.io/port":"{{ .Values.msgTopologyOperator.metrics.service.ports.http }}","prometheus.io/scheme":"https","prometheus.io/scrape":"true"}` | Additional annotations for the Messaging Topology Operator metrics service |
| msgTopologyOperator.metrics.service.sessionAffinity | string | `"None"` | If "ClientIP", consecutive client requests will be directed to the same Pod |
| msgTopologyOperator.metrics.service.sessionAffinityConfig | object | `{}` | Session affinity configuration. |
| msgTopologyOperator.metrics.serviceMonitor.enabled | bool | `false` | Create a ServiceMonitor for the metrics service. |
| msgTopologyOperator.metrics.serviceMonitor.namespace | string | `""` | Namespace in which to create the ServiceMonitor. |
| msgTopologyOperator.metrics.serviceMonitor.jobLabel | string | `"app.kubernetes.io/name"` | Label to use as the Prometheus job name |
| msgTopologyOperator.metrics.serviceMonitor.honorLabels | bool | `false` | Honor metrics labels |
| msgTopologyOperator.metrics.serviceMonitor.scrapeTimeout | string | `""` | Timeout for a single scrape request. |
| msgTopologyOperator.metrics.serviceMonitor.interval | string | `""` | Scrape interval; uses the Prometheus default when empty |
| msgTopologyOperator.metrics.serviceMonitor.metricRelabelings | list | `[]` | Metric relabeling rules |
| msgTopologyOperator.metrics.serviceMonitor.relabelings | list | `[]` | Target relabeling rules |
| msgTopologyOperator.metrics.serviceMonitor.scheme | string | `"https"` | Scheme used when scraping the metrics endpoint |
| msgTopologyOperator.metrics.serviceMonitor.tlsConfig | object | `{}` | Optional TLS configuration for the ServiceMonitor endpoint |
| msgTopologyOperator.metrics.serviceMonitor.labels | object | `{}` | Additional labels for the ServiceMonitor |
| msgTopologyOperator.metrics.podMonitor.enabled | bool | `false` | Create a PodMonitor resource for scraping Messaging Topology Operator metrics |
| msgTopologyOperator.metrics.podMonitor.jobLabel | string | `"app.kubernetes.io/name"` | Label to use as the Prometheus job name |
| msgTopologyOperator.metrics.podMonitor.namespace | string | `""` | Namespace in which to create the PodMonitor |
| msgTopologyOperator.metrics.podMonitor.honorLabels | bool | `false` | Honor metrics labels |
| msgTopologyOperator.metrics.podMonitor.selector | object | `{}` | Additional selector labels for the PodMonitor |
| msgTopologyOperator.metrics.podMonitor.interval | string | `"30s"` | Specify the interval at which metrics should be scraped |
| msgTopologyOperator.metrics.podMonitor.scrapeTimeout | string | `"30s"` | Specify the timeout after which the scrape is ended |
| msgTopologyOperator.metrics.podMonitor.additionalLabels | object | `{}` | Additional labels for the PodMonitor |
| msgTopologyOperator.metrics.podMonitor.relabelings | list | `[]` | Target relabeling rules |
| msgTopologyOperator.metrics.podMonitor.metricRelabelings | list | `[]` | Metric relabeling rules |
| msgTopologyOperator.metrics.podMonitor.scheme | string | `"https"` | Scheme used when scraping the pod metrics endpoint |
| msgTopologyOperator.metrics.podMonitor.tlsConfig | object | `{}` | Optional TLS configuration for the PodMonitor endpoint |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
