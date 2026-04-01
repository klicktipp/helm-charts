# powerdns-recursor

![Version: 0.4.3](https://img.shields.io/badge/Version-0.4.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 5.4.0](https://img.shields.io/badge/AppVersion-5.4.0-informational?style=flat-square)

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
| workload.daemonSet.updateStrategy.rollingUpdate.maxUnavailable | int | `0` | Keep the existing pod on a node until a surged replacement is ready. Defaults to 0. When transparentDNS.enabled=true, a configured value of 0 (including the default) is treated as 1 to keep the DaemonSet strategy valid; other explicit non-zero values are preserved. |
| workload.daemonSet.updateStrategy.rollingUpdate.maxSurge | string | `""` | Allow one extra pod per node during rolling updates to avoid local DNS gaps. Defaults to 1. When transparentDNS.enabled=true, the empty/default value becomes 0 and any explicit non-zero value will fail validation. |
| workload.daemonSet.minReadySeconds | int | `5` | Time a new DaemonSet pod must stay ready before it is considered available. |
| transparentDNS | object | `{"captureOutput":true,"clusterDNS":{"namespace":"kube-system","selector":{"k8s-app":"kube-dns"},"serviceIP":"","upstreamService":{"annotations":{},"clusterIP":"","create":true,"name":""}},"clusterDomain":"cluster.local","customClusterDNSIP":"","enabled":false,"interceptor":{"image":{"pullPolicy":"IfNotPresent","repository":"ghcr.io/klicktipp/pdns-transparent-dns","tag":"0.1.2"}},"localIP":"169.254.20.10","resources":{"limits":{"memory":"128Mi"},"requests":{"cpu":"25m","memory":"128Mi"}},"securityContext":{"capabilities":{"add":["NET_ADMIN"]},"runAsGroup":0,"runAsUser":0},"setupIptables":true,"takeoverClusterIP":true,"tolerations":[{"key":"CriticalAddonsOnly","operator":"Exists"},{"effect":"NoExecute","operator":"Exists"},{"effect":"NoSchedule","operator":"Exists"}]}` | Optional transparent DNS takeover mode. Experimental. Binds a dedicated node-local DNS IP on each node and can optionally also take over the existing cluster DNS Service IP. |
| transparentDNS.enabled | bool | `false` | Enable node-local DNS takeover mode. Experimental. Requires workload.type=DaemonSet. This mode defaults workload.daemonSet.updateStrategy.rollingUpdate.maxSurge to 0; any explicit non-zero value will fail validation. The chart always binds transparentDNS.localIP on each node, runs PowerDNS on port 53, and programs NOTRACK/ACCEPT rules. It can additionally try to take over transparentDNS.clusterDNS.serviceIP when transparentDNS.takeoverClusterIP=true. If service.enabled=true and service.clusterIP is set, that primary Service IP is also added as a listen/bind address. If service.local.enabled=true and service.local.clusterIP is set, that local-only Service IP is added as an additional listen/bind address. |
| transparentDNS.localIP | string | `"169.254.20.10"` | Dedicated node-local DNS IP to bind on each node. Uses the same IP on every node. Adjust this if 169.254.20.10 is already in use in your cluster, for example by an existing node-local-dns deployment. |
| transparentDNS.takeoverClusterIP | bool | `true` | Also try to bind and intercept the existing kube-dns/CoreDNS Service IP on each node. Disable this on environments where the ClusterIP cannot be bound locally, for example some IPVS-based or otherwise restricted setups. |
| transparentDNS.clusterDomain | string | `"cluster.local"` | Cluster DNS domain still forwarded to CoreDNS. Required when transparentDNS.enabled=true. |
| transparentDNS.clusterDNS.namespace | string | `"kube-system"` | Namespace where the cluster DNS pods live and, by default, where the optional auxiliary upstream Service is created. Required when transparentDNS.enabled=true. If this differs from the Helm release namespace, the install/upgrade identity must be allowed to create and manage Services in that namespace. |
| transparentDNS.clusterDNS.serviceIP | string | `""` | ClusterIP of the kube-dns/CoreDNS Service that pods already use today. Required when transparentDNS.enabled=true and transparentDNS.takeoverClusterIP=true. |
| transparentDNS.clusterDNS.upstreamService.create | bool | `true` | Create an auxiliary Service with its own fixed ClusterIP in front of the CoreDNS pods to avoid recursion through the intercepted clusterDNS.serviceIP. When enabled, the Helm install/upgrade identity must be allowed to create and manage that Service in transparentDNS.clusterDNS.namespace. |
| transparentDNS.clusterDNS.upstreamService.name | string | `""` | Override the generated upstream Service name. |
| transparentDNS.clusterDNS.upstreamService.clusterIP | string | `""` | Fixed ClusterIP of the auxiliary CoreDNS upstream Service. Required when transparentDNS.enabled=true, customClusterDNSIP is empty, and upstreamService.create=true. |
| transparentDNS.clusterDNS.upstreamService.annotations | object | `{}` | Service annotations for the auxiliary CoreDNS upstream Service. |
| transparentDNS.clusterDNS.selector | object | `{"k8s-app":"kube-dns"}` | Pod selector for the auxiliary CoreDNS upstream Service. Required when transparentDNS.enabled=true, customClusterDNSIP is empty, and upstreamService.create=true. |
| transparentDNS.customClusterDNSIP | string | `""` | Use a pre-existing auxiliary CoreDNS upstream Service IP instead of creating one. Required when transparentDNS.enabled=true and upstreamService.create=false. |
| transparentDNS.interceptor.image.repository | string | `"ghcr.io/klicktipp/pdns-transparent-dns"` | Image used for the transparent DNS init/interceptor containers. |
| transparentDNS.interceptor.image.tag | string | `"0.1.2"` | Image tag of the transparent DNS init/interceptor image. |
| transparentDNS.interceptor.image.pullPolicy | string | `"IfNotPresent"` | Pull policy for the interceptor helper image. |
| transparentDNS.setupIptables | bool | `true` | Configure the local IP aliases plus raw/filter iptables rules required for the transparent DNS mode. |
| transparentDNS.captureOutput | bool | `true` | Also configure raw OUTPUT rules for node-local processes hitting the node-local DNS IP and, when enabled, the cluster DNS Service IP. |
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
| securityContext.runAsUser | int | `953` | Unix user id. Transparent DNS mode overrides this to root so PowerDNS can bind port 53 before dropping privileges internally via recursor setuid/setgid. |
| securityContext.runAsGroup | int | `953` | Unix group id. Transparent DNS mode overrides this to root. |
| priorityClassName | string | `""` | Optional priority class for pods. When transparentDNS.enabled=true and this value is empty, the chart defaults to "system-node-critical". |
| podAntiAffinity | object | `{"topologyKey":"kubernetes.io/hostname","type":"soft"}` | Pod anti-affinity shortcut (used when affinity is empty). |
| podAntiAffinity.type | string | `"soft"` | "soft", "hard" or "disabled". Ignored in DaemonSet mode. |
| podAntiAffinity.topologyKey | string | `"kubernetes.io/hostname"` | Topology key used by anti-affinity. |
| affinity | object | `{}` | Native affinity rules. If set, this overrides podAntiAffinity. |
| nodeSelector | object | `{}` | Node selector for scheduling. |
| tolerations | list | `[]` | Tolerations for scheduling. |
| podDisruptionBudget | object | `{}` | PodDisruptionBudget spec snippet. Example: { maxUnavailable: 1 }. Ignored in DaemonSet mode. |
| service | object | `{"annotations":{},"clusterIP":"","enabled":true,"headless":{"annotations":{},"enabled":false,"includeDnsPorts":true,"publishNotReadyAddresses":false},"loadBalancerIP":"","loadBalancerSourceRanges":[],"local":{"annotations":{},"clusterIP":"","enabled":false},"port":53,"type":"ClusterIP"}` | Service configuration. |
| service.enabled | bool | `true` | Create the primary cluster-wide Service. Disable this in transparent DNS setups when you do not want an additional global ClusterIP for PowerDNS. |
| service.type | string | `"ClusterIP"` | Service type. |
| service.clusterIP | string | `""` | Optional fixed ClusterIP for the primary Service. |
| service.port | int | `53` | DNS service port (TCP/UDP). |
| service.annotations | object | `{}` | Service annotations. |
| service.loadBalancerIP | string | `""` | Optional fixed LoadBalancer IP. |
| service.loadBalancerSourceRanges | list | `[]` | Optional source ranges for LoadBalancer services. |
| service.local | object | `{"annotations":{},"clusterIP":"","enabled":false}` | Optional DaemonSet-local Service for node-local DNS traffic. |
| service.local.enabled | bool | `false` | Create an additional DaemonSet-local ClusterIP Service with internalTrafficPolicy=Local. Requires workload.type=DaemonSet and an explicit service.local.clusterIP so the transparent DNS helper can bind and intercept that IP deterministically. |
| service.local.clusterIP | string | `""` | Fixed ClusterIP for the local-only Service. Required when service.local.enabled=true. |
| service.local.annotations | object | `{}` | Annotations for the local-only Service. |
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
| probes | object | `{"liveness":{"failureThreshold":3,"initialDelaySeconds":5,"periodSeconds":5,"timeoutSeconds":3},"readiness":{"failureThreshold":3,"initialDelaySeconds":5,"periodSeconds":5,"timeoutSeconds":3},"startup":{"failureThreshold":30,"initialDelaySeconds":0,"periodSeconds":2,"timeoutSeconds":3}}` | Probe configuration. |
| probes.startup.initialDelaySeconds | int | `0` | Initial delay before the startup probe begins. Used for transparent DNS mode to avoid early restarts while takeover IPs are prepared. |
| probes.startup.periodSeconds | int | `2` | Probe period for the startup probe. |
| probes.startup.timeoutSeconds | int | `3` | Probe timeout for the startup probe. |
| probes.startup.failureThreshold | int | `30` | Failure threshold for the startup probe. |
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
| pdns.port | int | `5353` | Container DNS port. Transparent DNS mode ignores this value and forces PowerDNS to listen on port 53. |
| pdns.api | object | `{"enabled":false,"port":8082}` | API endpoint settings. |
| pdns.api.enabled | bool | `false` | Expose API port through the Service and container. |
| pdns.api.port | int | `8082` | API TCP port. |
| pdns.lua | object | `{"enabled":false,"script":"zoneToCache(\".\", \"url\", \"https://www.internic.net/domain/root.zone\", { refreshPeriod = 86400 })\n"}` | Optional Lua config file support. |
| pdns.lua.enabled | bool | `false` | Create additional Lua ConfigMap and mount recursor.lua. |
| pdns.lua.script | string | `"zoneToCache(\".\", \"url\", \"https://www.internic.net/domain/root.zone\", { refreshPeriod = 86400 })\n"` | Lua script content written to /etc/powerdns/recursor.lua. |
| pdns.config | object | `{"dnssec":{"validation":"process"},"incoming":{"listen":["0.0.0.0"],"port":5353},"logging":{"loglevel":6,"quiet":true},"outgoing":{"source_address":["0.0.0.0"]},"recordcache":{"refresh_on_ttl_perc":10},"recursor":{"config_dir":"/etc/powerdns","setgid":"pdns","setuid":"pdns","socket_mode":"660"},"webservice":{"webserver":false}}` | Base configuration passed into the `pdns.config` helper to render recursor.yml. Transparent DNS mode may adjust parts of this structure automatically. |
| pdns.config.incoming.port | int | `5353` | Transparent DNS mode overrides the incoming port to 53 and the listen addresses to transparentDNS.localIP plus, optionally, transparentDNS.clusterDNS.serviceIP, service.clusterIP, and service.local.clusterIP via the `pdns.config` helper. |
| pdns.config.recordcache.refresh_on_ttl_perc | int | `10` | Refresh cache entries shortly before TTL expiry to reduce miss spikes. |
| pdns.metrics | object | `{"enabled":false}` | Legacy compatibility block. |
