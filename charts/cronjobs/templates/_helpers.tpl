{{/*
Expand the name of the chart.
*/}}
{{- define "cronjobs.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cronjobs.fullname" -}}
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
{{- define "cronjobs.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cronjobs.labels" -}}
helm.sh/chart: {{ include "cronjobs.chart" . }}
{{ include "cronjobs.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cronjobs.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cronjobs.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "cronjobs.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the fully qualified startup jitter image reference.
*/}}
{{- define "cronjobs.startupJitterImage" -}}
{{- $repository := .repository | default "bash" -}}
{{- $tag := .tag | default "5.3" -}}
{{- if .registry -}}
{{- printf "%s/%s:%s" .registry $repository $tag -}}
{{- else -}}
{{- printf "%s:%s" $repository $tag -}}
{{- end -}}
{{- end -}}

{{/*
Joins a list of strings with "-" and makes the result safe for use as a
Kubernetes resource name (lowercase, no special chars, max 63 chars).

When the combined string fits within 63 chars it is used as-is — this keeps
names in long-lived namespaces (staging, prod) stable.

When the name would exceed 63 chars, the last element (EFS access point ID)
is replaced with a 6-char sha256 hash of its value. This keeps the infix
(chart + job name) readable while still uniquely identifying the access point.
*/}}
{{- define "com.klicktipp.slugify-volume-name" -}}
{{- if and (kindIs "slice" .) (gt (len .) 1) -}}
{{-   $last   := last . | lower | replace "." "-" | replace "/" "-" | replace "_" "-" | replace "--" "-" | replace " " "-" | trimPrefix "-" | trimSuffix "-" -}}
{{-   $prefix := join "-" (initial .) | lower | replace "." "-" | replace "/" "-" | replace "_" "-" | replace "--" "-" | replace " " "-" | trimPrefix "-" | trimSuffix "-" -}}
{{-   $full   := printf "%s-%s" $prefix $last -}}
{{-   if le (len $full) 63 -}}
{{-     $full -}}
{{-   else -}}
{{-     $suffix := $last | sha256sum | trunc 6 -}}
{{-     $max    := int (sub 63 (add 1 (len $suffix))) -}}
{{-     $p      := $prefix | trunc $max | trimSuffix "-" | trimPrefix "-" -}}
{{-     if eq $p "" -}}
{{-       $suffix -}}
{{-     else -}}
{{-       printf "%s-%s" $p $suffix -}}
{{-     end -}}
{{-   end -}}
{{- else -}}
{{-   (join "-" .) | lower | replace "." "-" | replace "/" "-" | replace "_" "-" | replace "--" "-" | replace " " "-" | trimPrefix "-" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Generate deterministic startup delay seconds from seed parts.
*/}}
{{- define "com.klicktipp.generateStartupDelaySeconds" -}}
{{- $seed := join "-" (index . "seed") -}}
{{- $exceptionList := list "prod" "staging" -}}
{{- $hash := sha256sum $seed -}}
{{- $intFromHash := int64 (printf "%x" (substr 0 8 $hash)) -}}
{{- $maxSeconds := int (default 60 (index . "maxSeconds")) -}}
{{- mod $intFromHash (add $maxSeconds 1) -}}
{{- end -}}
