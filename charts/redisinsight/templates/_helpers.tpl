{{/*
Expand the name of the chart.
*/}}
{{- define "redisinsight-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "redisinsight-chart.fullname" -}}
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
{{- define "redisinsight-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "redisinsight-chart.labels" -}}
helm.sh/chart: {{ include "redisinsight-chart.chart" . }}
{{ include "redisinsight-chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Values.image.tag | default .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "redisinsight-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "redisinsight-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use.
*/}}
{{- define "redisinsight-chart.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "redisinsight-chart.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Render RedisInsight pre-setup databases JSON.
*/}}
{{- define "redisinsight-chart.preSetupDatabases" -}}
{{- $databases := list -}}
{{- range $server := .Values.redisinsight.redis_servers }}
  {{- $database := omit $server "seedNodes" -}}
  {{- if hasKey $server "seedNodes" }}
    {{- $_ := set $database "nodes" $server.seedNodes }}
    {{- if gt (len $server.seedNodes) 0 }}
      {{- $seedNode := first $server.seedNodes }}
      {{- if not (hasKey $database "host") }}
        {{- $_ := set $database "host" $seedNode.host }}
      {{- end }}
      {{- if not (hasKey $database "port") }}
        {{- $_ := set $database "port" $seedNode.port }}
      {{- end }}
    {{- end }}
  {{- end }}
  {{- $databases = append $databases $database -}}
{{- end }}
{{- $databases | toPrettyJson -}}
{{- end }}
