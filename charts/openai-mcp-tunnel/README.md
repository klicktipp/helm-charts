# openai-mcp-tunnel

![Version: 0.1.1](https://img.shields.io/badge/Version-0.1.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.0.9](https://img.shields.io/badge/AppVersion-v0.0.9-informational?style=flat-square)

A Helm chart for running the OpenAI Secure MCP Tunnel client in Kubernetes.

**Homepage:** <https://github.com/klicktipp/helm-charts>
## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| vquie |  | <https://github.com/vquie> |
## Source Code

* <https://github.com/klicktipp/helm-charts>
* <https://github.com/openai/tunnel-client>

## Deployment Model

This chart deploys [`openai/tunnel-client`](https://github.com/openai/tunnel-client) as a dedicated Kubernetes Deployment for an MCP server that is already reachable from the pod network.

It is intentionally scoped to the dedicated-pod pattern described by OpenAI:

- no inbound firewall rule is required for the tunnel itself
- the pod needs outbound HTTPS access to `api.openai.com:443`
- the pod also needs private reachability to the configured `MCP_SERVER_URL`, or a local stdio command via `MCP_COMMAND`

## Security Defaults

The chart ships with restrictive defaults suitable for production hardening:

- non-root execution with all Linux capabilities dropped
- `RuntimeDefault` seccomp profile
- read-only root filesystem with a dedicated `/tmp` `emptyDir`
- ServiceAccount token mounting disabled
- optional NetworkPolicy enabled by default
- admin UI remote access disabled by default

Two runtime inputs are always required:

- `controlPlane.tunnelId`
- a Secret-backed `CONTROL_PLANE_API_KEY` via `credentials.existingSecretName` or `credentials.createSecret=true`

The control-plane host override is optional:

- leave `controlPlane.baseUrl` empty for the normal OpenAI default
- set `controlPlane.baseUrl` only when you use a custom gateway host
- set `controlPlane.urlPath` when that gateway expects a prefix before `/v1/...`, for example `/workspace/dev/us`

## MCP Upstream Modes

The chart supports exactly one `main` MCP binding:

- `mcp.serverUrl` for a private Streamable HTTP MCP server reachable from the cluster
- `mcp.command` for a stdio MCP command started inside the container
- automatic fallback to the built-in stub MCP when neither `mcp.serverUrl` nor `mcp.command` is set
- `mcp.bootstrap.enabled=true` if you want that stub mode to be explicit in values

For Kubernetes production use, `mcp.serverUrl` is the safer default. OpenAI documents that stdio transport does not support MCP sessions, and multi-replica active-active behavior only works when the upstream is stateless or session-aware.

The bootstrap stub is useful only as a first-step bring-up mechanism. It lets ChatGPT connect to the tunnel, but it does not expose your real MCP tools. Switch to `mcp.serverUrl` or `mcp.command` once the backend exists.

## Internal MCP Authentication

For internal MCP servers that require static technical authentication, prefer the dedicated Secret-backed header settings instead of raw `extraEnv`:

- `mcp.auth.extraHeaders` for normal MCP HTTP requests
- `mcp.auth.discoveryExtraHeaders` for startup probes, OAuth discovery, and MCP initialize probing

The expected secret values are complete header values. For a bearer token, store the full string such as `Bearer eyJ...` in a secret key, then map the header name to that key.

Example:

```yaml
mcp:
  serverUrl: https://internal-mcp.example.local/mcp
  auth:
    extraHeaders:
      existingSecretName: internal-mcp-auth
      headers:
        Authorization: authorization
```

If the MCP also requires auth during discovery or initialize probing, mirror the same mapping under `mcp.auth.discoveryExtraHeaders`.

## Production Notes

For production rollouts, prefer one of these image supply-chain patterns:

- pin `image.digest` against a vetted mirror in your own registry
- or mirror the published `openai/tunnel-client` image into an internal registry and override `image.registry` / `image.repository`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` | Number of tunnel-client pods to run. |
| image | object | `{"digest":"","pullPolicy":"IfNotPresent","registry":"ghcr.io","repository":"klicktipp/openai-tunnel-client","tag":""}` | Container image configuration for `openai/tunnel-client`. |
| image.registry | string | `"ghcr.io"` | Optional image registry prefix. |
| image.repository | string | `"klicktipp/openai-tunnel-client"` | Image repository name. |
| image.tag | string | `""` | Image tag. When empty, the chart appVersion is used. |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy. |
| image.digest | string | `""` | Optional image digest overriding the tag-based reference. |
| imagePullSecrets | list | `[]` | Image pull secrets for the pod. |
| nameOverride | string | `""` | Partially override generated resource names. |
| fullnameOverride | string | `""` | Fully override generated resource names. |
| namespaceOverride | string | `""` | Override the namespace used for namespaced resources. |
| serviceAccount | object | `{"annotations":{},"automount":false,"create":true,"name":""}` | ServiceAccount configuration. |
| serviceAccount.create | bool | `true` | Create a dedicated ServiceAccount. |
| serviceAccount.automount | bool | `false` | Mount the ServiceAccount token into the pod. |
| serviceAccount.annotations | object | `{}` | ServiceAccount annotations. |
| serviceAccount.name | string | `""` | Existing ServiceAccount name to use. When empty, a name is generated. |
| podAnnotations | object | `{}` | Extra annotations added to the pod template. |
| podLabels | object | `{}` | Extra labels added to the pod template. |
| podSecurityContext | object | `{"fsGroup":65532,"fsGroupChangePolicy":"OnRootMismatch"}` | Pod-level security context. |
| podSecurityContext.fsGroup | int | `65532` | Filesystem group applied to mounted volumes. |
| podSecurityContext.fsGroupChangePolicy | string | `"OnRootMismatch"` | Change policy for fsGroup ownership. |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsGroup":65532,"runAsNonRoot":true,"runAsUser":65532,"seccompProfile":{"type":"RuntimeDefault"}}` | Container-level security context. |
| securityContext.runAsNonRoot | bool | `true` | Run the container without root privileges. |
| securityContext.runAsUser | int | `65532` | Numeric user ID for the container process. |
| securityContext.runAsGroup | int | `65532` | Numeric group ID for the container process. |
| securityContext.allowPrivilegeEscalation | bool | `false` | Prevent privilege escalation. |
| securityContext.readOnlyRootFilesystem | bool | `true` | Keep the root filesystem read-only. |
| securityContext.capabilities.drop | list | `["ALL"]` | Linux capabilities to drop. |
| securityContext.seccompProfile.type | string | `"RuntimeDefault"` | Seccomp profile type. |
| service | object | `{"annotations":{},"enabled":true,"port":8080,"type":"ClusterIP"}` | Service configuration for health, readiness, metrics, and optional UI access. |
| service.enabled | bool | `true` | Create a ClusterIP Service for the admin/health port. |
| service.type | string | `"ClusterIP"` | Kubernetes Service type. |
| service.port | int | `8080` | Service port exposed by the pod. |
| service.annotations | object | `{}` | Annotations added to the Service. |
| podDisruptionBudget | object | `{"enabled":true,"maxUnavailable":"","minAvailable":1}` | PodDisruptionBudget settings. |
| podDisruptionBudget.enabled | bool | `true` | Create a PodDisruptionBudget. |
| podDisruptionBudget.minAvailable | int | `1` | Minimum number/percentage of pods that should remain available. |
| podDisruptionBudget.maxUnavailable | string | `""` | Maximum number/percentage of pods that may be unavailable. |
| resources | object | `{"limits":{"memory":"512Mi"},"requests":{"cpu":"100m","memory":"128Mi"}}` | CPU and memory requests/limits for the container. |
| credentials | object | `{"apiKey":"","createSecret":false,"existingSecretName":"","secretKey":"control-plane-api-key"}` | Secret-backed control plane credentials. |
| credentials.createSecret | bool | `false` | Create a Secret from values in this chart instead of referencing an existing one. |
| credentials.existingSecretName | string | `""` | Existing Secret name containing the runtime API key. |
| credentials.secretKey | string | `"control-plane-api-key"` | Secret key containing the runtime API key. |
| credentials.apiKey | string | `""` | Runtime API key value written to the generated Secret. |
| controlPlane | object | `{"baseUrl":"","tunnelId":"","urlPath":""}` | OpenAI control plane settings. |
| controlPlane.tunnelId | string | `""` | Tunnel ID created in the OpenAI tunnels management UI or API. |
| controlPlane.baseUrl | string | `""` | Optional override for the control plane base URL. Leave empty to let `tunnel-client` use its built-in default (`https://api.openai.com`). |
| controlPlane.urlPath | string | `""` | Optional URL path prefix inserted before `/v1/...` routes, for example `/workspace/dev/us` behind an enterprise gateway. |
| mcp | object | `{"auth":{"discoveryExtraHeaders":{"createSecret":false,"existingSecretName":"","headers":{},"values":{}},"extraHeaders":{"createSecret":false,"existingSecretName":"","headers":{},"values":{}}},"bootstrap":{"enabled":false},"command":"","connectionMaxTTL":"10m","maxConcurrentRequests":10,"serverUrl":""}` | Upstream MCP configuration. Set either `serverUrl` or `command`. |
| mcp.bootstrap.enabled | bool | `false` | Start `tunnel-client` with the built-in stub MCP so the tunnel can come up before a real MCP backend is available. When `mcp.serverUrl` and `mcp.command` are both empty, the chart falls back to this stub automatically. |
| mcp.serverUrl | string | `""` | URL of the private MCP server reachable from the pod. |
| mcp.command | string | `""` | Command to launch a local stdio MCP server. `stdio` does not support MCP sessions. |
| mcp.auth.extraHeaders.existingSecretName | string | `""` | Existing Secret whose keys contain complete header values such as `Bearer ...`. |
| mcp.auth.extraHeaders.createSecret | bool | `false` | Create the Secret from values in this chart. |
| mcp.auth.extraHeaders.values | object | `{}` | Secret data written when `createSecret=true`. Each key becomes one mounted file. |
| mcp.auth.discoveryExtraHeaders.existingSecretName | string | `""` | Existing Secret whose keys contain complete discovery/probe header values. |
| mcp.auth.discoveryExtraHeaders.createSecret | bool | `false` | Create the Secret from values in this chart. |
| mcp.auth.discoveryExtraHeaders.values | object | `{}` | Secret data written when `createSecret=true`. Each key becomes one mounted file. |
| mcp.connectionMaxTTL | string | `"10m"` | Maximum lifetime of an upstream MCP connection. |
| mcp.maxConcurrentRequests | int | `10` | Maximum number of concurrent upstream MCP requests. |
| log | object | `{"format":"json","level":"info"}` | Runtime logging configuration. |
| log.level | string | `"info"` | Tunnel client log level. |
| log.format | string | `"json"` | Tunnel client log format. |
| health | object | `{"allowRemoteUI":false,"listenAddr":":8080","openWebUI":false}` | Health and admin UI settings. |
| health.listenAddr | string | `":8080"` | Listen address for `/healthz`, `/readyz`, `/metrics`, and `/ui`. |
| health.allowRemoteUI | bool | `false` | Allow remote clients to reach `/ui` and log endpoints. |
| health.openWebUI | bool | `false` | Open the embedded web UI automatically on startup. |
| extraArgs | list | `[]` | Additional command-line arguments appended to `tunnel-client run`. |
| extraEnv | list | `[]` | Additional environment variables appended to the container. |
| extraEnvFrom | list | `[]` | Additional envFrom entries appended to the container. |
| extraVolumeMounts | list | `[]` | Additional volume mounts appended to the container. |
| extraVolumes | list | `[]` | Additional volumes appended to the pod. |
| serviceMonitor | object | `{"enabled":false,"interval":"30s","labels":{},"path":"/metrics","scrapeTimeout":"10s"}` | Prometheus Operator ServiceMonitor configuration. |
| serviceMonitor.enabled | bool | `false` | Create a ServiceMonitor when the CRD is available. |
| serviceMonitor.path | string | `"/metrics"` | Metrics path scraped by Prometheus. |
| serviceMonitor.labels | object | `{}` | Additional labels added to the ServiceMonitor. |
| serviceMonitor.interval | string | `"30s"` | Prometheus scrape interval. |
| serviceMonitor.scrapeTimeout | string | `"10s"` | Prometheus scrape timeout. |
| livenessProbe | object | `{"failureThreshold":3,"httpGet":{"path":"/healthz","port":"http"},"initialDelaySeconds":5,"periodSeconds":10,"timeoutSeconds":5}` | Liveness probe configuration for the tunnel-client container. |
| livenessProbe.httpGet.path | string | `"/healthz"` | HTTP path used by the liveness probe. |
| livenessProbe.httpGet.port | string | `"http"` | Named port used by the liveness probe. |
| readinessProbe | object | `{"failureThreshold":3,"httpGet":{"path":"/readyz","port":"http"},"initialDelaySeconds":5,"periodSeconds":10,"timeoutSeconds":5}` | Readiness probe configuration for the tunnel-client container. |
| readinessProbe.httpGet.path | string | `"/readyz"` | HTTP path used by the readiness probe. |
| readinessProbe.httpGet.port | string | `"http"` | Named port used by the readiness probe. |
| networkPolicy | object | `{"allowDns":true,"allowHttpsEgress":true,"allowSameNamespaceIngress":true,"enabled":true,"extraEgress":[],"extraIngress":[]}` | NetworkPolicy configuration. Native Kubernetes NetworkPolicy cannot match `api.openai.com` by FQDN, so the default policy allows HTTPS egress on TCP/443 plus DNS and any user-specified extra rules. |
| networkPolicy.enabled | bool | `true` | Create a NetworkPolicy. |
| networkPolicy.allowSameNamespaceIngress | bool | `true` | Allow ingress to the admin/health port from pods in the same namespace. |
| networkPolicy.allowDns | bool | `true` | Allow outbound DNS lookups. |
| networkPolicy.allowHttpsEgress | bool | `true` | Allow outbound HTTPS on TCP/443 for OpenAI control-plane access and common HTTPS-based MCP targets. |
| networkPolicy.extraIngress | list | `[]` | Additional ingress rules appended to the NetworkPolicy spec. |
| networkPolicy.extraEgress | list | `[]` | Additional egress rules appended to the NetworkPolicy spec. |
| nodeSelector | object | `{}` | Node selector for pod scheduling. |
| tolerations | list | `[]` | Tolerations for pod scheduling. |
| affinity | object | `{}` | Affinity rules for pod scheduling. |
| topologySpreadConstraints | list | `[]` | Topology spread constraints for pod scheduling. |
