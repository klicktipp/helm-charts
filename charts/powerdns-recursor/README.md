# powerdns-recursor

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 5.3.4](https://img.shields.io/badge/AppVersion-5.3.4-informational?style=flat-square)

Helm chart for deploying PowerDNS Recursor on Kubernetes

**Homepage:** <https://github.com/klicktipp/helm-charts>

## Source Code

* <https://github.com/PowerDNS/pdns>
* <https://www.powerdns.com>
* <https://www.powerdns.com/powerdns-recursor>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` | Number of pod replicas. |
| revisionHistoryLimit | int | `10` | Number of old ReplicaSets to retain. |
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
| priorityClassName | string | `""` | Optional priority class for pods. |
| podAntiAffinity | object | `{"topologyKey":"kubernetes.io/hostname","type":"soft"}` | Pod anti-affinity shortcut (used when affinity is empty). |
| podAntiAffinity.type | string | `"soft"` | "soft", "hard" or "disabled". |
| podAntiAffinity.topologyKey | string | `"kubernetes.io/hostname"` | Topology key used by anti-affinity. |
| affinity | object | `{}` | Native affinity rules. If set, this overrides podAntiAffinity. |
| nodeSelector | object | `{}` | Node selector for scheduling. |
| tolerations | list | `[]` | Tolerations for scheduling. |
| podDisruptionBudget | object | `{}` | PodDisruptionBudget spec snippet. Example: { maxUnavailable: 1 } |
| service | object | `{"annotations":{},"loadBalancerIP":"","loadBalancerSourceRanges":[],"port":53,"type":"ClusterIP"}` | Service configuration. |
| service.type | string | `"ClusterIP"` | Service type. |
| service.port | int | `53` | DNS service port (TCP/UDP). |
| service.annotations | object | `{}` | Service annotations. |
| service.loadBalancerIP | string | `""` | Optional fixed LoadBalancer IP. |
| service.loadBalancerSourceRanges | list | `[]` | Optional source ranges for LoadBalancer services. |
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
| extraObjects | list | `[]` | Additional arbitrary manifests appended to the release. |
| image | object | `{"imagePullPolicy":"","pullPolicy":"IfNotPresent","registry":"","repository":"powerdns/pdns-recursor-53","tag":""}` | Container image configuration. |
| image.registry | string | `""` | Optional image registry prefix. |
| image.repository | string | `"powerdns/pdns-recursor-53"` | Image repository. |
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
| pdns | object | `{"api":{"enabled":false,"port":8082},"config":{"dnssec":{"validation":"process"},"incoming":{"listen":["0.0.0.0"],"port":5353},"logging":{"loglevel":6,"quiet":true},"outgoing":{"source_address":["0.0.0.0"]},"recordcache":{"refresh_on_ttl_perc":10},"recursor":{"config_dir":"/etc/powerdns","setgid":"pdns","setuid":"pdns","socket_mode":"660"},"webservice":{"webserver":"false"}},"lua":{"enabled":false,"script":"zoneToCache(\".\", \"url\", \"https://www.internic.net/domain/root.zone\", { refreshPeriod = 86400 })\n"},"metrics":{"enabled":false},"port":5353}` | PowerDNS recursor runtime configuration. |
| pdns.port | int | `5353` | Container DNS port. |
| pdns.api | object | `{"enabled":false,"port":8082}` | API endpoint settings. |
| pdns.api.enabled | bool | `false` | Expose API port through the Service and container. |
| pdns.api.port | int | `8082` | API TCP port. |
| pdns.lua | object | `{"enabled":false,"script":"zoneToCache(\".\", \"url\", \"https://www.internic.net/domain/root.zone\", { refreshPeriod = 86400 })\n"}` | Optional Lua config file support. |
| pdns.lua.enabled | bool | `false` | Create additional Lua ConfigMap and mount recursor.lua. |
| pdns.lua.script | string | `"zoneToCache(\".\", \"url\", \"https://www.internic.net/domain/root.zone\", { refreshPeriod = 86400 })\n"` | Lua script content written to /etc/powerdns/recursor.lua. |
| pdns.config | object | `{"dnssec":{"validation":"process"},"incoming":{"listen":["0.0.0.0"],"port":5353},"logging":{"loglevel":6,"quiet":true},"outgoing":{"source_address":["0.0.0.0"]},"recordcache":{"refresh_on_ttl_perc":10},"recursor":{"config_dir":"/etc/powerdns","setgid":"pdns","setuid":"pdns","socket_mode":"660"},"webservice":{"webserver":"false"}}` | Rendered directly into recursor.yml. |
| pdns.config.recordcache.refresh_on_ttl_perc | int | `10` | Refresh cache entries shortly before TTL expiry to reduce miss spikes. |
| pdns.metrics | object | `{"enabled":false}` | Legacy compatibility block. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
