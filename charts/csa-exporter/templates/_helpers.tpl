{{/*
Expand the name of the chart.
*/}}
{{- define "csa-exporter.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "csa-exporter.fullname" -}}
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
{{- define "csa-exporter.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "csa-exporter.labels" -}}
helm.sh/chart: {{ include "csa-exporter.chart" . }}
{{ include "csa-exporter.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "csa-exporter.selectorLabels" -}}
app.kubernetes.io/name: {{ include "csa-exporter.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "csa-exporter.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "csa-exporter.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "csa-exporter.secretName" -}}
{{- if .Values.auth.existingSecretName }}
{{- .Values.auth.existingSecretName }}
{{- else }}
{{- printf "%s-auth" (include "csa-exporter.fullname" .) }}
{{- end }}
{{- end }}

{{- define "csa-exporter.useTokenAuth" -}}
{{- if .Values.auth.token -}}
true
{{- else if and .Values.auth.secretKeys.token (not .Values.auth.id) (not .Values.auth.secret) (not .Values.auth.secretKeys.id) (not .Values.auth.secretKeys.secret) -}}
true
{{- end }}
{{- end }}

{{- define "csa-exporter.usePartsAuth" -}}
{{- if and (not .Values.auth.token) .Values.auth.id .Values.auth.secret -}}
true
{{- else if and (not .Values.auth.token) .Values.auth.secretKeys.id .Values.auth.secretKeys.secret -}}
true
{{- end }}
{{- end }}

{{- define "csa-exporter.namespace" -}}
  {{- if .Values.namespaceOverride -}}
    {{- .Values.namespaceOverride -}}
  {{- else -}}
    {{- .Release.Namespace -}}
  {{- end -}}
{{- end -}}
