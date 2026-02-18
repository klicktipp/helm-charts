# n8n

![Version: 1.2.3](https://img.shields.io/badge/Version-1.2.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.9.0](https://img.shields.io/badge/AppVersion-2.9.0-informational?style=flat-square)

Helm Chart for deploying n8n on Kubernetes, a fair-code workflow automation platform with native AI capabilities for technical teams. Easily automate tasks across different services.

**Homepage:** <https://github.com/klicktipp/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| vquie |  | <https://github.com/vquie> |

## Source Code

* <https://github.com/klicktipp/helm-charts>
* <https://github.com/n8n-io/n8n>
* <https://n8n.io/>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://valkey.io/valkey-helm/ | valkey | 0.9.3 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image | object | `{"pullPolicy":"IfNotPresent","repository":"n8nio/n8n","tag":""}` | Default image settings. `tag` defaults to chart `appVersion` when empty. |
| imagePullSecrets | list | `[]` | Image pull secrets for all workloads (legacy key; `global.imagePullSecrets` is preferred). |
| global.image | object | `{}` | Global image override for all workloads (main/worker/webhook). |
| global.imagePullSecrets | list | `[]` | Global image pull secrets used by all workloads. |
| global.labels | object | `{}` | Additional labels added to all rendered resources. |
| global.deploymentAnnotations | object | `{}` | Deployment metadata inherited by all workloads. |
| global.deploymentLabels | object | `{}` | Additional deployment labels inherited by all workloads. |
| global.podAnnotations | object | `{}` | Pod metadata inherited by all workloads. |
| global.podLabels | object | `{}` | Additional pod labels inherited by all workloads. |
| global.podSecurityContext | object | `{"fsGroup":1000,"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000}` | Pod/container defaults inherited by all workloads. |
| global.securityContext | object | `{}` | Default container security context inherited by all workloads. |
| global.resources | object | `{}` | Default container resources inherited by all workloads. |
| global.nodeSelector | object | `{}` | Scheduling defaults inherited by all workloads. |
| global.tolerations | list | `[]` | Default pod tolerations inherited by all workloads. |
| global.affinity | object | `{}` | Default pod affinity inherited by all workloads. |
| global.extraEnv | list | `[]` | Global env vars merged into each component's `extraEnv`. Preferred format is a list of Kubernetes EnvVar objects. Map format is supported for backward compatibility. For list format, component entries override global entries by `name`. |
| global.envFromConfigMaps | list | `[]` | Global ConfigMaps loaded via `envFrom` for all workloads. Component lists are appended. |
| global.envFromSecrets | list | `[]` | Global Secrets loaded via `envFrom` for all workloads. Component lists are appended. |
| global.initContainers | list | `[]` | Global init containers appended to each workload. Component-specific init containers are appended after these entries. |
| global.serviceAccount.annotations | object | `{}` | Global annotations for the ServiceAccount. |
| global.serviceAccount.name | string | `""` | Global ServiceAccount name override. |
| global.persistence.annotations | object | `{}` | Global PVC defaults. Components can override these values. |
| global.persistence.accessModes | list | `["ReadWriteOnce"]` | Global PVC access modes. |
| global.persistence.size | string | `"1Gi"` | Global PVC size. |
| nameOverride | string | `nil` | Partially override generated resource names. |
| fullnameOverride | string | `nil` | Fully override generated resource names. |
| hostAliases | list | `[]` | Additional `/etc/hosts` entries for pods. |
| ingress.enabled | bool | `false` | Enable ingress resource. |
| ingress.annotations | object | `{}` | Ingress annotations. |
| ingress.className | string | `""` | Ingress class name (for example `nginx` or `traefik`). |
| ingress.hosts[0].host | string | `"workflow.example.com"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"Prefix"` | Ingress path type. |
| ingress.tls | list | `[]` | Ingress TLS entries. |
| main.image | object | `{}` | Optional image override for main workload. Supports `repository`, `tag`, and `pullPolicy`. Falls back to `global.image` and then `image`. |
| main.config | object | `{}` | n8n config values converted to env vars in a ConfigMap. See: https://docs.n8n.io/hosting/configuration/environment-variables/ |
| main.secret | object | `{}` | n8n secret values converted to env vars in a Secret. |
| main.userFolder | string | `"/home/node"` | Main user data folder (`N8N_USER_FOLDER`) and mount path for main persistence volume. |
| main.extraEnv | list | `[]` | Additional env vars for the container. Preferred format is a list of Kubernetes EnvVar objects. Backward-compatible map format is also supported by templates. Merged with `global.extraEnv`; component entries override by `name`. |
| main.envFromConfigMaps | list | `[]` | Additional ConfigMaps loaded via `envFrom`. Merged with `global.envFromConfigMaps`. |
| main.envFromSecrets | list | `[]` | Additional Secrets loaded via `envFrom`. Merged with `global.envFromSecrets`. |
| main.persistence.enabled | bool | `false` | Enable persistent storage for the main workload. |
| main.persistence.type | string | `"emptyDir"` | Persistence type: `emptyDir`, `existing`, or `dynamic`. |
| main.extraVolumes | list | `[]` | Extra pod volumes for the main workload. |
| main.extraVolumeMounts | list | `[]` | Extra volume mounts for the main workload. |
| main.replicaCount | int | `1` | Number of main pods to run. |
| main.deploymentStrategy.type | string | `"Recreate"` | Deployment strategy type. |
| main.serviceAccount.create | bool | `true` | Create a ServiceAccount for main deployment. |
| main.serviceAccount.annotations | object | `{}` | ServiceAccount annotations for main deployment. |
| main.serviceAccount.name | string | `""` | Existing ServiceAccount name for main deployment. |
| main.deploymentAnnotations | object | `{}` | Deployment annotations for main deployment. |
| main.deploymentLabels | object | `{}` | Deployment labels for main deployment. |
| main.podAnnotations | object | `{}` | Pod annotations for main deployment. |
| main.podLabels | object | `{}` | Pod labels for main deployment. |
| main.podSecurityContext | object | `{}` | Set to `{}` to inherit from `global.podSecurityContext`. |
| main.securityContext | object | `{}` | Set to `{}` to inherit from `global.securityContext`. |
| main.lifecycle | object | `{}` | Container lifecycle hooks for main deployment. |
| main.command | list | `[]` | Override container command. |
| main.livenessProbe.httpGet.path | string | `"/healthz"` | HTTP path for liveness probe. |
| main.livenessProbe.httpGet.port | string | `"http"` | Port for liveness probe. |
| main.readinessProbe.httpGet.path | string | `"/healthz"` | HTTP path for readiness probe. |
| main.readinessProbe.httpGet.port | string | `"http"` | Port for readiness probe. |
| main.initContainers | list | `[]` | Init containers for main deployment. Appended after `global.initContainers`. |
| main.service.enabled | bool | `true` | Create service for main deployment. |
| main.service.annotations | object | `{}` | Service annotations for main deployment. |
| main.service.type | string | `"ClusterIP"` | Service type for main deployment. |
| main.service.port | int | `80` | Service port for main deployment. |
| main.resources | object | `{}` | Set to `{}` to inherit from `global.resources`. |
| main.autoscaling.enabled | bool | `false` | Enable HPA for main deployment. |
| main.autoscaling.minReplicas | int | `1` | Minimum replicas for HPA. |
| main.autoscaling.maxReplicas | int | `100` | Maximum replicas for HPA. |
| main.autoscaling.targetCPUUtilizationPercentage | int | `80` | Target average CPU utilization (percent). |
| main.nodeSelector | object | `{}` | Set to empty values to inherit from global scheduling settings. |
| main.tolerations | list | `[]` | Pod tolerations for main deployment. |
| main.affinity | object | `{}` | Pod affinity for main deployment. |
| main.terminationGracePeriodSeconds | int | `30` | Pod termination grace period in seconds for main deployment. |
| worker.enabled | bool | `false` | Enable worker deployment. |
| worker.image | object | `{"repository":"n8nio/runners"}` | Worker image settings. Supports `repository`, `tag`, and `pullPolicy`. Defaults to `n8nio/runners` and falls back to `global.image`/`image` for unset fields. |
| worker.config | object | `{}` | Additional worker-specific n8n config. |
| worker.secret | object | `{}` | Additional worker-specific n8n secrets. |
| worker.userFolder | string | `"/home/runner"` | Worker user data folder (`N8N_USER_FOLDER`) and mount path for worker persistence volume. |
| worker.extraEnv | list | `[]` | Additional env vars for worker pods. Preferred format is a list of Kubernetes EnvVar objects. Backward-compatible map format is also supported by templates. Merged with `global.extraEnv`; component entries override by `name`. |
| worker.envFromConfigMaps | list | `[]` | Additional ConfigMaps loaded via `envFrom`. Merged with `global.envFromConfigMaps`. |
| worker.envFromSecrets | list | `[]` | Additional Secrets loaded via `envFrom`. Merged with `global.envFromSecrets`. |
| worker.concurrency | int | `10` | Number of jobs a worker processes in parallel. |
| worker.persistence.enabled | bool | `false` | Enable persistent storage for worker deployment. |
| worker.persistence.type | string | `"emptyDir"` | Persistence type for worker (`emptyDir`, `existing`, `dynamic`). |
| worker.replicaCount | int | `1` | Number of worker pods to run. |
| worker.deploymentStrategy.type | string | `"Recreate"` | Deployment strategy type for worker. |
| worker.deploymentAnnotations | object | `{}` | Deployment annotations for worker deployment. |
| worker.deploymentLabels | object | `{}` | Deployment labels for worker deployment. |
| worker.podAnnotations | object | `{}` | Pod annotations for worker deployment. |
| worker.podLabels | object | `{}` | Pod labels for worker deployment. |
| worker.podSecurityContext | object | `{}` | Set to `{}` to inherit from `global.podSecurityContext`. |
| worker.securityContext | object | `{}` | Set to `{}` to inherit from `global.securityContext`. |
| worker.lifecycle | object | `{}` | Container lifecycle hooks for worker deployment. |
| worker.command | list | `[]` | Override worker container command. |
| worker.commandArgs | list | `[]` | Override worker container args. |
| worker.livenessProbe.httpGet.path | string | `"/healthz"` | HTTP path for worker liveness probe. |
| worker.livenessProbe.httpGet.port | string | `"http"` | Port for worker liveness probe. |
| worker.readinessProbe.httpGet.path | string | `"/healthz"` | HTTP path for worker readiness probe. |
| worker.readinessProbe.httpGet.port | string | `"http"` | Port for worker readiness probe. |
| worker.initContainers | list | `[]` | Init containers for worker deployment. Appended after `global.initContainers`. |
| worker.service | object | `{"annotations":{},"port":80,"type":"ClusterIP"}` | Currently not used by templates. |
| worker.resources | object | `{}` | Set to `{}` to inherit from `global.resources`. |
| worker.autoscaling.enabled | bool | `false` | Enable HPA for worker deployment. |
| worker.autoscaling.minReplicas | int | `1` | Minimum replicas for worker HPA. |
| worker.autoscaling.maxReplicas | int | `100` | Maximum replicas for worker HPA. |
| worker.autoscaling.targetCPUUtilizationPercentage | int | `80` | Target average CPU utilization (percent) for worker HPA. |
| worker.nodeSelector | object | `{}` | Pod node selector for worker deployment. |
| worker.tolerations | list | `[]` | Pod tolerations for worker deployment. |
| worker.affinity | object | `{}` | Pod affinity for worker deployment. |
| worker.extraVolumes | list | `[]` | Extra pod volumes for worker pods. |
| worker.extraVolumeMounts | list | `[]` | Extra volume mounts for worker pods. |
| worker.terminationGracePeriodSeconds | int | `30` | Pod termination grace period in seconds for worker deployment. |
| webhook.enabled | bool | `false` | Enable webhook deployment. |
| webhook.image | object | `{}` | Optional image override for webhook workload. Supports `repository`, `tag`, and `pullPolicy`. Falls back to `global.image` and then `image`. |
| webhook.config | object | `{}` | Additional webhook-specific n8n config. |
| webhook.secret | object | `{}` | Additional webhook-specific n8n secrets. |
| webhook.userFolder | string | `"/home/node"` | Webhook user data folder (`N8N_USER_FOLDER`) and mount path for webhook persistence volume. |
| webhook.extraEnv | list | `[]` | Additional env vars for webhook pods. Preferred format is a list of Kubernetes EnvVar objects. Backward-compatible map format is also supported by templates. Merged with `global.extraEnv`; component entries override by `name`. |
| webhook.envFromConfigMaps | list | `[]` | Additional ConfigMaps loaded via `envFrom`. Merged with `global.envFromConfigMaps`. |
| webhook.envFromSecrets | list | `[]` | Additional Secrets loaded via `envFrom`. Merged with `global.envFromSecrets`. |
| webhook.persistence.enabled | bool | `false` | Enable persistent storage for webhook deployment. |
| webhook.persistence.type | string | `"emptyDir"` | Persistence type for webhook (`emptyDir`, `existing`, `dynamic`). |
| webhook.replicaCount | int | `1` | Number of webhook pods to run. |
| webhook.deploymentStrategy.type | string | `"Recreate"` | Deployment strategy type for webhook. |
| webhook.deploymentAnnotations | object | `{}` | Deployment annotations for webhook deployment. |
| webhook.deploymentLabels | object | `{}` | Deployment labels for webhook deployment. |
| webhook.podAnnotations | object | `{}` | Pod annotations for webhook deployment. |
| webhook.podLabels | object | `{}` | Pod labels for webhook deployment. |
| webhook.podSecurityContext | object | `{}` | Set to `{}` to inherit from `global.podSecurityContext`. |
| webhook.securityContext | object | `{}` | Set to `{}` to inherit from `global.securityContext`. |
| webhook.lifecycle | object | `{}` | Container lifecycle hooks for webhook deployment. |
| webhook.command | list | `[]` | Override webhook container command. |
| webhook.commandArgs | list | `[]` | Override webhook container args. |
| webhook.livenessProbe.httpGet.path | string | `"/healthz"` | HTTP path for webhook liveness probe. |
| webhook.livenessProbe.httpGet.port | string | `"http"` | Port for webhook liveness probe. |
| webhook.readinessProbe.httpGet.path | string | `"/healthz"` | HTTP path for webhook readiness probe. |
| webhook.readinessProbe.httpGet.port | string | `"http"` | Port for webhook readiness probe. |
| webhook.initContainers | list | `[]` | Init containers for webhook deployment. Appended after `global.initContainers`. |
| webhook.service.annotations | object | `{}` | Service annotations for webhook deployment. |
| webhook.service.type | string | `"ClusterIP"` | Service type for webhook deployment. |
| webhook.service.port | int | `80` | Service port for webhook deployment. |
| webhook.resources | object | `{}` | Set to `{}` to inherit from `global.resources`. |
| webhook.autoscaling.enabled | bool | `false` | Enable HPA for webhook deployment. |
| webhook.autoscaling.minReplicas | int | `1` | Minimum replicas for webhook HPA. |
| webhook.autoscaling.maxReplicas | int | `100` | Maximum replicas for webhook HPA. |
| webhook.autoscaling.targetCPUUtilizationPercentage | int | `80` | Target average CPU utilization (percent) for webhook HPA. |
| webhook.nodeSelector | object | `{}` | Pod node selector for webhook deployment. |
| webhook.tolerations | list | `[]` | Pod tolerations for webhook deployment. |
| webhook.affinity | object | `{}` | Pod affinity for webhook deployment. |
| webhook.extraVolumes | list | `[]` | Extra pod volumes for webhook pods. |
| webhook.extraVolumeMounts | list | `[]` | Extra volume mounts for webhook pods. |
| webhook.terminationGracePeriodSeconds | int | `30` | Pod termination grace period in seconds for webhook deployment. |
| webhook.mcp.enabled | bool | `false` | Enable a dedicated single-replica webhook deployment for MCP traffic (`/mcp-server/`). |
| webhook.mcp.image | object | `{}` | Optional image override for MCP webhook workload. Supports `repository`, `tag`, and `pullPolicy`. Falls back to `webhook.image`, then `global.image`, then `image`. |
| webhook.mcp.userFolder | string | `""` | MCP webhook user data folder (`N8N_USER_FOLDER`) and mount path for MCP persistence volume. Falls back to `webhook.userFolder` when empty. |
| webhook.mcp.extraEnv | list | `[]` | Additional env vars for MCP webhook pods. Merged on top of `global.extraEnv` and `webhook.extraEnv`; same `name` overrides. |
| webhook.mcp.envFromConfigMaps | list | `[]` | Additional ConfigMaps loaded via `envFrom` for MCP webhook pods. |
| webhook.mcp.envFromSecrets | list | `[]` | Additional Secrets loaded via `envFrom` for MCP webhook pods. |
| webhook.mcp.persistence | object | `{}` | Optional overrides for webhook persistence. Unset values inherit from `webhook.persistence`. |
| webhook.mcp.deploymentAnnotations | object | `{}` | Deployment annotations for MCP webhook deployment. |
| webhook.mcp.deploymentLabels | object | `{}` | Deployment labels for MCP webhook deployment. |
| webhook.mcp.podAnnotations | object | `{}` | Pod annotations for MCP webhook deployment. |
| webhook.mcp.podLabels | object | `{}` | Pod labels for MCP webhook deployment. |
| webhook.mcp.podSecurityContext | object | `{}` | Security context overrides for MCP webhook deployment. |
| webhook.mcp.securityContext | object | `{}` | Container security context overrides for MCP webhook deployment. |
| webhook.mcp.resources | object | `{}` | Pod resource overrides for MCP webhook deployment. |
| webhook.mcp.nodeSelector | object | `{}` | Scheduling overrides for MCP webhook deployment. |
| webhook.mcp.tolerations | list | `[]` | Pod tolerations for MCP webhook deployment. |
| webhook.mcp.affinity | object | `{}` | Pod affinity for MCP webhook deployment. |
| webhook.mcp.extraVolumes | list | `[]` | Extra pod volumes for MCP webhook pods. |
| webhook.mcp.extraVolumeMounts | list | `[]` | Extra volume mounts for MCP webhook pods. |
| webhook.mcp.service.annotations | object | `{}` | Service annotations for MCP webhook service. |
| webhook.mcp.service.type | string | `"ClusterIP"` | Service type for MCP webhook service. |
| webhook.mcp.service.port | int | `80` | Service port for MCP webhook service. |
| webhook.mcp.ingress.paths | list | `["/mcp-server/"]` | MCP paths that should be routed to the dedicated MCP webhook service. |
| webhook.mcp.ingress.pathType | string | `"Prefix"` | Path type for MCP ingress paths. |
| extraManifests | list | `[]` | Additional static Kubernetes manifests rendered with the chart. |
| extraTemplateManifests | list | `[]` | Additional templated manifests rendered with Helm context. |
| valkey | object | `{"enabled":false}` | Valkey dependency values. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
