{{/*
Expand the name of the chart.
*/}}
{{- define "openai-mcp-tunnel.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "openai-mcp-tunnel.fullname" -}}
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
{{- define "openai-mcp-tunnel.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "openai-mcp-tunnel.labels" -}}
helm.sh/chart: {{ include "openai-mcp-tunnel.chart" . }}
{{ include "openai-mcp-tunnel.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "openai-mcp-tunnel.selectorLabels" -}}
app.kubernetes.io/name: {{ include "openai-mcp-tunnel.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the ServiceAccount to use.
*/}}
{{- define "openai-mcp-tunnel.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "openai-mcp-tunnel.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Resolve namespace override.
*/}}
{{- define "openai-mcp-tunnel.namespace" -}}
{{- if .Values.namespaceOverride -}}
{{- .Values.namespaceOverride -}}
{{- else -}}
{{- .Release.Namespace -}}
{{- end -}}
{{- end }}

{{/*
Resolve credentials secret name.
*/}}
{{- define "openai-mcp-tunnel.secretName" -}}
{{- if .Values.credentials.existingSecretName }}
{{- .Values.credentials.existingSecretName }}
{{- else }}
{{- printf "%s-credentials" (include "openai-mcp-tunnel.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Validate supported runtime configuration.
*/}}
{{- define "openai-mcp-tunnel.validate" -}}
{{- if not .Values.controlPlane.tunnelId -}}
{{- fail "controlPlane.tunnelId is required" -}}
{{- end -}}
{{- if and .Values.mcp.bootstrap.enabled (or .Values.mcp.serverUrl .Values.mcp.command) -}}
{{- fail "mcp.bootstrap.enabled cannot be combined with mcp.serverUrl or mcp.command" -}}
{{- end -}}
{{- if and .Values.mcp.serverUrl .Values.mcp.command -}}
{{- fail "set only one of mcp.serverUrl or mcp.command in this chart" -}}
{{- end -}}
{{- if and .Values.credentials.createSecret (not .Values.credentials.apiKey) -}}
{{- fail "credentials.apiKey is required when credentials.createSecret=true" -}}
{{- end -}}
{{- if and (not .Values.credentials.createSecret) (not .Values.credentials.existingSecretName) -}}
{{- fail "set credentials.existingSecretName or credentials.createSecret=true" -}}
{{- end -}}
{{- end }}

{{/*
Decide whether to run with the embedded MCP stub.
*/}}
{{- define "openai-mcp-tunnel.useBootstrapStub" -}}
{{- if or .Values.mcp.bootstrap.enabled (and (not .Values.mcp.serverUrl) (not .Values.mcp.command)) -}}
true
{{- end -}}
{{- end }}
