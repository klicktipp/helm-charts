{{/*
Expand the name of the chart.
*/}}
{{- define "rabbitmq-cluster.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "rabbitmq-cluster.fullname" -}}
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
{{- define "rabbitmq-cluster.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "rabbitmq-cluster.labels" -}}
helm.sh/chart: {{ include "rabbitmq-cluster.chart" . }}
{{ include "rabbitmq-cluster.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "rabbitmq-cluster.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rabbitmq-cluster.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Returns the default vhost name.
If one of the vhosts has "default: true", use that vhost as default one.
Otherwise, always use "/".
*/}}
{{- define "rabbitmq-cluster.default-vhost" -}}
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

{{/*
Return 10% of a volume size given as "<N>Gi" in MB (binary MB: 1Gi = 1024MB).
Very small sizes clamp to 50MB.
Example: "8Gi" -> 820
*/}}
{{- define "rabbitmq-cluster.calculateDiskFreeLimit" -}}
{{- $sizeRaw := (printf "%v" .) -}}
{{- $sizeGi := (trimSuffix "Gi" $sizeRaw) | int -}}
{{- $totalMB := mul $sizeGi 1024 -}}
{{- $limitMB := div (add $totalMB 9) 10 -}} {{/* ceil(totalMB/10) */}}
{{- if lt $limitMB 50 -}}
50
{{- else -}}
{{ $limitMB }}
{{- end -}}
{{- end -}}
