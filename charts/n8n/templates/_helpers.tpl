{{/*
Expand the name of the chart.
*/}}
{{- define "n8n.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "n8n.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "n8n.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "n8n.labels" -}}
helm.sh/chart: {{ include "n8n.chart" . }}
{{ include "n8n.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.global.labels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "n8n.selectorLabels" -}}
app.kubernetes.io/name: {{ include "n8n.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/* Create the name of the service account to use */}}
{{- define "n8n.serviceAccountName" -}}
{{- if .Values.main.serviceAccount.create }}
{{- default (default (include "n8n.fullname" .) .Values.global.serviceAccount.name) .Values.main.serviceAccount.name }}
{{- else }}
{{- default (default "default" .Values.global.serviceAccount.name) .Values.main.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* Render volume source for a persistence block */}}
{{- define "n8n.persistenceVolume" -}}
{{- $persistence := .persistence -}}
{{- if or (not $persistence.enabled) (eq $persistence.type "emptyDir") -}}
emptyDir: {}
{{- else if and $persistence.enabled $persistence.existingClaim -}}
persistentVolumeClaim:
  claimName: {{ $persistence.existingClaim }}
{{- else if and $persistence.enabled (eq $persistence.type "dynamic") -}}
persistentVolumeClaim:
  claimName: {{ .claimName }}
{{- end }}
{{- end }}

{{/* Resolve image from global and chart values */}}
{{- define "n8n.image" -}}
{{- $repo := coalesce .Values.global.image.repository .Values.image.repository -}}
{{- $tag := coalesce .Values.global.image.tag .Values.image.tag .Chart.AppVersion -}}
{{- printf "%s:%s" $repo $tag -}}
{{- end }}

{{/* Resolve imagePullPolicy from global and chart values */}}
{{- define "n8n.imagePullPolicy" -}}
{{- coalesce .Values.global.image.pullPolicy .Values.image.pullPolicy "IfNotPresent" -}}
{{- end }}


{{/* Create environment variables from yaml tree */}}
{{- define "toEnvVars" -}}
    {{- $prefix := "" }}
    {{- if .prefix }}
        {{- $prefix = printf "%s_" .prefix }}
    {{- end }}
    {{- range $key, $value := .values }}
        {{- if kindIs "map" $value -}}
            {{- dict "values" $value "prefix" (printf "%s%s" $prefix ($key | upper)) "isSecret" $.isSecret | include "toEnvVars" -}}
        {{- else -}}
            {{- if $.isSecret -}}
{{ $prefix }}{{ $key | upper }}: {{ $value | toString | b64enc }}{{ "\n" }}
            {{- else -}}
{{ $prefix }}{{ $key | upper }}: {{ $value | toString | quote }}{{ "\n" }}
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end }}


{{/* Validate Valkey/Redis configuration when webhooks are enabled*/}}
{{- define "n8n.validateValkey" -}}
{{- $envVars := fromYaml (include "toEnvVars" (dict "values" .Values.main.config "prefix" "")) -}}
{{- if and .Values.webhook.enabled (not $envVars.QUEUE_BULL_REDIS_HOST) -}}
{{- fail "Webhook processes rely on Valkey. Please set a Redis/Valkey host when webhook.enabled=true" -}}
{{- end -}}
{{- end -}}

{{/* Render merged extraEnv. Supports list (preferred) and map (backward-compatible). */}}
{{- define "n8n.renderMergedExtraEnv" -}}
{{- $global := default (list) .global -}}
{{- $component := default (list) .component -}}
{{- $ctx := .context -}}

{{- if or (kindIs "map" $global) (kindIs "map" $component) -}}
  {{- $gMap := dict -}}
  {{- $cMap := dict -}}

  {{- if kindIs "map" $global -}}
    {{- $gMap = $global -}}
  {{- else if not (and (kindIs "slice" $global) (eq (len $global) 0)) -}}
    {{- fail "global.extraEnv must be a map or a list" -}}
  {{- end -}}

  {{- if kindIs "map" $component -}}
    {{- $cMap = $component -}}
  {{- else if not (and (kindIs "slice" $component) (eq (len $component) 0)) -}}
    {{- fail "component extraEnv must be a map or a list" -}}
  {{- end -}}

  {{- $merged := mergeOverwrite (deepCopy $gMap) $cMap -}}
  {{- range $name, $value := $merged }}
- name: {{ $name }}
    {{- if kindIs "map" $value }}
  {{- toYaml $value | nindent 2 }}
    {{- else }}
  value: {{ $value | toString | quote }}
    {{- end }}
  {{- end -}}
{{- else -}}
  {{- if not (kindIs "slice" $global) -}}
    {{- fail "global.extraEnv must be a list (preferred) or map (legacy)" -}}
  {{- end -}}
  {{- if not (kindIs "slice" $component) -}}
    {{- fail "component extraEnv must be a list (preferred) or map (legacy)" -}}
  {{- end -}}
  {{- $merged := concat $global $component -}}
  {{- if gt (len $merged) 0 -}}
{{ tpl (toYaml $merged) $ctx }}
  {{- end -}}
{{- end -}}
{{- end -}}
