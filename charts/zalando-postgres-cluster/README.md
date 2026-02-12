# zalando-postgres-cluster

![Version: 1.1.0](https://img.shields.io/badge/Version-1.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

Creates a postgres cluster using the Zalando Postgres operator and local storage

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| KlickTipp DevOps Team |  |  |

## Source Code

* <https://github.com/zalando/postgres-operator>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | `""` | Partially override generated resource names. |
| fullnameOverride | string | `""` | Fully override generated resource names. |
| serviceAccount | object | `{"annotations":{},"automount":true,"create":true,"name":""}` | ServiceAccount configuration. |
| serviceAccount.create | bool | `true` | Set serviceAccount.create. |
| serviceAccount.automount | bool | `true` | Set serviceAccount.automount. |
| serviceAccount.annotations | object | `{}` | Annotations map. |
| serviceAccount.name | string | `""` | Set serviceAccount.name. |
| postgres_cluster | object | `{"annotations":{},"backup":{"enabled":false,"retention":"7 days","schedule":"30 00 * * *"},"database":{"name":"app"},"enabled":true,"env":[],"expose":{"masterLoadBalancer":false,"replicaLoadBalancer":false},"instances":1,"labels":{},"name":"","nodeAffinity":{},"podServiceAccount":{"name":""},"pooler":{"enableMasterPoolerLoadBalancer":false,"enableReplicaConnectionPooler":false,"enableReplicaPoolerLoadBalancer":false,"enabled":false},"postgres":{"parameters":{},"version":"17"},"preparedDatabases":{},"priorityClassName":"","resources":{},"teamId":"app","tls":{"caFile":"","caSecretName":"","certificateFile":"tls.crt","createCertificate":false,"duration":"2160h","enabled":false,"issuerRef":{"group":"cert-manager.io","kind":"ClusterIssuer","name":""},"organization":"ACME INC.","privateKeyFile":"tls.key","renewBefore":"360h","secretName":""},"tolerations":[],"users":[],"volume":{"enabled":false,"size":"10Gi","storageClass":""},"wal":{"accessKeyId":null,"awsRegion":null,"backupNumToRetain":"3","backupSchedule":"0 10 * * *","enabled":false,"logS3Tags":true,"s3Bucket":null,"s3ScopePrefix":null,"secretAccessKey":null}}` | Set postgres_cluster. |
| postgres_cluster.enabled | bool | `true` | Enable this feature. |
| postgres_cluster.teamId | string | `"app"` | Set postgres_cluster.teamId. |
| postgres_cluster.name | string | `""` | Set postgres_cluster.name. |
| postgres_cluster.labels | object | `{}` | Labels map. |
| postgres_cluster.annotations | object | `{}` | Annotations map. |
| postgres_cluster.instances | int | `1` | Configure postgres_cluster.instances. |
| postgres_cluster.priorityClassName | string | `""` | Set postgres_cluster.priorityClassName. |
| postgres_cluster.postgres | object | `{"parameters":{},"version":"17"}` | Configure postgres_cluster.postgres. |
| postgres_cluster.postgres.version | string | `"17"` | Set postgres_cluster.postgres.version. |
| postgres_cluster.postgres.parameters | object | `{}` | Configure postgres_cluster.postgres.parameters. |
| postgres_cluster.database | object | `{"name":"app"}` | Set postgres_cluster.database. |
| postgres_cluster.database.name | string | `"app"` | Set postgres_cluster.database.name. |
| postgres_cluster.preparedDatabases | object | `{}` | Configure postgres_cluster.preparedDatabases. |
| postgres_cluster.users | list | `[]` | Configure postgres_cluster.users. |
| postgres_cluster.volume | object | `{"enabled":false,"size":"10Gi","storageClass":""}` | Set postgres_cluster.volume. |
| postgres_cluster.volume.enabled | bool | `false` | Enable this feature. |
| postgres_cluster.volume.size | string | `"10Gi"` | Storage size. |
| postgres_cluster.volume.storageClass | string | `""` | StorageClass name for dynamic provisioning. |
| postgres_cluster.expose | object | `{"masterLoadBalancer":false,"replicaLoadBalancer":false}` | Set postgres_cluster.expose. |
| postgres_cluster.expose.masterLoadBalancer | bool | `false` | Set postgres_cluster.expose.masterLoadBalancer. |
| postgres_cluster.expose.replicaLoadBalancer | bool | `false` | Set postgres_cluster.expose.replicaLoadBalancer. |
| postgres_cluster.pooler | object | `{"enableMasterPoolerLoadBalancer":false,"enableReplicaConnectionPooler":false,"enableReplicaPoolerLoadBalancer":false,"enabled":false}` | Set postgres_cluster.pooler. |
| postgres_cluster.pooler.enabled | bool | `false` | Enable this feature. |
| postgres_cluster.pooler.enableMasterPoolerLoadBalancer | bool | `false` | Set postgres_cluster.pooler.enableMasterPoolerLoadBalancer. |
| postgres_cluster.pooler.enableReplicaPoolerLoadBalancer | bool | `false` | Set postgres_cluster.pooler.enableReplicaPoolerLoadBalancer. |
| postgres_cluster.pooler.enableReplicaConnectionPooler | bool | `false` | Set postgres_cluster.pooler.enableReplicaConnectionPooler. |
| postgres_cluster.backup | object | `{"enabled":false,"retention":"7 days","schedule":"30 00 * * *"}` | Set postgres_cluster.backup. |
| postgres_cluster.backup.enabled | bool | `false` | Enable this feature. |
| postgres_cluster.backup.schedule | string | `"30 00 * * *"` | Set postgres_cluster.backup.schedule. |
| postgres_cluster.backup.retention | string | `"7 days"` | Set postgres_cluster.backup.retention. |
| postgres_cluster.wal | object | `{"accessKeyId":null,"awsRegion":null,"backupNumToRetain":"3","backupSchedule":"0 10 * * *","enabled":false,"logS3Tags":true,"s3Bucket":null,"s3ScopePrefix":null,"secretAccessKey":null}` | Set postgres_cluster.wal. |
| postgres_cluster.wal.enabled | bool | `false` | Enable this feature. |
| postgres_cluster.wal.backupSchedule | string | `"0 10 * * *"` | Set postgres_cluster.wal.backupSchedule. |
| postgres_cluster.wal.s3Bucket | string | `nil` | Set postgres_cluster.wal.s3Bucket. |
| postgres_cluster.wal.s3ScopePrefix | string | `nil` | Set postgres_cluster.wal.s3ScopePrefix. |
| postgres_cluster.wal.awsRegion | string | `nil` | Set postgres_cluster.wal.awsRegion. |
| postgres_cluster.wal.accessKeyId | string | `nil` | Set postgres_cluster.wal.accessKeyId. |
| postgres_cluster.wal.secretAccessKey | string | `nil` | Set postgres_cluster.wal.secretAccessKey. |
| postgres_cluster.wal.backupNumToRetain | string | `"3"` | Set postgres_cluster.wal.backupNumToRetain. |
| postgres_cluster.wal.logS3Tags | bool | `true` | Configure postgres_cluster.wal.logS3Tags. |
| postgres_cluster.tls | object | `{"caFile":"","caSecretName":"","certificateFile":"tls.crt","createCertificate":false,"duration":"2160h","enabled":false,"issuerRef":{"group":"cert-manager.io","kind":"ClusterIssuer","name":""},"organization":"ACME INC.","privateKeyFile":"tls.key","renewBefore":"360h","secretName":""}` | TLS configuration. |
| postgres_cluster.tls.enabled | bool | `false` | Enable this feature. |
| postgres_cluster.tls.secretName | string | `""` | Set postgres_cluster.tls.secretName. |
| postgres_cluster.tls.certificateFile | string | `"tls.crt"` | Set postgres_cluster.tls.certificateFile. |
| postgres_cluster.tls.privateKeyFile | string | `"tls.key"` | Set postgres_cluster.tls.privateKeyFile. |
| postgres_cluster.tls.caFile | string | `""` | Set postgres_cluster.tls.caFile. |
| postgres_cluster.tls.caSecretName | string | `""` | Set postgres_cluster.tls.caSecretName. |
| postgres_cluster.tls.createCertificate | bool | `false` | Set postgres_cluster.tls.createCertificate. |
| postgres_cluster.tls.organization | string | `"ACME INC."` | Set postgres_cluster.tls.organization. |
| postgres_cluster.tls.duration | string | `"2160h"` | Set postgres_cluster.tls.duration. |
| postgres_cluster.tls.renewBefore | string | `"360h"` | Set postgres_cluster.tls.renewBefore. |
| postgres_cluster.tls.issuerRef | object | `{"group":"cert-manager.io","kind":"ClusterIssuer","name":""}` | Set postgres_cluster.tls.issuerRef. |
| postgres_cluster.tls.issuerRef.name | string | `""` | Set postgres_cluster.tls.issuerRef.name. |
| postgres_cluster.tls.issuerRef.kind | string | `"ClusterIssuer"` | Set postgres_cluster.tls.issuerRef.kind. |
| postgres_cluster.tls.issuerRef.group | string | `"cert-manager.io"` | Set postgres_cluster.tls.issuerRef.group. |
| postgres_cluster.podServiceAccount | object | `{"name":""}` | Set postgres_cluster.podServiceAccount. |
| postgres_cluster.podServiceAccount.name | string | `""` | Set postgres_cluster.podServiceAccount.name. |
| postgres_cluster.env | list | `[]` | Environment variable entries. |
| postgres_cluster.resources | object | `{}` | Container resource requests and limits. |
| postgres_cluster.nodeAffinity | object | `{}` | Set postgres_cluster.nodeAffinity. |
| postgres_cluster.tolerations | list | `[]` | Tolerations for pod scheduling. |

