# rspamd

![Version: 1.2.2](https://img.shields.io/badge/Version-1.2.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 3.14.2](https://img.shields.io/badge/AppVersion-3.14.2-informational?style=flat-square)

A Helm chart for deploying Rspamd on Kubernetes

**Homepage:** <https://github.com/klicktipp/helm-charts>
## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| vquie |  | <https://github.com/vquie> |
## Source Code

* <https://github.com/rspamd/rspamd>
* <https://rspamd.com>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` | Number of Rspamd replicas per tenant (or total when multiTenancy=false). |
| global | object | `{"baseURL":"rspamd.example.com"}` | Global settings used across templates. |
| global.baseURL | string | `"rspamd.example.com"` | Public DNS host used in generated neighbour URLs and ingress host defaults. |
| image | object | `{"pullPolicy":"IfNotPresent","registry":"docker.io","repository":"rspamd/rspamd","tag":""}` | Container image configuration. |
| image.registry | string | `"docker.io"` | Optional image registry prefix. |
| image.repository | string | `"rspamd/rspamd"` | Image repository. |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy. |
| image.tag | string | `""` | Image tag. If empty, chart appVersion is used. |
| imagePullSecrets | list | `[]` | Image pull secrets. |
| nameOverride | string | `""` | Partially override generated resource names. |
| fullnameOverride | string | `""` | Fully override generated resource names. |
| serviceAccount | object | `{"annotations":{},"automount":false,"automountServiceAccountToken":false,"create":true,"name":""}` | ServiceAccount configuration. |
| serviceAccount.create | bool | `true` | Create a dedicated ServiceAccount. |
| serviceAccount.automountServiceAccountToken | bool | `false` | Mount ServiceAccount token into pods. |
| serviceAccount.automount | bool | `false` | Deprecated compatibility key (use automountServiceAccountToken). |
| serviceAccount.annotations | object | `{}` | ServiceAccount annotations. |
| serviceAccount.name | string | `""` | Explicit ServiceAccount name. If empty, a name is generated. |
| podAnnotations | object | `{}` | Extra annotations added to the pod template. |
| podLabels | object | `{}` | Extra labels added to the pod template. |
| podSecurityContext | object | `{"fsGroup":11333,"fsGroupChangePolicy":"OnRootMismatch","runAsGroup":11333,"runAsNonRoot":true,"runAsUser":11333,"seccompProfile":{"type":"RuntimeDefault"}}` | Pod-level security context. |
| podSecurityContext.runAsNonRoot | bool | `true` | Ensure the container does not run as root. |
| podSecurityContext.fsGroup | int | `11333` | Unix group id for mounted volumes. |
| podSecurityContext.fsGroupChangePolicy | string | `"OnRootMismatch"` | Avoid unnecessary recursive ownership changes on mounted volumes. |
| podSecurityContext.runAsUser | int | `11333` | Unix user id. |
| podSecurityContext.runAsGroup | int | `11333` | Unix group id. |
| podSecurityContext.seccompProfile | object | `{"type":"RuntimeDefault"}` | Use the container runtime's default seccomp profile. |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]}}` | Container-level security context. |
| securityContext.allowPrivilegeEscalation | bool | `false` | Prevent privilege escalation inside the container. |
| securityContext.capabilities | object | `{"drop":["ALL"]}` | Drop all Linux capabilities by default. |
| terminationGracePeriodSeconds | int | `30` | Pod termination grace period in seconds. |
| enableServiceLinks | bool | `false` | Disable automatic injection of Service environment variables. |
| priorityClassName | string | `""` | Optional priority class for pods. |
| revisionHistoryLimit | int | `10` | Number of old StatefulSet revisions to retain. |
| podManagementPolicy | string | `"OrderedReady"` | StatefulSet pod management policy. |
| updateStrategy | object | `{"type":"RollingUpdate"}` | StatefulSet update strategy. |
| updateStrategy.type | string | `"RollingUpdate"` | Strategy type, usually RollingUpdate or OnDelete. |
| services | object | `{"controller":11334,"proxy":11332,"worker":11333}` | Named service ports used by Service, probes and ingress defaults. |
| services.proxy | int | `11332` | Proxy port. |
| services.worker | int | `11333` | Worker/UI/API port. |
| services.controller | int | `11334` | Controller port. |
| metrics | object | `{"additionalLabels":{},"enabled":true,"interval":"60s","path":"/metrics","scrapeTimeout":""}` | Metrics and PodMonitor settings. |
| metrics.enabled | bool | `true` | Enable PodMonitor creation when CRD exists. |
| metrics.additionalLabels | object | `{}` | Extra labels added to the PodMonitor. |
| metrics.interval | string | `"60s"` | Scrape interval. |
| metrics.scrapeTimeout | string | `""` | Optional scrape timeout. |
| metrics.path | string | `"/metrics"` | Metrics path on the worker port. |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"chart-example.local","paths":[{"backend":{"serviceName":"","servicePort":11333},"path":"/","pathType":"Prefix"}]}],"singlePodPaths":{"enabled":true},"tls":[]}` | Ingress configuration. |
| ingress.enabled | bool | `false` | Enable ingress resources. |
| ingress.className | string | `""` | ingressClassName value. |
| ingress.annotations | object | `{}` | Ingress annotations. |
| ingress.hosts | list | `[{"host":"chart-example.local","paths":[{"backend":{"serviceName":"","servicePort":11333},"path":"/","pathType":"Prefix"}]}]` | Ingress host/path rules. |
| ingress.hosts[0].paths[0].backend.serviceName | string | `""` | Service name for this ingress path. If empty, defaults to chart Service. |
| ingress.hosts[0].paths[0].backend.servicePort | int | `11333` | Service port for this ingress path. If empty, defaults to services.worker. |
| ingress.tls | list | `[]` | TLS sections. |
| ingress.singlePodPaths | object | `{"enabled":true}` | Extra ingress exposing per-pod endpoints for neighbour calls. |
| ingress.singlePodPaths.enabled | bool | `true` | Enable dedicated per-pod ingress rules. |
| resources | object | `{}` | Container resource requests and limits. |
| livenessProbe | object | `{"initialDelaySeconds":30,"tcpSocket":{"port":"worker"}}` | Liveness probe settings. |
| readinessProbe | object | `{"httpGet":{"path":"/ping","port":"worker"},"initialDelaySeconds":10,"periodSeconds":5}` | Readiness probe settings. |
| startupProbe | object | `{"failureThreshold":30,"httpGet":{"path":"/ping","port":"worker"},"periodSeconds":5}` | Startup probe settings. |
| autoscaling | object | `{"enabled":false,"maxReplicas":100,"minReplicas":1,"targetCPUUtilizationPercentage":80,"targetMemoryUtilizationPercentage":null}` | Horizontal Pod Autoscaler settings. |
| autoscaling.enabled | bool | `false` | Enable HPA. |
| autoscaling.minReplicas | int | `1` | Minimum number of replicas. |
| autoscaling.maxReplicas | int | `100` | Maximum number of replicas. |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | Target average CPU utilization percentage. |
| autoscaling.targetMemoryUtilizationPercentage | string | `nil` | Target average memory utilization percentage. |
| volumes | list | `[]` | Additional volumes mounted into the pod. |
| volumeMounts | list | `[]` | Additional volume mounts for the Rspamd container. |
| nodeSelector | object | `{}` | Node selector for pod scheduling. |
| tolerations | list | `[]` | Tolerations for pod scheduling. |
| podAntiAffinity | object | `{"topologyKey":"kubernetes.io/hostname","type":"soft"}` | Pod anti-affinity shortcut used when affinity is empty. |
| podAntiAffinity.type | string | `"soft"` | "soft", "hard" or "disabled". |
| podAntiAffinity.topologyKey | string | `"kubernetes.io/hostname"` | Topology key used by anti-affinity. |
| topologySpreadConstraints | list | `[]` | Topology spread constraints for pod scheduling. |
| affinity | object | `{}` | Native affinity rules. If set, this is used as-is. |
| customAffinity | object | `{}` | Deprecated compatibility key for affinity (prefer affinity). |
| extraEnvs | object | `{}` | Additional environment variables as plain text (ConfigMap-backed). |
| extraEnv | object | `{}` | Deprecated compatibility key for extraEnvs. |
| extraSecrets | object | `{}` | Additional environment variables as secrets (Secret-backed, values are plain text). |
| multiTenancy | bool | `false` | Enable multi-tenant mode (one StatefulSet and Services per config key). |
| config | object | `{}` | Rspamd config files written to /etc/rspamd/local.d/. In multiTenancy mode this must be a map: tenant -> (filename -> content). In single-tenant mode this must be a map: filename -> content. |
| podDisruptionBudget | object | `{}` | PodDisruptionBudget spec snippet. Example: { maxUnavailable: 1 } |
| persistence | object | `{"accessModes":["ReadWriteOnce"],"annotations":{},"enabled":false,"size":"8Gi","storageClass":""}` | Persistent volume configuration for /data. |
| persistence.enabled | bool | `false` | Enable persistent storage. |
| persistence.storageClass | string | `""` | StorageClass name. Leave empty to use cluster default StorageClass. |
| persistence.accessModes | list | `["ReadWriteOnce"]` | Access modes for the PVC. |
| persistence.size | string | `"8Gi"` | Requested storage size. |
| persistence.annotations | object | `{}` | PVC annotations. |

<!-- BEGIN AUTO EXAMPLES -->
## Examples

### 1. Multi-tenant generic setup

Example for inbound/outbound tenant split with ingress, persistence and generic placeholders.

```yaml
---
# Generic multi-tenant example values for rspamd.
# This file intentionally uses placeholder domains/hosts and no secrets.

