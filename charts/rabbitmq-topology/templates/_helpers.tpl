{{/*
Expand the name of the chart.
*/}}
{{- define "rabbitmq-topology.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "rabbitmq-topology.fullname" -}}
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
{{- define "rabbitmq-topology.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "rabbitmq-topology.labels" -}}
helm.sh/chart: {{ include "rabbitmq-topology.chart" . }}
{{ include "rabbitmq-topology.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "rabbitmq-topology.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rabbitmq-topology.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Returns the default vhost name.
If one of the vhosts has "default: true", use that vhost as default one.
Otherwise, always use "/".
*/}}
{{- define "rabbitmq-topology.default-vhost" -}}
{{- $vhost := "/" }}
{{- if .Values.rabbitmq.vhosts }}
  {{- range $key, $val := .Values.rabbitmq.vhosts }}
    {{- if and ($val.enabled | default true) $val.default }}
      {{- $vhost = $val.name | default $key }}
      {{- break }}
    {{- end }}
  {{- end }}
{{- end }}
{{- $vhost }}
{{- end -}}
