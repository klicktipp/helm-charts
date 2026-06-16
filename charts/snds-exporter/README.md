# snds-exporter

![Version: 0.2.0](https://img.shields.io/badge/Version-0.2.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.2.2](https://img.shields.io/badge/AppVersion-0.2.2-informational?style=flat-square)

A Helm chart for running the snds-exporter with OAuth token files in Kubernetes.

**Homepage:** <https://github.com/klicktipp/helm-charts>
## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| vquie |  | <https://github.com/vquie> |
## Source Code

* <https://github.com/klicktipp/helm-charts>

## Authentication Model

The chart expects two pieces of token state in the mounted Secret:

- `access-token`: the current OAuth bearer token used for SNDS API requests
- `token-cache.json`: the cached refresh-token state used for silent token renewal

The exporter can renew tokens headlessly only when both files exist and the initial interactive login was completed with refresh-token cache creation. If `token-cache.json` is missing or no longer usable, silent refresh cannot work and a human must perform the login flow again.

## Initial Login

After the first pod start, you must perform one manual interactive login to seed the SNDS access token and refresh-token cache. The exporter cannot complete the initial OAuth authorization code flow on its own.

The chart bootstraps the token Secret empty by default so the pod can start before login is completed. Until valid token state exists, `/metrics` will log authentication errors.

The recommended Kubernetes bootstrap flow is:

1. Deploy the chart and wait until the pod is running.
2. Run the interactive login inside the running pod:

```sh
kubectl exec -it deploy/snds-exporter -- python3 /usr/local/bin/snds_token_helper.py
```

3. Open the Microsoft login URL printed by the helper in your local browser, complete the login, then paste the final redirect URL back into the terminal.
4. Restart the workload once so the exporter reliably reopens the updated Secret contents:

```sh
kubectl rollout restart deployment/snds-exporter
```

If your release name or namespace differs, adjust the resource name accordingly, for example:

```sh
kubectl -n monitoring exec -it deploy/my-snds-exporter -- python3 /usr/local/bin/snds_token_helper.py
kubectl -n monitoring rollout restart deployment/my-snds-exporter
```

## Secret Persistence

When `auth.refresh.patchKubernetesSecret.enabled=true`, the exporter updates the Kubernetes Secret after a successful token refresh so the latest token state survives pod restarts.

By default, the exporter patches the same Secret it mounts for startup token files. You can override the target Secret name, namespace, and keys with:

- `auth.refresh.patchKubernetesSecret.secretName`
- `auth.refresh.patchKubernetesSecret.secretNamespace`
- `auth.refresh.patchKubernetesSecret.accessTokenKey`
- `auth.refresh.patchKubernetesSecret.tokenCacheKey`

The chart creates the required Role and RoleBinding for this Secret patch flow when secret patching is enabled.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` | Number of snds-exporter pods to run. |
| image | object | `{"pullPolicy":"IfNotPresent","registry":"ghcr.io/klicktipp","repository":"snds-exporter","tag":""}` | Container image configuration. |
| image.registry | string | `"ghcr.io/klicktipp"` | Optional image registry prefix. |
| image.repository | string | `"snds-exporter"` | Image repository name. |
| image.tag | string | `""` | Image tag. When empty, the chart appVersion is used. |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy. |
| imagePullSecrets | list | `[]` | Image pull secrets for the pod. |
| nameOverride | string | `""` | Partially override generated resource names. |
| fullnameOverride | string | `""` | Fully override generated resource names. |
| namespaceOverride | string | `""` | Override the namespace used for namespaced resources. |
| serviceAccount | object | `{"annotations":{},"automount":true,"create":true,"name":""}` | ServiceAccount configuration. |
| serviceAccount.create | bool | `true` | Create a dedicated ServiceAccount. |
| serviceAccount.automount | bool | `true` | Mount the ServiceAccount token into the pod. |
| serviceAccount.annotations | object | `{}` | ServiceAccount annotations. |
| serviceAccount.name | string | `""` | Existing ServiceAccount name to use. When empty, a name is generated. |
| podAnnotations | object | `{}` | Extra annotations added to the pod template. |
| podLabels | object | `{}` | Extra labels added to the pod template. |
| podSecurityContext | object | `{}` | Pod-level security context. |
| securityContext | object | `{}` | Container-level security context. |
| service | object | `{"port":9100,"type":"ClusterIP"}` | Service configuration. |
| service.type | string | `"ClusterIP"` | Kubernetes Service type. |
| service.port | int | `9100` | Metrics port exposed by the Service and container. |
| resources | object | `{}` | CPU and memory requests/limits for the container. |
| auth | object | `{"mountPath":"/var/run/snds-exporter","refresh":{"beforeSeconds":600,"enabled":true,"patchKubernetesSecret":{"accessTokenKey":"access-token","enabled":true,"secretName":"","secretNamespace":"","tokenCacheKey":"token-cache.json"}},"secret":{"accessToken":"","accessTokenKey":"access-token","annotations":{},"create":true,"name":"","tokenCache":"","tokenCacheKey":"token-cache.json"}}` | Authentication and token refresh settings. |
| auth.mountPath | string | `"/var/run/snds-exporter"` | Mount path for SNDS token files inside the container. |
| auth.secret | object | `{"accessToken":"","accessTokenKey":"access-token","annotations":{},"create":true,"name":"","tokenCache":"","tokenCacheKey":"token-cache.json"}` | Secret configuration for access token and cache files. |
| auth.secret.create | bool | `true` | Create the auth Secret from values in this chart. |
| auth.secret.name | string | `""` | Existing Secret name. When empty, a name is generated. |
| auth.secret.accessTokenKey | string | `"access-token"` | Secret key containing the access token. |
| auth.secret.tokenCacheKey | string | `"token-cache.json"` | Secret key containing the token cache file. |
| auth.secret.annotations | object | `{}` | Annotations added to the generated Secret. |
| auth.secret.accessToken | string | `""` | Access token content written to the generated Secret. |
| auth.secret.tokenCache | string | `""` | Token cache JSON content written to the generated Secret. |
| auth.refresh | object | `{"beforeSeconds":600,"enabled":true,"patchKubernetesSecret":{"accessTokenKey":"access-token","enabled":true,"secretName":"","secretNamespace":"","tokenCacheKey":"token-cache.json"}}` | Token refresh integration settings. |
| auth.refresh.enabled | bool | `true` | Enable automatic OAuth token refresh inside the exporter. |
| auth.refresh.beforeSeconds | int | `600` | Refresh the token this many seconds before expiry. |
| auth.refresh.patchKubernetesSecret | object | `{"accessTokenKey":"access-token","enabled":true,"secretName":"","secretNamespace":"","tokenCacheKey":"token-cache.json"}` | Kubernetes Secret patch settings used after token refresh. |
| auth.refresh.patchKubernetesSecret.enabled | bool | `true` | Allow the exporter to patch the Secret after refreshing tokens. |
| auth.refresh.patchKubernetesSecret.secretName | string | `""` | Secret name to patch. Defaults to the auth Secret name. |
| auth.refresh.patchKubernetesSecret.secretNamespace | string | `""` | Secret namespace to patch. Defaults to the release namespace. |
| auth.refresh.patchKubernetesSecret.accessTokenKey | string | `"access-token"` | Secret key updated with the refreshed access token. |
| auth.refresh.patchKubernetesSecret.tokenCacheKey | string | `"token-cache.json"` | Secret key updated with the refreshed token cache content. |
| exporter | object | `{"cacheSeconds":3600,"debugUnknownResponses":false,"requestTimeout":10,"restApiLookbackDays":3,"restApiUrl":"https://substrate.office.com/ip-domain-management-snds/api/report/data","statusApiUrl":"https://substrate.office.com/ip-domain-management-snds/api/report/status/ip","userAgent":"kt-snds-exporter/1.0","verifyTls":true}` | snds-exporter runtime configuration. |
| exporter.restApiUrl | string | `"https://substrate.office.com/ip-domain-management-snds/api/report/data"` | SNDS REST API endpoint returning report data. |
| exporter.statusApiUrl | string | `"https://substrate.office.com/ip-domain-management-snds/api/report/status/ip"` | SNDS status API endpoint returning IP status information. |
| exporter.restApiLookbackDays | int | `3` | Number of days requested from the report API. |
| exporter.requestTimeout | int | `10` | HTTP request timeout in seconds for SNDS API calls. |
| exporter.cacheSeconds | int | `3600` | Response cache duration in seconds. |
| exporter.verifyTls | bool | `true` | Verify TLS certificates for outbound HTTPS requests. |
| exporter.userAgent | string | `"kt-snds-exporter/1.0"` | Custom User-Agent header sent to SNDS APIs. |
| exporter.debugUnknownResponses | bool | `false` | Log unexpected API responses for debugging. |
| extraEnv | list | `[]` | Additional environment variables appended to the container. |
| extraVolumeMounts | list | `[]` | Additional volume mounts appended to the container. |
| extraVolumes | list | `[]` | Additional volumes appended to the pod. |
| serviceMonitor | object | `{"selfMonitor":{"additionalMetricsRelabels":{},"additionalRelabeling":[{"action":"labeldrop","regex":"(instance|pod)"}],"enabled":true,"interval":"1h","labels":{},"path":"/metrics","scrapeTimeout":"60s"}}` | Prometheus Operator ServiceMonitor configuration. |
| serviceMonitor.selfMonitor | object | `{"additionalMetricsRelabels":{},"additionalRelabeling":[{"action":"labeldrop","regex":"(instance|pod)"}],"enabled":true,"interval":"1h","labels":{},"path":"/metrics","scrapeTimeout":"60s"}` | Self-monitoring configuration for the exporter Service. |
| serviceMonitor.selfMonitor.enabled | bool | `true` | Create a ServiceMonitor when the CRD is available. |
| serviceMonitor.selfMonitor.path | string | `"/metrics"` | Metrics path scraped by Prometheus. |
| serviceMonitor.selfMonitor.additionalMetricsRelabels | object | `{}` | Extra metric relabeling rules for scraped metrics. |
| serviceMonitor.selfMonitor.additionalRelabeling | list | `[{"action":"labeldrop","regex":"(instance|pod)"}]` | Extra target relabeling rules for the ServiceMonitor endpoint. |
| serviceMonitor.selfMonitor.labels | object | `{}` | Additional labels added to the ServiceMonitor. |
| serviceMonitor.selfMonitor.interval | string | `"1h"` | Prometheus scrape interval. |
| serviceMonitor.selfMonitor.scrapeTimeout | string | `"60s"` | Prometheus scrape timeout. |
| livenessProbe | object | `{"httpGet":{"path":"/livez","port":"http"}}` | Liveness probe configuration for the exporter container. |
| readinessProbe | object | `{"httpGet":{"path":"/healthz","port":"http"}}` | Readiness probe configuration for the exporter container. |
| nodeSelector | object | `{}` | Node selector for pod scheduling. |
| tolerations | list | `[]` | Tolerations for pod scheduling. |
| affinity | object | `{}` | Affinity rules for pod scheduling. |

<!-- BEGIN AUTO EXAMPLES -->
<!-- END AUTO EXAMPLES -->
