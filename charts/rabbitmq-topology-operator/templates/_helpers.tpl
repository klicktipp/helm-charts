{{/*
Expand the name of the chart.
*/}}
{{- define "rabbitmq-topology-operator.name" -}}
{{- default .Chart.Name .Values.nameOverride | lower | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "rabbitmq-topology-operator.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | lower | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride | lower -}}
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
{{- define "rabbitmq-topology-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the target namespace for namespaced resources.
*/}}
{{- define "rabbitmq-topology-operator.namespace" -}}
{{- .Release.Namespace -}}
{{- end -}}

{{/*
Render a templated value.
*/}}
{{- define "rabbitmq-topology-operator.tplvalues.render" -}}
{{- if kindIs "string" .value -}}
{{- tpl .value .context -}}
{{- else -}}
{{- tpl (toYaml .value) .context -}}
{{- end -}}
{{- end -}}

{{/*
Merge a list of maps and render the result.
*/}}
{{- define "rabbitmq-topology-operator.tplvalues.merge" -}}
{{- $merged := dict -}}
{{- range .values -}}
  {{- if . -}}
    {{- $merged = mergeOverwrite $merged . -}}
  {{- end -}}
{{- end -}}
{{- include "rabbitmq-topology-operator.tplvalues.render" (dict "value" $merged "context" .context) -}}
{{- end -}}

{{/*
Build an image reference from global and local values.
*/}}
{{- define "rabbitmq-topology-operator.image" -}}
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
{{- define "rabbitmq-topology-operator.secrets.lookup" -}}
{{- $existing := lookup "v1" "Secret" .context.Release.Namespace .secret -}}
{{- if and $existing $existing.data (hasKey $existing.data .key) -}}
{{- index $existing.data .key -}}
{{- else -}}
{{- .defaultValue | b64enc -}}
{{- end -}}
{{- end -}}

{{/*
Selector labels.
*/}}
{{- define "rabbitmq-topology-operator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rabbitmq-topology-operator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Common labels.
*/}}
{{- define "rabbitmq-topology-operator.labels" -}}
helm.sh/chart: {{ include "rabbitmq-topology-operator.chart" . }}
{{ include "rabbitmq-topology-operator.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Render the pod security context payload.
*/}}
{{- define "rabbitmq-topology-operator.renderPodSecurityContext" -}}
{{- toYaml .Values.podSecurityContext -}}
{{- end -}}

{{/*
Render the container security context payload.
*/}}
{{- define "rabbitmq-topology-operator.renderContainerSecurityContext" -}}
{{- toYaml .Values.containerSecurityContext -}}
{{- end -}}

{{/*
Common labels for the Messaging Topology Operator.
*/}}
{{- define "rmqto.labels" -}}
  {{- $versionLabel := dict "app.kubernetes.io/version" (default .Chart.AppVersion .Values.image.tag) -}}
  {{- $staticLabels := dict
        "app.kubernetes.io/component" "messaging-topology-operator"
        "app.kubernetes.io/part-of" "rabbitmq"
    -}}

  {{- include "rabbitmq-topology-operator.tplvalues.merge" (dict
        "values" (list
            (include "rabbitmq-topology-operator.labels" . | fromYaml)
            $versionLabel
            $staticLabels
        )
        "context" .
    )
  }}
{{- end }}

{{/*
Selector labels for the Messaging Topology Operator.
*/}}
{{- define "rmqto.selectorLabels" -}}
{{- include "rabbitmq-topology-operator.selectorLabels" . -}}
{{- end }}

{{/*
Return the fullname including the namespace for cluster-scoped resources.
*/}}
{{- define "rmqto.fullname.namespace" -}}
{{- printf "%s-%s" (include "rmqto.fullname" .) (include "rabbitmq-topology-operator.namespace" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the operator fullname.
*/}}
{{- define "rmqto.fullname" -}}
{{- include "rabbitmq-topology-operator.fullname" . -}}
{{- end -}}

{{/*
Return the webhook fullname.
*/}}
{{- define "rmqto.webhook.fullname" -}}
{{- if .Values.fullnameOverride -}}
    {{- printf "%s-%s" (.Values.fullnameOverride | lower) "webhook" | trunc 63 | trimSuffix "-" -}}
{{- else -}}
    {{- printf "%s-%s" (include "rmqto.fullname" .) "webhook" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the webhook fullname including the namespace.
*/}}
{{- define "rmqto.webhook.fullname.namespace" -}}
{{- printf "%s-%s" (include "rmqto.webhook.fullname" .) (include "rabbitmq-topology-operator.namespace" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the webhook secret name.
*/}}
{{- define "rmqto.webhook.secretName" -}}
{{- if .Values.existingWebhookCertSecret -}}
    {{- .Values.existingWebhookCertSecret -}}
{{- else -}}
    {{- include "rmqto.webhook.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Return the operator image name.
*/}}
{{- define "rmqto.image" -}}
{{ include "rabbitmq-topology-operator.image" (dict "image" .Values.image "global" .Values.global "chartAppVersion" .Chart.AppVersion) }}
{{- end -}}

{{/*
Return the imagePullSecrets section.
*/}}
{{- define "rmqto.imagePullSecrets" -}}
{{- $pullSecrets := list }}
{{- if .Values.global }}
  {{- range .Values.global.imagePullSecrets -}}
    {{- $pullSecrets = append $pullSecrets . -}}
  {{- end -}}
{{- end -}}
{{- range .Values.image.pullSecrets -}}
  {{- $pullSecrets = append $pullSecrets . -}}
{{- end -}}
{{- if not (empty $pullSecrets) }}
imagePullSecrets:
  {{- range $pullSecrets | uniq }}
  - name: {{ . }}
  {{- end }}
{{- end }}
{{- end -}}

{{/*
Create the name of the service account to use.
*/}}
{{- define "rmqto.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (printf "%s" (include "rmqto.fullname" .)) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Render podSecurityContext using the local helper with proper parameter mapping.
*/}}
{{- define "rmqto.renderPodSecurityContext" -}}
{{- toYaml (omit .securityContext "enabled") -}}
{{- end }}

{{/*
Render containerSecurityContext using the local helper with proper parameter mapping.
*/}}
{{- define "rmqto.renderContainerSecurityContext" -}}
{{- toYaml (omit .securityContext "enabled") -}}
{{- end -}}
