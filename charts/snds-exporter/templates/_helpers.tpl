{{/*
Expand the name of the chart.
*/}}
{{- define "snds-exporter.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "snds-exporter.fullname" -}}
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
{{- define "snds-exporter.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "snds-exporter.labels" -}}
helm.sh/chart: {{ include "snds-exporter.chart" . }}
{{ include "snds-exporter.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "snds-exporter.selectorLabels" -}}
app.kubernetes.io/name: {{ include "snds-exporter.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "snds-exporter.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "snds-exporter.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "snds-exporter.namespace" -}}
  {{- if .Values.namespaceOverride -}}
    {{- .Values.namespaceOverride -}}
  {{- else -}}
    {{- .Release.Namespace -}}
  {{- end -}}
{{- end -}}

{{- define "snds-exporter.authSecretName" -}}
{{- if .Values.auth.secret.name -}}
{{- .Values.auth.secret.name -}}
{{- else -}}
{{- printf "%s-auth" (include "snds-exporter.fullname" .) -}}
{{- end -}}
{{- end -}}

{{- define "snds-exporter.patchSecretName" -}}
{{- if .Values.auth.refresh.patchKubernetesSecret.secretName -}}
{{- .Values.auth.refresh.patchKubernetesSecret.secretName -}}
{{- else -}}
{{- include "snds-exporter.authSecretName" . -}}
{{- end -}}
{{- end -}}

{{- define "snds-exporter.patchSecretNamespace" -}}
{{- if .Values.auth.refresh.patchKubernetesSecret.secretNamespace -}}
{{- .Values.auth.refresh.patchKubernetesSecret.secretNamespace -}}
{{- else -}}
{{- include "snds-exporter.namespace" . -}}
{{- end -}}
{{- end -}}
