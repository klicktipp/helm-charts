{{/*
Expand the name of the chart.
*/}}
{{- define "rabbitmq-cluster-operator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "rabbitmq-cluster-operator.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "rabbitmq-cluster-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the target namespace for namespaced resources.
*/}}
{{- define "rabbitmq-cluster-operator.namespace" -}}
{{- .Release.Namespace -}}
{{- end -}}

{{/*
Return the full name including the namespace for cluster-scoped resources.
*/}}
{{- define "rabbitmq-cluster-operator.fullnameWithNamespace" -}}
{{- printf "%s-%s" (include "rabbitmq-cluster-operator.fullname" .) (include "rabbitmq-cluster-operator.namespace" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Selector labels.
*/}}
{{- define "rabbitmq-cluster-operator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rabbitmq-cluster-operator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Common labels.
*/}}
{{- define "rabbitmq-cluster-operator.labels" -}}
helm.sh/chart: {{ include "rabbitmq-cluster-operator.chart" . }}
{{ include "rabbitmq-cluster-operator.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Render a templated value.
*/}}
{{- define "rabbitmq-cluster-operator.tplvalues.render" -}}
{{- if kindIs "string" .value -}}
{{- tpl .value .context -}}
{{- else -}}
{{- tpl (toYaml .value) .context -}}
{{- end -}}
{{- end -}}

{{/*
Merge a list of maps and render the result.
*/}}
{{- define "rabbitmq-cluster-operator.tplvalues.merge" -}}
{{- $merged := dict -}}
{{- range .values -}}
  {{- if . -}}
    {{- $merged = mergeOverwrite $merged . -}}
  {{- end -}}
{{- end -}}
{{- include "rabbitmq-cluster-operator.tplvalues.render" (dict "value" $merged "context" .context) -}}
{{- end -}}

{{/*
Build an image reference from global and local values.
*/}}
{{- define "rabbitmq-cluster-operator.image" -}}
{{- $registry := .image.registry -}}
{{- if and .global .global.imageRegistry -}}
  {{- $registry = .global.imageRegistry -}}
{{- end -}}
{{- if .image.digest -}}
{{- printf "%s/%s@%s" $registry .image.repository .image.digest -}}
{{- else -}}
{{- printf "%s/%s:%s" $registry .image.repository (default .chartAppVersion .image.tag) -}}
{{- end -}}
{{- end -}}

{{/*
Look up a key from an existing secret and fall back to a generated value.
*/}}
{{- define "rabbitmq-cluster-operator.secrets.lookup" -}}
{{- $existing := lookup "v1" "Secret" .context.Release.Namespace .secret -}}
{{- if and $existing $existing.data (hasKey $existing.data .key) -}}
{{- index $existing.data .key -}}
{{- else -}}
{{- .defaultValue | b64enc -}}
{{- end -}}
{{- end -}}

{{/*
Render the pod security context payload.
*/}}
{{- define "rabbitmq-cluster-operator.renderPodSecurityContext" -}}
{{- toYaml .Values.podSecurityContext -}}
{{- end -}}

{{/*
Render the container security context payload.
*/}}
{{- define "rabbitmq-cluster-operator.renderContainerSecurityContext" -}}
{{- toYaml .Values.containerSecurityContext -}}
{{- end -}}

{{/*
Return the proper RabbitMQ Cluster Operator fullname.
*/}}
{{- define "rmqco.clusterOperator.fullname" -}}
{{- include "rabbitmq-cluster-operator.fullname" . -}}
{{- end -}}

{{/*
Common labels for rmq-cluster-operator.
*/}}
{{- define "rmqco.labels" -}}
  {{- $versionLabel := dict "app.kubernetes.io/version" (default .Chart.AppVersion .Values.clusterOperator.image.tag) -}}
  {{- $staticLabels := dict
        "app.kubernetes.io/component" "rabbitmq-operator"
        "app.kubernetes.io/part-of" "rabbitmq"
    -}}

  {{- include "rabbitmq-cluster-operator.tplvalues.merge" (dict
        "values" (list
            (include "rabbitmq-cluster-operator.labels" . | fromYaml)
            $versionLabel
            $staticLabels
        )
        "context" .
    )
  }}
{{- end }}

{{/*
Selector labels.
*/}}
{{- define "rmqco.selectorLabels" -}}
{{- include "rabbitmq-cluster-operator.selectorLabels" . -}}
{{- end }}

{{/*
Return the proper RabbitMQ Default User Credential updater image name.
*/}}
{{- define "rmqco.defaultCredentialUpdater.image" -}}
{{ include "rabbitmq-cluster-operator.image" (dict "image" .Values.credentialUpdaterImage "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper RabbitMQ Cluster Operator image name.
*/}}
{{- define "rmqco.clusterOperator.image" -}}
{{ include "rabbitmq-cluster-operator.image" (dict "image" .Values.clusterOperator.image "global" .Values.global "chartAppVersion" .Chart.AppVersion) }}
{{- end -}}

Return the proper RabbitMQ image name.
*/}}
{{- define "rmqco.rabbitmq.image" -}}
{{- include "rabbitmq-cluster-operator.image" (dict "image" .Values.rabbitmqImage "global" .Values.global) -}}
{{- end -}}

{{/*
Return the imagePullSecrets section for Cluster Operator.
*/}}
{{- define "rmqco.imagePullSecrets" -}}
{{- $pullSecrets := list }}
{{- if .Values.global }}
  {{- range .Values.global.imagePullSecrets -}}
    {{- $pullSecrets = append $pullSecrets . -}}
  {{- end -}}
{{- end -}}
{{- range (list .Values.clusterOperator.image .Values.rabbitmqImage) -}}
  {{- range .pullSecrets -}}
    {{- $pullSecrets = append $pullSecrets . -}}
  {{- end -}}
{{- end }}
{{- if not (empty $pullSecrets) }}
imagePullSecrets:
  {{- range $pullSecrets | uniq }}
  - name: {{ . }}
  {{- end }}
{{- end }}
{{- end -}}

Return the proper Docker Image Registry Secret Names as a comma separated string.
*/}}
{{- define "rmqco.imagePullSecrets.string" -}}
{{- $pullSecrets := list }}
{{- if .Values.global }}
  {{- range .Values.global.imagePullSecrets -}}
    {{- $pullSecrets = append $pullSecrets . -}}
  {{- end -}}
{{- end -}}
{{- range (list .Values.clusterOperator.image .Values.rabbitmqImage) -}}
  {{- range .pullSecrets -}}
    {{- $pullSecrets = append $pullSecrets . -}}
  {{- end -}}
{{- end -}}
{{- if not (empty $pullSecrets) }}
{{- printf "%s" (join "," $pullSecrets) -}}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use (Cluster Operator).
*/}}
{{- define "rmqco.clusterOperator.serviceAccountName" -}}
{{- if .Values.clusterOperator.serviceAccount.create -}}
    {{ default (printf "%s" (include "rmqco.clusterOperator.fullname" .)) .Values.clusterOperator.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.clusterOperator.serviceAccount.name }}
{{- end -}}
{{- end -}}

Render podSecurityContext using the local helper with proper parameter mapping.
*/}}
{{- define "rmqco.renderPodSecurityContext" -}}
{{- toYaml (omit .securityContext "enabled") -}}
{{- end }}

{{/*
Render containerSecurityContext using the local helper with proper parameter mapping.
*/}}
{{- define "rmqco.renderContainerSecurityContext" -}}
{{- toYaml (omit .securityContext "enabled") -}}
{{- end -}}
