# proxysql

![Version: 1.3.0](https://img.shields.io/badge/Version-1.3.0-informational?style=flat-square) ![AppVersion: 3.0.8](https://img.shields.io/badge/AppVersion-3.0.8-informational?style=flat-square)

ProxySQL Helm chart for Kubernetes

**Homepage:** <https://www.proxysql.com/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Dysnix | <services@dysnix.com> |  |

## Source Code

* <https://github.com/dysnix/charts>
* <https://github.com/sysown/proxysql>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image | object | `{"pullPolicy":"IfNotPresent","registry":"docker.io","repository":"proxysql/proxysql","tag":null}` | Container image configuration. |
| image.registry | string | `"docker.io"` | Set image.registry. |
| image.repository | string | `"proxysql/proxysql"` | Container image repository. |
| image.tag | string | `nil` | Container image tag. |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy. |
| imagePullSecrets | list | `[]` | Image pull secrets. |
| nameOverride | string | `""` | Partially override generated resource names. |
| fullnameOverride | string | `""` | Fully override generated resource names. |
| serviceAccount | object | `{"create":true,"name":null}` | ServiceAccount configuration. |
| serviceAccount.create | bool | `true` | Set serviceAccount.create. |
| serviceAccount.name | string | `nil` | Set serviceAccount.name. |
| priorityClassName | string | `""` | Set priorityClassName. |
| podSecurityContext | object | `{"fsGroup":999,"runAsGroup":999,"runAsNonRoot":true,"runAsUser":999}` | Pod security context. |
| podSecurityContext.runAsNonRoot | bool | `true` | Set podSecurityContext.runAsNonRoot. |
| podSecurityContext.fsGroup | int | `999` | Set podSecurityContext.fsGroup. |
| podSecurityContext.runAsUser | int | `999` | Set podSecurityContext.runAsUser. |
| podSecurityContext.runAsGroup | int | `999` | Set podSecurityContext.runAsGroup. |
| securityContext | object | `{}` | Container security context. |
| service | object | `{"adminPort":6032,"annotations":{},"proxyPort":6033,"type":"ClusterIP","webPort":6080}` | Service configuration. |
| service.type | string | `"ClusterIP"` | Type configuration value. |
| service.proxyPort | int | `6033` | Set service.proxyPort. |
| service.adminPort | int | `6032` | Set service.adminPort. |
| service.webPort | int | `6080` | Set service.webPort. |
| service.annotations | object | `{}` | Annotations map. |
| resources | object | `{}` | Container resource requests and limits. |
| nodeSelector | object | `{}` | Node selector for pod scheduling. |
| tolerations | list | `[]` | Tolerations for pod scheduling. |
| affinity | object | `{}` | Affinity rules for pod scheduling. |
| podAntiAffinity | object | `{"enabled":false}` | Set podAntiAffinity. |
| podAntiAffinity.enabled | bool | `false` | Enable this feature. |
| commonAnnotations | object | `{}` | Configure commonAnnotations. |
| commonLabels | object | `{}` | Configure commonLabels. |
| podAnnotations | object | `{}` | Pod annotations. |
| podLabels | object | `{}` | Pod labels. |
| podDisruptionBudget | object | `{}` | Set podDisruptionBudget. |
| startupProbe | object | `{"enabled":false,"failureThreshold":10,"initialDelaySeconds":5,"periodSeconds":3,"successThreshold":1,"timeoutSeconds":1}` | Startup probe configuration. |
| startupProbe.enabled | bool | `false` | Enable this feature. |
| startupProbe.initialDelaySeconds | int | `5` | Configure startupProbe.initialDelaySeconds. |
| startupProbe.periodSeconds | int | `3` | Configure startupProbe.periodSeconds. |
| startupProbe.timeoutSeconds | int | `1` | Configure startupProbe.timeoutSeconds. |
| startupProbe.failureThreshold | int | `10` | Set startupProbe.failureThreshold. |
| startupProbe.successThreshold | int | `1` | Set startupProbe.successThreshold. |
| readinessProbe | object | `{"enabled":false,"failureThreshold":60,"initialDelaySeconds":0,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":5}` | Readiness probe configuration. |
| readinessProbe.enabled | bool | `false` | Enable this feature. |
| readinessProbe.initialDelaySeconds | int | `0` | Configure readinessProbe.initialDelaySeconds. |
| readinessProbe.periodSeconds | int | `10` | Configure readinessProbe.periodSeconds. |
| readinessProbe.timeoutSeconds | int | `5` | Configure readinessProbe.timeoutSeconds. |
| readinessProbe.failureThreshold | int | `60` | Set readinessProbe.failureThreshold. |
| readinessProbe.successThreshold | int | `1` | Set readinessProbe.successThreshold. |
| livenessProbe | object | `{"enabled":false,"failureThreshold":3,"initialDelaySeconds":5,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":5}` | Liveness probe configuration. |
| livenessProbe.enabled | bool | `false` | Enable this feature. |
| livenessProbe.initialDelaySeconds | int | `5` | Configure livenessProbe.initialDelaySeconds. |
| livenessProbe.periodSeconds | int | `10` | Configure livenessProbe.periodSeconds. |
| livenessProbe.timeoutSeconds | int | `5` | Configure livenessProbe.timeoutSeconds. |
| livenessProbe.failureThreshold | int | `3` | Set livenessProbe.failureThreshold. |
| livenessProbe.successThreshold | int | `1` | Set livenessProbe.successThreshold. |
| ssl | object | `{"auto":true,"ca":"","ca_file":"ca.pem","cert":"","cert_file":"cert.pem","fromSecret":"","key":"","key_file":"key.pem","sslDir":"/etc/proxysql"}` | Set ssl. |
| ssl.auto | bool | `true` | Set ssl.auto. |
| ssl.ca | string | `""` | Set ssl.ca. |
| ssl.cert | string | `""` | Set ssl.cert. |
| ssl.key | string | `""` | Set ssl.key. |
| ssl.sslDir | string | `"/etc/proxysql"` | Set ssl.sslDir. |
| ssl.ca_file | string | `"ca.pem"` | Set ssl.ca_file. |
| ssl.cert_file | string | `"cert.pem"` | Set ssl.cert_file. |
| ssl.key_file | string | `"key.pem"` | Set ssl.key_file. |
| ssl.fromSecret | string | `""` | Set ssl.fromSecret. |
| secret | object | `{"admin_password":"proxysql","admin_user":"proxysql-admin"}` | Component secret configuration map. |
| secret.admin_user | string | `"proxysql-admin"` | Set secret.admin_user. |
| secret.admin_password | string | `"proxysql"` | Set secret.admin_password. |
| admin_variables | object | `{"debug":false}` | Configure admin_variables. |
| admin_variables.debug | bool | `false` | Set admin_variables.debug. |
| mysql_variables | object | `{"default_query_delay":0,"default_query_timeout":3600000,"max_connections":2048,"monitor_enabled":false,"threads":4}` | Configure mysql_variables. |
| mysql_variables.threads | int | `4` | Configure mysql_variables.threads. |
| mysql_variables.max_connections | int | `2048` | Configure mysql_variables.max_connections. |
| mysql_variables.default_query_delay | int | `0` | Set mysql_variables.default_query_delay. |
| mysql_variables.default_query_timeout | int | `3600000` | Set mysql_variables.default_query_timeout. |
| mysql_variables.monitor_enabled | bool | `false` | Set mysql_variables.monitor_enabled. |
| mysql_users | string | `nil` | Configure mysql_users. |
| mysql_servers | string | `nil` | Configure mysql_servers. |
| mysql_query_rules | string | `nil` | Configure mysql_query_rules. |
| use_default_proxysql_servers | bool | `true` | Configure use_default_proxysql_servers. |
| additional_proxysql_servers | string | `nil` | Configure additional_proxysql_servers. |
| proxysql_cluster | object | `{"core":{"enabled":true,"exit_on_error":false,"podDisruptionBudget":{},"priorityClassName":"","replicas":3,"service":{"name":""},"statefullset":{"affinity":{},"minReadySeconds":0,"nodeSelector":{},"podAnnotations":{},"resources":{},"tolerations":[],"updateStrategy":{"type":"RollingUpdate"}}},"enabled":false,"healthcheck":{"diff_check_limit":10,"kill_if_healthcheck_failed":true,"livenessCommand":["/bin/sh","-c","/usr/local/bin/proxysql_cluster_healthcheck.sh liveness"],"psql_host":"127.0.0.1","psql_host_port":null,"psql_pass":null,"psql_user":null,"readinessCommand":["/bin/sh","-c","/usr/local/bin/proxysql_cluster_healthcheck.sh readiness"],"startupCommand":["/bin/sh","-c","/usr/local/bin/proxysql_cluster_healthcheck.sh started"],"verbose":false},"job":{"affinity":{},"backoffLimit":3,"enabled":true,"mysqlClientFlags":"--ssl=0","nodeSelector":{},"podAnnotations":{},"resources":{},"tolerations":[],"ttlSecondsAfterFinished":86400},"satellite":{"daemonset":{"affinity":{},"minReadySeconds":0,"nodeSelector":{},"podAnnotations":{},"resources":{},"tolerations":[],"updateStrategy":{"rollingUpdate":{"maxUnavailable":1},"type":"RollingUpdate"}},"deployment":{"minReadySeconds":0,"strategy":{"rollingUpdate":{"maxSurge":1,"maxUnavailable":0},"type":"RollingUpdate"}},"enabled":true,"exit_on_error":false,"kind":"DaemonSet","podDisruptionBudget":{},"priorityClassName":"","replicas":3,"service":{"name":""}},"secret":{"cluster_password":"proxysql","cluster_username":"proxysql-cluster"}}` | Set proxysql_cluster. |
| proxysql_cluster.enabled | bool | `false` | Enable this feature. |
| proxysql_cluster.secret | object | `{"cluster_password":"proxysql","cluster_username":"proxysql-cluster"}` | Component secret configuration map. |
| proxysql_cluster.secret.cluster_username | string | `"proxysql-cluster"` | Set proxysql_cluster.secret.cluster_username. |
| proxysql_cluster.secret.cluster_password | string | `"proxysql"` | Set proxysql_cluster.secret.cluster_password. |
| proxysql_cluster.core | object | `{"enabled":true,"exit_on_error":false,"podDisruptionBudget":{},"priorityClassName":"","replicas":3,"service":{"name":""},"statefullset":{"affinity":{},"minReadySeconds":0,"nodeSelector":{},"podAnnotations":{},"resources":{},"tolerations":[],"updateStrategy":{"type":"RollingUpdate"}}}` | Set proxysql_cluster.core. |
| proxysql_cluster.core.enabled | bool | `true` | Enable this feature. |
| proxysql_cluster.core.replicas | int | `3` | Configure proxysql_cluster.core.replicas. |
| proxysql_cluster.core.exit_on_error | bool | `false` | Set proxysql_cluster.core.exit_on_error. |
| proxysql_cluster.core.podDisruptionBudget | object | `{}` | Set proxysql_cluster.core.podDisruptionBudget. |
| proxysql_cluster.core.priorityClassName | string | `""` | Set proxysql_cluster.core.priorityClassName. |
| proxysql_cluster.core.statefullset | object | `{"affinity":{},"minReadySeconds":0,"nodeSelector":{},"podAnnotations":{},"resources":{},"tolerations":[],"updateStrategy":{"type":"RollingUpdate"}}` | Set proxysql_cluster.core.statefullset. |
| proxysql_cluster.core.statefullset.minReadySeconds | int | `0` | Set proxysql_cluster.core.statefullset.minReadySeconds. |
| proxysql_cluster.core.statefullset.nodeSelector | object | `{}` | Node selector for pod scheduling. |
| proxysql_cluster.core.statefullset.tolerations | list | `[]` | Tolerations for pod scheduling. |
| proxysql_cluster.core.statefullset.affinity | object | `{}` | Affinity rules for pod scheduling. |
| proxysql_cluster.core.statefullset.podAnnotations | object | `{}` | Pod annotations. |
| proxysql_cluster.core.statefullset.resources | object | `{}` | Container resource requests and limits. |
| proxysql_cluster.core.statefullset.updateStrategy | object | `{"type":"RollingUpdate"}` | StatefulSet update strategy. |
| proxysql_cluster.core.statefullset.updateStrategy.type | string | `"RollingUpdate"` | Set proxysql_cluster.core.statefullset.updateStrategy.type. |
| proxysql_cluster.core.service | object | `{"name":""}` | Service configuration. |
| proxysql_cluster.core.service.name | string | `""` | Set proxysql_cluster.core.service.name. |
| proxysql_cluster.satellite | object | `{"daemonset":{"affinity":{},"minReadySeconds":0,"nodeSelector":{},"podAnnotations":{},"resources":{},"tolerations":[],"updateStrategy":{"rollingUpdate":{"maxUnavailable":1},"type":"RollingUpdate"}},"deployment":{"minReadySeconds":0,"strategy":{"rollingUpdate":{"maxSurge":1,"maxUnavailable":0},"type":"RollingUpdate"}},"enabled":true,"exit_on_error":false,"kind":"DaemonSet","podDisruptionBudget":{},"priorityClassName":"","replicas":3,"service":{"name":""}}` | Set proxysql_cluster.satellite. |
| proxysql_cluster.satellite.kind | string | `"DaemonSet"` | Set proxysql_cluster.satellite.kind. |
| proxysql_cluster.satellite.enabled | bool | `true` | Enable this feature. |
| proxysql_cluster.satellite.replicas | int | `3` | Configure proxysql_cluster.satellite.replicas. |
| proxysql_cluster.satellite.exit_on_error | bool | `false` | Set proxysql_cluster.satellite.exit_on_error. |
| proxysql_cluster.satellite.podDisruptionBudget | object | `{}` | Set proxysql_cluster.satellite.podDisruptionBudget. |
| proxysql_cluster.satellite.priorityClassName | string | `""` | Set proxysql_cluster.satellite.priorityClassName. |
| proxysql_cluster.satellite.daemonset | object | `{"affinity":{},"minReadySeconds":0,"nodeSelector":{},"podAnnotations":{},"resources":{},"tolerations":[],"updateStrategy":{"rollingUpdate":{"maxUnavailable":1},"type":"RollingUpdate"}}` | Set proxysql_cluster.satellite.daemonset. |
| proxysql_cluster.satellite.daemonset.minReadySeconds | int | `0` | Set proxysql_cluster.satellite.daemonset.minReadySeconds. |
| proxysql_cluster.satellite.daemonset.updateStrategy | object | `{"rollingUpdate":{"maxUnavailable":1},"type":"RollingUpdate"}` | DaemonSet update strategy. |
| proxysql_cluster.satellite.daemonset.updateStrategy.type | string | `"RollingUpdate"` | Set proxysql_cluster.satellite.daemonset.updateStrategy.type. |
| proxysql_cluster.satellite.daemonset.updateStrategy.rollingUpdate.maxUnavailable | int | `1` | Update one pod at a time during upgrades. |
| proxysql_cluster.satellite.daemonset.nodeSelector | object | `{}` | Node selector for pod scheduling. |
| proxysql_cluster.satellite.daemonset.tolerations | list | `[]` | Tolerations for pod scheduling. |
| proxysql_cluster.satellite.daemonset.affinity | object | `{}` | Affinity rules for pod scheduling. |
| proxysql_cluster.satellite.daemonset.podAnnotations | object | `{}` | Pod annotations. |
| proxysql_cluster.satellite.daemonset.resources | object | `{}` | Container resource requests and limits. |
| proxysql_cluster.satellite.deployment | object | `{"minReadySeconds":0,"strategy":{"rollingUpdate":{"maxSurge":1,"maxUnavailable":0},"type":"RollingUpdate"}}` | Set proxysql_cluster.satellite.deployment. |
| proxysql_cluster.satellite.deployment.minReadySeconds | int | `0` | Set proxysql_cluster.satellite.deployment.minReadySeconds. |
| proxysql_cluster.satellite.deployment.strategy | object | `{"rollingUpdate":{"maxSurge":1,"maxUnavailable":0},"type":"RollingUpdate"}` | Deployment update strategy. |
| proxysql_cluster.satellite.deployment.strategy.type | string | `"RollingUpdate"` | Set proxysql_cluster.satellite.deployment.strategy.type. |
| proxysql_cluster.satellite.deployment.strategy.rollingUpdate.maxUnavailable | int | `0` | Do not take existing pods down before replacement is ready. |
| proxysql_cluster.satellite.deployment.strategy.rollingUpdate.maxSurge | int | `1` | Allow one extra pod during upgrades. |
| proxysql_cluster.satellite.service | object | `{"name":""}` | Service configuration. |
| proxysql_cluster.satellite.service.name | string | `""` | Set proxysql_cluster.satellite.service.name. |
| proxysql_cluster.job | object | `{"affinity":{},"backoffLimit":3,"enabled":true,"mysqlClientFlags":"--ssl=0","nodeSelector":{},"podAnnotations":{},"resources":{},"tolerations":[],"ttlSecondsAfterFinished":86400}` | Set proxysql_cluster.job. |
| proxysql_cluster.job.enabled | bool | `true` | Enable this feature. |
| proxysql_cluster.job.backoffLimit | int | `3` | Set proxysql_cluster.job.backoffLimit. |
| proxysql_cluster.job.ttlSecondsAfterFinished | int | `86400` | Set proxysql_cluster.job.ttlSecondsAfterFinished. |
| proxysql_cluster.job.mysqlClientFlags | string | `"--ssl=0"` | Extra mysql client flags used by init-cluster job. Default disables TLS for internal admin connection to avoid certificate trust errors. |
| proxysql_cluster.job.tolerations | list | `[]` | Tolerations for pod scheduling. |
| proxysql_cluster.job.affinity | object | `{}` | Affinity rules for pod scheduling. |
| proxysql_cluster.job.podAnnotations | object | `{}` | Pod annotations. |
| proxysql_cluster.job.resources | object | `{}` | Container resource requests and limits. |
| proxysql_cluster.healthcheck | object | `{"diff_check_limit":10,"kill_if_healthcheck_failed":true,"livenessCommand":["/bin/sh","-c","/usr/local/bin/proxysql_cluster_healthcheck.sh liveness"],"psql_host":"127.0.0.1","psql_host_port":null,"psql_pass":null,"psql_user":null,"readinessCommand":["/bin/sh","-c","/usr/local/bin/proxysql_cluster_healthcheck.sh readiness"],"startupCommand":["/bin/sh","-c","/usr/local/bin/proxysql_cluster_healthcheck.sh started"],"verbose":false}` | Set proxysql_cluster.healthcheck. |
| proxysql_cluster.healthcheck.psql_user | string | `nil` | Set proxysql_cluster.healthcheck.psql_user. |
| proxysql_cluster.healthcheck.psql_pass | string | `nil` | Configure proxysql_cluster.healthcheck.psql_pass. |
| proxysql_cluster.healthcheck.psql_host | string | `"127.0.0.1"` | Set proxysql_cluster.healthcheck.psql_host. |
| proxysql_cluster.healthcheck.psql_host_port | string | `nil` | Set proxysql_cluster.healthcheck.psql_host_port. |
| proxysql_cluster.healthcheck.diff_check_limit | int | `10` | Set proxysql_cluster.healthcheck.diff_check_limit. |
| proxysql_cluster.healthcheck.kill_if_healthcheck_failed | bool | `true` | Set proxysql_cluster.healthcheck.kill_if_healthcheck_failed. |
| proxysql_cluster.healthcheck.verbose | bool | `false` | Set proxysql_cluster.healthcheck.verbose. |
| proxysql_cluster.healthcheck.startupCommand | list | `["/bin/sh","-c","/usr/local/bin/proxysql_cluster_healthcheck.sh started"]` | Override startup command. The default script writes one-line JSON status to `/tmp/proxysql_cluster_healthcheck_started.status`. By default, use `proxysql_cluster_healthcheck.sh started`. |
| proxysql_cluster.healthcheck.readinessCommand | list | `["/bin/sh","-c","/usr/local/bin/proxysql_cluster_healthcheck.sh readiness"]` | Override readiness command. The default script writes one-line JSON status to `/tmp/proxysql_cluster_healthcheck_readiness.status`. By default, use `proxysql_cluster_healthcheck.sh readiness`. This command should fail during graceful termination. |
| proxysql_cluster.healthcheck.livenessCommand | list | `["/bin/sh","-c","/usr/local/bin/proxysql_cluster_healthcheck.sh liveness"]` | Override liveness command. The default script writes one-line JSON status to `/tmp/proxysql_cluster_healthcheck_liveness.status`. By default, use `proxysql_cluster_healthcheck.sh liveness`. |
| debug | object | `{"sidecar":{"command":["/bin/sleep","infinity"],"enabled":false,"image":"mysql:debian","securityContext":{"runAsGroup":999,"runAsUser":999}}}` | Set debug. |
| debug.sidecar | object | `{"command":["/bin/sleep","infinity"],"enabled":false,"image":"mysql:debian","securityContext":{"runAsGroup":999,"runAsUser":999}}` | Set debug.sidecar. |
| debug.sidecar.enabled | bool | `false` | Enable this feature. |
| debug.sidecar.image | string | `"mysql:debian"` | Container image configuration. |
| debug.sidecar.command | list | `["/bin/sleep","infinity"]` | Override container command. |
| debug.sidecar.securityContext | object | `{"runAsGroup":999,"runAsUser":999}` | Container security context. |
| debug.sidecar.securityContext.runAsUser | int | `999` | Set debug.sidecar.securityContext.runAsUser. |
| debug.sidecar.securityContext.runAsGroup | int | `999` | Set debug.sidecar.securityContext.runAsGroup. |
| terminationGracePeriodSeconds | int | `60` | Termination grace period in seconds. |
| lifecycle | object | `{"preStop":{"connection_drain_timeout":0,"enabled":true,"poll_interval_seconds":1,"sleep_time":15}}` | Pod lifecycle hooks configuration. |
| lifecycle.preStop.enabled | bool | `true` | Enable preStop drain hook. |
| lifecycle.preStop.sleep_time | int | `15` | Initial delay before checking active client connections. |
| lifecycle.preStop.connection_drain_timeout | int | `0` | Maximum seconds to wait for active client connections to drain. Set to 0 to wait indefinitely (bounded by `terminationGracePeriodSeconds`). |
| lifecycle.preStop.poll_interval_seconds | int | `1` | Poll interval in seconds while waiting for active connections. |
| topologySpreadConstraints | string | `nil` | Configure topologySpreadConstraints. |
