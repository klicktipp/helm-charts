# powerdns-recursor

![Version: 0.4.0](https://img.shields.io/badge/Version-0.4.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 5.4.0](https://img.shields.io/badge/AppVersion-5.4.0-informational?style=flat-square)

Helm chart for deploying PowerDNS Recursor on Kubernetes

**Homepage:** <https://github.com/klicktipp/helm-charts>

## Source Code

* <https://github.com/PowerDNS/pdns>
* <https://www.powerdns.com>
* <https://www.powerdns.com/powerdns-recursor>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` | Number of pod replicas. Ignored in DaemonSet mode. |
| revisionHistoryLimit | int | `10` | Number of old ReplicaSets to retain. Used by both Deployment and DaemonSet histories. |
| workload | object | `{"daemonSet":{"minReadySeconds":5,"updateStrategy":{"rollingUpdate":{"maxSurge":"","maxUnavailable":0},"type":"RollingUpdate"}},"type":"Deployment"}` | Workload configuration. |
| workload.type | string | `"Deployment"` | Workload kind. Supported values: Deployment, DaemonSet. |
| workload.daemonSet.updateStrategy | object | `{"rollingUpdate":{"maxSurge":"","maxUnavailable":0},"type":"RollingUpdate"}` | DaemonSet-only settings. Ignored when workload.type=Deployment. |
| workload.daemonSet.updateStrategy.type | string | `"RollingUpdate"` | DaemonSet update strategy type. |
| workload.daemonSet.updateStrategy.rollingUpdate.maxUnavailable | int | `0` | Keep the existing pod on a node until a surged replacement is ready. Defaults to 0, or 1 when transparentDNS.enabled=true. Set explicitly to override the dynamic default. |
| workload.daemonSet.updateStrategy.rollingUpdate.maxSurge | string | `""` | Allow one extra pod per node during rolling updates to avoid local DNS gaps. Defaults to 1, or 0 when transparentDNS.enabled=true. Set explicitly to override the dynamic default. |
| workload.daemonSet.minReadySeconds | int | `5` | Time a new DaemonSet pod must stay ready before it is considered available. |
| transparentDNS | object | `{"captureOutput":true,"clusterDNS":{"namespace":"kube-system","selector":{"k8s-app":"kube-dns"},"serviceIP":"","upstreamService":{"annotations":{},"clusterIP":"","create":true,"name":""}},"clusterDomain":"cluster.local","customClusterDNSIP":"","enabled":false,"interceptor":{"enableRuntimeInstall":true,"image":{"pullPolicy":"IfNotPresent","repository":"alpine","tag":"3.23"},"installPackagesCommand":"apk add --no-cache iptables iproute2"},"resources":{"limits":{"memory":"128Mi"},"requests":{"cpu":"25m","memory":"128Mi"}},"securityContext":{"capabilities":{"add":["NET_ADMIN"]},"runAsGroup":0,"runAsUser":0},"setupIptables":true,"tolerations":[{"key":"CriticalAddonsOnly","operator":"Exists"},{"effect":"NoExecute","operator":"Exists"},{"effect":"NoSchedule","operator":"Exists"}]}` | Optional transparent DNS takeover mode. Experimental. Redirects pod traffic for the existing cluster DNS Service IP to the local Recursor without changing pod DNS settings. |
| transparentDNS.enabled | bool | `false` | Enable transparent interception of pod DNS traffic via the kube-dns/CoreDNS Service IP. Experimental. Requires workload.type=DaemonSet. This mode defaults workload.daemonSet.updateStrategy.rollingUpdate.maxSurge to 0; any explicit non-zero value will fail validation. |
| transparentDNS.clusterDomain | string | `"cluster.local"` | Cluster DNS domain still forwarded to CoreDNS. Required when transparentDNS.enabled=true. |
| transparentDNS.clusterDNS.namespace | string | `"kube-system"` | Namespace where the cluster DNS pods live. Required when transparentDNS.enabled=true. |
| transparentDNS.clusterDNS.serviceIP | string | `""` | ClusterIP of the kube-dns/CoreDNS Service that pods already use today. Required when transparentDNS.enabled=true. |
| transparentDNS.clusterDNS.upstreamService.create | bool | `true` | Create an auxiliary Service with its own fixed ClusterIP in front of the CoreDNS pods to avoid recursion through the intercepted clusterDNS.serviceIP. |
| transparentDNS.clusterDNS.upstreamService.name | string | `""` | Override the generated upstream Service name. |
| transparentDNS.clusterDNS.upstreamService.clusterIP | string | `""` | Fixed ClusterIP of the auxiliary CoreDNS upstream Service. Required when transparentDNS.enabled=true, customClusterDNSIP is empty, and upstreamService.create=true. |
| transparentDNS.clusterDNS.upstreamService.annotations | object | `{}` | Service annotations for the auxiliary CoreDNS upstream Service. |
| transparentDNS.clusterDNS.selector | object | `{"k8s-app":"kube-dns"}` | Pod selector for the auxiliary CoreDNS upstream Service. Required when transparentDNS.enabled=true, customClusterDNSIP is empty, and upstreamService.create=true. |
| transparentDNS.customClusterDNSIP | string | `""` | Use a pre-existing auxiliary CoreDNS upstream Service IP instead of creating one. Required when transparentDNS.enabled=true and upstreamService.create=false. |
| transparentDNS.interceptor.image.repository | string | `"alpine"` | Helper image used to add the local IP and program iptables. Provide an image that already contains `ip` and `iptables` to avoid runtime package installation. |
| transparentDNS.interceptor.image.tag | string | `"3.23"` | Image tag of the interceptor helper image. |
| transparentDNS.interceptor.image.pullPolicy | string | `"IfNotPresent"` | Pull policy for the interceptor helper image. |
| transparentDNS.interceptor.enableRuntimeInstall | bool | `true` | Enable runtime package installation before adding IPs and iptables rules. Disable this when the interceptor image already contains the required tooling. |
| transparentDNS.interceptor.installPackagesCommand | string | `"apk add --no-cache iptables iproute2"` | Package installation command executed before adding IPs and iptables rules. Ignored when interceptor.enableRuntimeInstall=false. |
| transparentDNS.setupIptables | bool | `true` | Configure iptables rules that transparently capture pod DNS traffic to clusterDNS.serviceIP. |
| transparentDNS.captureOutput | bool | `true` | Also capture node-local processes hitting the cluster DNS Service IP via the OUTPUT chain. |
| transparentDNS.securityContext.runAsUser | int | `0` | Run the interceptor as root so it can manipulate networking. |
| transparentDNS.securityContext.runAsGroup | int | `0` | Run the interceptor with the root group. |
| transparentDNS.tolerations | list | `[{"key":"CriticalAddonsOnly","operator":"Exists"},{"effect":"NoExecute","operator":"Exists"},{"effect":"NoSchedule","operator":"Exists"}]` | Default tolerations used only when transparentDNS.enabled=true and tolerations is empty. |
| imagePullSecrets | list | `[]` | Image pull secrets. |
| nameOverride | string | `""` | Partially override generated resource names. |
| fullnameOverride | string | `""` | Fully override generated resource names. |
| serviceAccount | object | `{"annotations":{},"automountServiceAccountToken":false,"create":true,"name":""}` | ServiceAccount configuration. |
| serviceAccount.create | bool | `true` | Create a dedicated ServiceAccount. |
| serviceAccount.annotations | object | `{}` | ServiceAccount annotations. |
| serviceAccount.name | string | `""` | Explicit ServiceAccount name. If empty, a name is generated. |
| serviceAccount.automountServiceAccountToken | bool | `false` | Mount API token into pods. |
| podAnnotations | object | `{}` | Extra annotations added to the pod template. |
| podLabels | object | `{}` | Extra labels added to the pod template. |
| podSecurityContext | object | `{"runAsGroup":953,"runAsUser":953}` | Pod-level security context. |
| podSecurityContext.runAsUser | int | `953` | Unix user id. |
| podSecurityContext.runAsGroup | int | `953` | Unix group id. |
| securityContext | object | `{"runAsGroup":953,"runAsUser":953}` | Container-level security context. |
| securityContext.runAsUser | int | `953` | Unix user id. |
| securityContext.runAsGroup | int | `953` | Unix group id. |
| priorityClassName | string | `""` | Optional priority class for pods. When transparentDNS.enabled=true and this value is empty, the chart defaults to "system-node-critical". |
| podAntiAffinity | object | `{"topologyKey":"kubernetes.io/hostname","type":"soft"}` | Pod anti-affinity shortcut (used when affinity is empty). |
| podAntiAffinity.type | string | `"soft"` | "soft", "hard" or "disabled". Ignored in DaemonSet mode. |
| podAntiAffinity.topologyKey | string | `"kubernetes.io/hostname"` | Topology key used by anti-affinity. |
| affinity | object | `{}` | Native affinity rules. If set, this overrides podAntiAffinity. |
| nodeSelector | object | `{}` | Node selector for scheduling. |
| tolerations | list | `[]` | Tolerations for scheduling. |
| podDisruptionBudget | object | `{}` | PodDisruptionBudget spec snippet. Example: { maxUnavailable: 1 }. Ignored in DaemonSet mode. |
| service | object | `{"annotations":{},"clusterIP":"","headless":{"annotations":{},"enabled":false,"includeDnsPorts":true,"publishNotReadyAddresses":false},"internalTrafficPolicy":"","loadBalancerIP":"","loadBalancerSourceRanges":[],"port":53,"type":"ClusterIP"}` | Service configuration. |
| service.type | string | `"ClusterIP"` | Service type. |
| service.clusterIP | string | `""` | Optional fixed ClusterIP for the primary Service. |
| service.internalTrafficPolicy | string | `""` | Service internal traffic policy. When empty, DaemonSet mode defaults to "Local". |
| service.port | int | `53` | DNS service port (TCP/UDP). |
| service.annotations | object | `{}` | Service annotations. |
| service.loadBalancerIP | string | `""` | Optional fixed LoadBalancer IP. |
| service.loadBalancerSourceRanges | list | `[]` | Optional source ranges for LoadBalancer services. |
| service.headless | object | `{"annotations":{},"enabled":false,"includeDnsPorts":true,"publishNotReadyAddresses":false}` | Optional headless Service for direct pod DNS records. |
| service.headless.enabled | bool | `false` | Enable creation of an additional headless Service (<fullname>-headless). |
| service.headless.annotations | object | `{}` | Headless Service annotations. |
| service.headless.includeDnsPorts | bool | `true` | Include DNS TCP/UDP ports on the headless Service. |
| service.headless.publishNotReadyAddresses | bool | `false` | Publish endpoints even for not-ready pods. |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"chart-example.local","paths":[{"path":"/","pathType":"Prefix"}]}],"tls":[]}` | Ingress for the PowerDNS API endpoint (requires pdns.api.enabled=true). |
| ingress.enabled | bool | `false` | Enable ingress. |
| ingress.className | string | `""` | ingressClassName value. |
| ingress.annotations | object | `{}` | Ingress annotations. |
| ingress.hosts | list | `[{"host":"chart-example.local","paths":[{"path":"/","pathType":"Prefix"}]}]` | Host/path rules. |
| ingress.tls | list | `[]` | TLS sections. |
| podMonitor | object | `{"additionalLabels":{},"enabled":false,"interval":"60s","jobLabel":"","path":"","relabelings":[],"scheme":"","scrapeTimeout":""}` | PodMonitor configuration. Backward compatible: can also be boolean. |
| podMonitor.enabled | bool | `false` | Enable PodMonitor creation. |
| podMonitor.additionalLabels | object | `{}` | Extra labels for PodMonitor metadata. |
| podMonitor.interval | string | `"60s"` | Scrape interval. |
| podMonitor.scrapeTimeout | string | `""` | Optional scrape timeout. |
| podMonitor.path | string | `""` | Optional metrics path. |
| podMonitor.scheme | string | `""` | Optional scheme. |
| podMonitor.jobLabel | string | `""` | Optional job label override. |
| podMonitor.relabelings | list | `[]` | Optional custom relabelings. |
| prometheusRule | object | `{"additionalGroups":[],"additionalLabels":{},"annotations":{},"enabled":false,"securityStatus":{"enabled":true,"for":"15m"}}` | PrometheusRule configuration. |
| prometheusRule.enabled | bool | `false` | Enable PrometheusRule creation. |
| prometheusRule.additionalLabels | object | `{}` | Extra labels for PrometheusRule metadata. |
| prometheusRule.annotations | object | `{}` | Extra annotations for PrometheusRule metadata. |
| prometheusRule.securityStatus.enabled | bool | `true` | Enable alerting for pdns_recursor_security_status. |
| prometheusRule.securityStatus.for | string | `"15m"` | Time the condition must hold before firing. |
| prometheusRule.additionalGroups | list | `[]` | Additional PrometheusRule groups appended to the generated spec. |
| extraObjects | list | `[]` | Additional arbitrary manifests appended to the release. |
| image | object | `{"imagePullPolicy":"","pullPolicy":"IfNotPresent","registry":"","repository":"powerdns/pdns-recursor-54","tag":""}` | Container image configuration. |
| image.registry | string | `""` | Optional image registry prefix. |
| image.repository | string | `"powerdns/pdns-recursor-54"` | Image repository. |
| image.tag | string | `""` | Image tag. If empty, chart appVersion is used. |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy (preferred key). |
| image.imagePullPolicy | string | `""` | Deprecated compatibility key. Leave empty to use image.pullPolicy. |
| resources | object | `{}` | Resource requests and limits. |
| probes | object | `{"liveness":{"failureThreshold":3,"initialDelaySeconds":5,"periodSeconds":5,"timeoutSeconds":3},"readiness":{"failureThreshold":3,"initialDelaySeconds":5,"periodSeconds":5,"timeoutSeconds":3}}` | Probe configuration. |
| probes.liveness | object | `{"failureThreshold":3,"initialDelaySeconds":5,"periodSeconds":5,"timeoutSeconds":3}` | Liveness probe settings. |
| probes.liveness.initialDelaySeconds | int | `5` | Initial delay before probing. |
| probes.liveness.periodSeconds | int | `5` | Probe period. |
| probes.liveness.timeoutSeconds | int | `3` | Probe timeout. |
| probes.liveness.failureThreshold | int | `3` | Failure threshold. |
| probes.readiness | object | `{"failureThreshold":3,"initialDelaySeconds":5,"periodSeconds":5,"timeoutSeconds":3}` | Readiness probe settings. |
| probes.readiness.initialDelaySeconds | int | `5` | Initial delay before probing. |
| probes.readiness.periodSeconds | int | `5` | Probe period. |
| probes.readiness.timeoutSeconds | int | `3` | Probe timeout. |
| probes.readiness.failureThreshold | int | `3` | Failure threshold. |
| pdns | object | `{"api":{"enabled":false,"port":8082},"config":{"dnssec":{"validation":"process"},"incoming":{"listen":["0.0.0.0"],"port":5353},"logging":{"loglevel":6,"quiet":true},"outgoing":{"source_address":["0.0.0.0"]},"recordcache":{"refresh_on_ttl_perc":10},"recursor":{"config_dir":"/etc/powerdns","setgid":"pdns","setuid":"pdns","socket_mode":"660"},"webservice":{"webserver":false}},"lua":{"enabled":false,"script":"zoneToCache(\".\", \"url\", \"https://www.internic.net/domain/root.zone\", { refreshPeriod = 86400 })\n"},"metrics":{"enabled":false},"port":5353}` | PowerDNS recursor runtime configuration. |
| pdns.port | int | `5353` | Container DNS port. |
| pdns.api | object | `{"enabled":false,"port":8082}` | API endpoint settings. |
| pdns.api.enabled | bool | `false` | Expose API port through the Service and container. |
| pdns.api.port | int | `8082` | API TCP port. |
| pdns.lua | object | `{"enabled":false,"script":"zoneToCache(\".\", \"url\", \"https://www.internic.net/domain/root.zone\", { refreshPeriod = 86400 })\n"}` | Optional Lua config file support. |
| pdns.lua.enabled | bool | `false` | Create additional Lua ConfigMap and mount recursor.lua. |
| pdns.lua.script | string | `"zoneToCache(\".\", \"url\", \"https://www.internic.net/domain/root.zone\", { refreshPeriod = 86400 })\n"` | Lua script content written to /etc/powerdns/recursor.lua. |
| pdns.config | object | `{"dnssec":{"validation":"process"},"incoming":{"listen":["0.0.0.0"],"port":5353},"logging":{"loglevel":6,"quiet":true},"outgoing":{"source_address":["0.0.0.0"]},"recordcache":{"refresh_on_ttl_perc":10},"recursor":{"config_dir":"/etc/powerdns","setgid":"pdns","setuid":"pdns","socket_mode":"660"},"webservice":{"webserver":false}}` | Rendered directly into recursor.yml. |
| pdns.config.recordcache.refresh_on_ttl_perc | int | `10` | Refresh cache entries shortly before TTL expiry to reduce miss spikes. |
| pdns.metrics | object | `{"enabled":false}` | Legacy compatibility block. |
