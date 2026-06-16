# csa-exporter

![Version: 0.1.1](https://img.shields.io/badge/Version-0.1.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.2.0](https://img.shields.io/badge/AppVersion-0.2.0-informational?style=flat-square)

A Helm chart for Kubernetes to scrape the CSA stats API.

**Homepage:** <https://github.com/klicktipp/helm-charts>
## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| vquie |  | <https://github.com/vquie> |
## Source Code

* <https://github.com/klicktipp/helm-charts>

## Authentication

The chart supports two authentication modes for the CSA API:

- Token-based auth with `CSA_API_TOKEN`
- Key-pair auth with `CSA_API_ID` and `CSA_API_SECRET`

The recommended production setup is to provide an existing Kubernetes Secret with the required keys and set `auth.existingSecretName`.

If you want the chart to create the Secret, set `auth.createSecret=true` and provide either:

- `auth.token` together with `auth.secretKeys.token`
- `auth.id` and `auth.secret` together with `auth.secretKeys.id` and `auth.secretKeys.secret`

When both auth variants are configured, token auth takes precedence.

## Runtime Configuration

The chart exposes optional runtime overrides through `env.*` values:

- `env.apiUrl` overrides the default CSA API endpoint used by the container image
- `env.apiTimeout` sets the outbound API timeout
- `env.logLevel` adjusts application logging

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` | Number of csa-exporter pods to run. |
| image | object | `{"digest":"","pullPolicy":"IfNotPresent","registry":"ghcr.io","repository":"klicktipp/csa-exporter","tag":""}` | Container image configuration. |
| image.registry | string | `"ghcr.io"` | Optional image registry prefix. |
| image.repository | string | `"klicktipp/csa-exporter"` | Image repository name. |
| image.tag | string | `""` | Image tag. When empty, the chart appVersion is used. |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy. |
| image.digest | string | `""` | Optional image digest overriding the tag-based reference. |
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
| auth | object | `{"createSecret":false,"existingSecretName":"","id":"","secret":"","secretKeys":{"id":"","secret":"","token":"csa-api-token"},"token":""}` | Authentication settings for the CSA API. |
| auth.createSecret | bool | `false` | Create a Secret from values in this chart instead of referencing an existing one. |
| auth.existingSecretName | string | `""` | Existing Secret name containing either token auth or id/secret auth keys. |
| auth.secretKeys | object | `{"id":"","secret":"","token":"csa-api-token"}` | Secret keys used to read credentials from the Secret. Token auth takes precedence. |
| auth.secretKeys.token | string | `"csa-api-token"` | Secret key containing the CSA API token. |
| auth.secretKeys.id | string | `""` | Secret key containing the CSA API client ID. |
| auth.secretKeys.secret | string | `""` | Secret key containing the CSA API client secret. |
| auth.token | string | `""` | Token value written to the generated Secret. Takes precedence over id/secret auth. |
| auth.id | string | `""` | Client ID value written to the generated Secret when using key-pair auth. |
| auth.secret | string | `""` | Client secret value written to the generated Secret when using key-pair auth. |
| env | object | `{"apiTimeout":"","apiUrl":"","logLevel":""}` | Optional runtime environment overrides passed to the container. |
| env.apiUrl | string | `""` | Override the CSA API base URL expected by the exporter image. |
| env.apiTimeout | string | `""` | Override the outbound CSA API timeout value. |
| env.logLevel | string | `""` | Override the exporter log level. |
| extraEnv | list | `[]` | Additional environment variables appended to the container. |
| extraVolumeMounts | list | `[]` | Additional volume mounts appended to the container. |
| extraVolumes | list | `[]` | Additional volumes appended to the pod. |
| serviceMonitor | object | `{"selfMonitor":{"additionalMetricsRelabels":{},"additionalRelabeling":[{"action":"labeldrop","regex":"(instance|pod)"}],"enabled":true,"interval":"1h","labels":{},"path":"/metrics","scrapeTimeout":"60s"}}` | Prometheus Operator ServiceMonitor configuration. |
| serviceMonitor.selfMonitor | object | `{"additionalMetricsRelabels":{},"additionalRelabeling":[{"action":"labeldrop","regex":"(instance|pod)"}],"enabled":true,"interval":"1h","labels":{},"path":"/metrics","scrapeTimeout":"60s"}` | Self-monitoring configuration for the exporter Service. |
| serviceMonitor.selfMonitor.enabled | bool | `true` | Create a ServiceMonitor when the CRD is available. |
| serviceMonitor.selfMonitor.path | string | `"/metrics"` | Metrics path scraped by Prometheus. |
| serviceMonitor.selfMonitor.additionalMetricsRelabels | object | `{}` | Extra metric relabeling rules for scraped metrics. |
| serviceMonitor.selfMonitor.additionalRelabeling | list | `[{"action":"labeldrop","regex":"(instance|pod)"}]` | Extra target relabeling rules for the ServiceMonitor endpoint. |
| serviceMonitor.selfMonitor.additionalRelabeling[0].regex | string | `"(instance|pod)"` | Regex used by the default relabeling rule. |
| serviceMonitor.selfMonitor.labels | object | `{}` | Additional labels added to the ServiceMonitor. |
| serviceMonitor.selfMonitor.interval | string | `"1h"` | Prometheus scrape interval. |
| serviceMonitor.selfMonitor.scrapeTimeout | string | `"60s"` | Prometheus scrape timeout. |
| livenessProbe | object | `{"httpGet":{"path":"/livez","port":"http"}}` | Liveness probe configuration for the exporter container. |
| livenessProbe.httpGet.path | string | `"/livez"` | HTTP path used by the liveness probe. |
| livenessProbe.httpGet.port | string | `"http"` | Named port used by the liveness probe. |
| readinessProbe | object | `{"httpGet":{"path":"/healthz","port":"http"}}` | Readiness probe configuration for the exporter container. |
| readinessProbe.httpGet.path | string | `"/healthz"` | HTTP path used by the readiness probe. |
| readinessProbe.httpGet.port | string | `"http"` | Named port used by the readiness probe. |
| nodeSelector | object | `{}` | Node selector for pod scheduling. |
| tolerations | list | `[]` | Tolerations for pod scheduling. |
| affinity | object | `{}` | Affinity rules for pod scheduling. |
