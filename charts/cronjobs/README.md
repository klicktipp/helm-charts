# cronjobs

![Version: 2.0.1](https://img.shields.io/badge/Version-2.0.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: latest](https://img.shields.io/badge/AppVersion-latest-informational?style=flat-square)

A generic helm cronjob chart for kubernetes

**Homepage:** <https://github.com/klicktipp/helm-charts>

## Source Code

* <https://github.com/klicktipp/helm-charts>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | `""` | Partially override generated resource names. |
| fullnameOverride | string | `""` | Fully override generated resource names. |
| slugifyVolumeNamesV2 | bool | `false` | Use collision-free EFS PV/PVC naming (com.klicktipp.slugify-volume-name-v2). When enabled, PV names are globally unique and PVC names are namespace-unique by hashing the infix (chart + job name) to 8 hex chars while keeping the namespace/release prefix and EFS access-point ID verbatim. Disabled by default to preserve backward compatibility with existing PVs/PVCs. |
| imagePullSecrets | list | `[]` | Image pull secrets. |
| image | object | `{}` | Default container image settings for all jobs. Individual jobs can override these values. |
| secrets | object | `{}` | Configure secrets. |
| customConfigMap | string | `nil` | Set customConfigMap. |
| configMaps | object | `{}` | Configure configMaps. |
| secretEnvFrom | list | `[]` | Set secretEnvFrom. |
| env | object | `{}` | Environment variable entries. |
| timezone | string | `""` | Default time zone for all CronJobs. Individual jobs can override this value. |
| startupJitter | object | `{"enabled":false,"image":{"pullPolicy":"IfNotPresent","registry":"docker.io","repository":"bash","tag":"5.3"},"maxSeconds":60,"seed":"cronjobs-jitter"}` | Startup jitter settings for all jobs. Individual jobs can override these values. |
| startupJitter.enabled | bool | `false` | Enable startup jitter initContainer. |
| startupJitter.maxSeconds | int | `60` | Maximum startup delay in seconds. The effective delay is between 0 and this value. |
| startupJitter.seed | string | `"cronjobs-jitter"` | Seed prefix combined with namespace for pseudo-random delay generation. |
| startupJitter.image | object | `{"pullPolicy":"IfNotPresent","registry":"docker.io","repository":"bash","tag":"5.3"}` | Jitter initContainer image settings. |
| startupJitter.image.registry | string | `"docker.io"` | Container image registry. |
| startupJitter.image.repository | string | `"bash"` | Container image repository. |
| startupJitter.image.tag | string | `"5.3"` | Container image tag. |
| startupJitter.image.pullPolicy | string | `"IfNotPresent"` | Container image pull policy. |
| jobs | object | `{}` | Configure jobs. |
| serviceAccount | object | `{"annotations":{},"automount":true,"create":true,"name":""}` | ServiceAccount configuration. |
| serviceAccount.create | bool | `true` | Set serviceAccount.create. |
| serviceAccount.automount | bool | `true` | Set serviceAccount.automount. |
| serviceAccount.annotations | object | `{}` | Annotations map. |
| serviceAccount.name | string | `""` | Set serviceAccount.name. |
| rbac | object | `{"clusterRole":{"annotations":{},"create":false,"rules":[]},"create":false,"role":{"annotations":{},"create":false,"rules":[]}}` | Set rbac. |
| rbac.create | bool | `false` | Set rbac.create. |
| rbac.role | object | `{"annotations":{},"create":false,"rules":[]}` | Set rbac.role. |
| rbac.role.create | bool | `false` | Set rbac.role.create. |
| rbac.role.annotations | object | `{}` | Annotations map. |
| rbac.role.rules | list | `[]` | Configure rbac.role.rules. |
| rbac.clusterRole | object | `{"annotations":{},"create":false,"rules":[]}` | Set rbac.clusterRole. |
| rbac.clusterRole.create | bool | `false` | Set rbac.clusterRole.create. |
| rbac.clusterRole.annotations | object | `{}` | Annotations map. |
| rbac.clusterRole.rules | list | `[]` | Configure rbac.clusterRole.rules. |
| commonAnnotations | object | `{}` | Configure commonAnnotations. |
| commonLabels | object | `{}` | Configure commonLabels. |
| commonContainerName | string | `""` | Set commonContainerName. |
| podSecurityContext | object | `{}` | Pod security context. |
| securityContext | object | `{}` | Container security context. |
| resources | object | `{}` | Container resource requests and limits. |
| nodeSelector | object | `{}` | Node selector for pod scheduling. |
| tolerations | list | `[]` | Tolerations for pod scheduling. |
| affinity | object | `{}` | Affinity rules for pod scheduling. |