global:
  baseURL: "rspamd.<env>.example.com"

replicaCount: 2

image:
  # Example: private mirror/registry
  registry: "registry.example.com/dockerhub-mirror"

extraSecrets:
  # Provide values via --set-string or an external values file in CI/CD.
  ADMINPASSWORD: "<replace-me>"

ingress:
  enabled: true
  className: "nginx"
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
    nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    nginx.ingress.kubernetes.io/client-body-buffer-size: "100K"
  hosts:
    - host: "rspamd.<env>.example.com"
      paths:
        - path: /
          pathType: Prefix
          backend:
            serviceName: ""
            servicePort: 11334
        - path: /checkv2
          pathType: Prefix
          backend:
            serviceName: ""
            servicePort: 11333
  tls:
    - secretName: "rspamd-<env>-tls"
      hosts:
        - "rspamd.<env>.example.com"

nodeSelector:
  kubernetes.io/os: linux

podDisruptionBudget:
  minAvailable: 1

persistence:
  enabled: true
  storageClass: "standard"

multiTenancy: true

config:
  inbound:
    logging.inc: |
      level = notice;
      log_json = true;
    options.inc: |
      dns {
        nameserver = "1.1.1.1";
      }
      dynamic_conf = "/data/rspamd_dynamic";
    worker-controller.inc: |
      password = "{= env.adminpassword|pbkdf =}";
    actions.conf: |
      greylist = "";
    redis.conf: |
      servers = "redis-master.redis.svc.cluster.local";
      db = 3;
  outbound:
    logging.inc: |
      level = notice;
      log_json = true;
    options.inc: |
      dns {
        nameserver = "1.1.1.1";
      }
      dynamic_conf = "/data/rspamd_dynamic";
    worker-controller.inc: |
      password = "{= env.adminpassword|pbkdf =}";
    actions.conf: |
      greylist = "";
      add_header = "";
      reject = "";
    redis.conf: |
      servers = "redis-master.redis.svc.cluster.local";
      db = 3;

resources:
  requests:
    memory: 256Mi
  limits:
    memory: 1Gi
```

### 2. Single-tenant generic setup

Minimal single-tenant example with ingress, PDB and base rspamd config snippets.

```yaml
---
# Generic single-tenant example values for rspamd.

global:
  baseURL: "rspamd.example.com"

replicaCount: 2

ingress:
  enabled: true
  className: "nginx"
  hosts:
    - host: "rspamd.example.com"
      paths:
        - path: /
          pathType: Prefix
          backend:
            serviceName: ""
            servicePort: 11333
  tls:
    - secretName: "rspamd-example-com-tls"
      hosts:
        - "rspamd.example.com"

podDisruptionBudget:
  maxUnavailable: 1

config:
  logging.inc: |
    level = notice;
    log_json = true;
  worker-controller.inc: |
    password = "{= env.adminpassword|pbkdf =}";
  redis.conf: |
    servers = "redis-master.redis.svc.cluster.local";
    db = 3;
```

<!-- END AUTO EXAMPLES -->
