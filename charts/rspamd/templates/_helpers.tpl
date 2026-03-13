{{/*
Expand the name of the chart.
*/}}
{{- define "rspamd.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "rspamd.fullname" }}
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
{{- define "rspamd.chart" }}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "rspamd.labels" }}
helm.sh/chart: {{ include "rspamd.chart" . }}
{{- include "rspamd.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "rspamd.selectorLabels" }}
app.kubernetes.io/name: {{ include "rspamd.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "rspamd.serviceAccountName" }}
{{- if .Values.serviceAccount.create }}
{{- default (include "rspamd.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the fully qualified container image reference.
*/}}
{{- define "rspamd.image" }}
{{- $repository := .Values.image.repository -}}
{{- $tag := .Values.image.tag | default .Chart.AppVersion -}}
{{- if .Values.image.registry -}}
{{- printf "%s/%s:%s" .Values.image.registry $repository $tag -}}
{{- else -}}
{{- printf "%s:%s" $repository $tag -}}
{{- end -}}
{{- end }}

{{/*
Render default pod anti-affinity when no explicit affinity is configured.
*/}}
{{- define "rspamd.defaultAffinity" }}
{{- $type := default "soft" .Values.podAntiAffinity.type -}}
{{- if ne $type "disabled" }}
podAntiAffinity:
  {{- $topologyKey := default "kubernetes.io/hostname" .Values.podAntiAffinity.topologyKey }}
  {{- if eq $type "hard" }}
  requiredDuringSchedulingIgnoredDuringExecution:
    - labelSelector:
        matchExpressions:
          - key: app.kubernetes.io/instance
            operator: In
            values:
              - {{ .Release.Name }}
      topologyKey: {{ $topologyKey | quote }}
  {{- else }}
  preferredDuringSchedulingIgnoredDuringExecution:
    - weight: 100
      podAffinityTerm:
        labelSelector:
          matchExpressions:
            - key: app.kubernetes.io/instance
              operator: In
              values:
                - {{ .Release.Name }}
        topologyKey: {{ $topologyKey | quote }}
  {{- end }}
{{- end }}
{{- end }}

{{/*
Render the default tenant-scoped anti-affinity for multi-tenant mode.
*/}}
{{- define "rspamd.defaultTenantAffinity" }}
podAntiAffinity:
  requiredDuringSchedulingIgnoredDuringExecution:
    - labelSelector:
        matchExpressions:
          - key: app.kubernetes.io/instance
            operator: In
            values:
              - {{ .root.Release.Name }}
          - key: rspamd.org/tenant
            operator: In
            values:
              - {{ .tenant }}
      topologyKey: {{ default "kubernetes.io/hostname" .root.Values.podAntiAffinity.topologyKey | quote }}
{{- end }}

{{/*
Validate value combinations that would otherwise render broken manifests.
*/}}
{{- define "rspamd.validateValues" }}
{{- if and .Values.multiTenancy (empty .Values.config) }}
{{- fail "rspamd: multiTenancy=true requires at least one tenant entry in values.config" }}
{{- end }}
{{- if .Values.autoscaling.enabled }}
  {{- $replicas := int .Values.replicaCount }}
  {{- $minReplicas := int .Values.autoscaling.minReplicas }}
  {{- $maxReplicas := int .Values.autoscaling.maxReplicas }}
  {{- if or (ne $minReplicas $replicas) (ne $maxReplicas $replicas) }}
{{- fail "rspamd: autoscaling minReplicas/maxReplicas must both equal replicaCount because per-pod Services and neighbour config are generated statically from replicaCount" }}
  {{- end }}
{{- end }}
{{- end }}
