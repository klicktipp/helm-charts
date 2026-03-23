# redisinsight

![Version: 0.5.0](https://img.shields.io/badge/Version-0.5.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 3.2.0](https://img.shields.io/badge/AppVersion-3.2.0-informational?style=flat-square)

RedisInsight - The GUI for Redis

**Homepage:** <https://redis.io/insight/>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` | Number of replicas. |
| image | object | `{"pullPolicy":"IfNotPresent","repository":"redis/redisinsight","tag":""}` | Container image configuration. |
| image.repository | string | `"redis/redisinsight"` | Container image repository. |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy. |
| image.tag | string | `""` | Container image tag. |
| imagePullSecrets | list | `[]` | Image pull secrets. |
| nameOverride | string | `""` | Partially override generated resource names. |
| fullnameOverride | string | `""` | Fully override generated resource names. |
| serviceAccount | object | `{"annotations":{},"create":true,"name":""}` | ServiceAccount configuration. |
| serviceAccount.create | bool | `true` | Set serviceAccount.create. |
| serviceAccount.annotations | object | `{}` | Annotations map. |
| serviceAccount.name | string | `""` | Set serviceAccount.name. |
| podAnnotations | object | `{}` | Pod annotations. |
| podSecurityContext | object | `{}` | Pod security context. |
| securityContext | object | `{}` | Container security context. |
| service | object | `{"port":80,"type":"ClusterIP"}` | Service configuration. |
| service.type | string | `"ClusterIP"` | Type configuration value. |
| service.port | int | `80` | Network port. |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}],"tls":[]}` | Ingress configuration. |
| ingress.enabled | bool | `false` | Enable this feature. |
| ingress.className | string | `""` | Set ingress.className. |
| ingress.annotations | object | `{}` | Annotations map. |
| ingress.hosts | list | `[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}]` | Host definitions. |
| ingress.hosts[0].paths | list | `[{"path":"/","pathType":"ImplementationSpecific"}]` | Ingress path definitions. |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` | Ingress path type. |
| ingress.tls | list | `[]` | TLS configuration. |
| resources | object | `{}` | Container resource requests and limits. |
| autoscaling | object | `{"enabled":false,"maxReplicas":100,"minReplicas":1,"targetCPUUtilizationPercentage":80}` | Horizontal Pod Autoscaler settings. |
| autoscaling.enabled | bool | `false` | Enable this feature. |
| autoscaling.minReplicas | int | `1` | Minimum number of replicas. |
| autoscaling.maxReplicas | int | `100` | Maximum number of replicas. |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | Target average CPU utilization percentage. |
| nodeSelector | object | `{}` | Node selector for pod scheduling. |
| tolerations | list | `[]` | Tolerations for pod scheduling. |
| affinity | object | `{}` | Affinity rules for pod scheduling. |
| redisinsight | object | `{"data_dir":"/data","host":"0.0.0.0","port":5540,"pre_setup_path":"/data/import/databases.json","redis_servers":[]}` | Set redisinsight. |
| redisinsight.host | string | `"0.0.0.0"` | Hostname value. |
| redisinsight.port | int | `5540` | Network port. |
| redisinsight.data_dir | string | `"/data"` | Mount path for Redis Insight app data inside the container. |
| redisinsight.pre_setup_path | string | `"/data/import/databases.json"` | Path to the JSON file consumed by RI_PRE_SETUP_DATABASES_PATH. |
| redisinsight.redis_servers | list | `[]` | Configure redisinsight.redis_servers. |
