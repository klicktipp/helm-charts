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

The last element is always kept in full — it is the unique part (e.g. an EFS
access point ID like "0e702cdce44153d31"). If the combined string would exceed
63 chars, the prefix (everything before the last element) is shortened from the
right to make room. This way two different access points for the same job always
get two different PV names, even in namespaces with long names.

Without this fix, the entire string was cut off at 63 chars from the right,
which silently dropped the access point ID for long namespace names, making
every access point of a job produce the same PV name — causing Kubernetes to
reject the update because the PV's volume source is immutable after creation.
*/}}
{{- define "com.klicktipp.slugify-volume-name" -}}
{{- if and (kindIs "slice" .) (gt (len .) 1) -}}
{{-   $last   := last . | lower | replace "." "-" | replace "/" "-" | replace "_" "-" | replace "--" "-" | replace " " "-" | trimPrefix "-" | trimSuffix "-" -}}
{{-   if ge (len $last) 63 -}}
{{-     $last | trunc 63 | trimSuffix "-" | trimPrefix "-" -}}
{{-   else -}}
{{-     $prefix := join "-" (initial .) | lower | replace "." "-" | replace "/" "-" | replace "_" "-" | replace "--" "-" | replace " " "-" | trimPrefix "-" | trimSuffix "-" -}}
{{-     $max    := int (sub 63 (add 1 (len $last))) -}}
{{-     $p      := $prefix | trunc $max | trimSuffix "-" | trimPrefix "-" -}}
{{-     if eq $p "" -}}
{{-       $last -}}
{{-     else -}}
{{-       printf "%s-%s" $p $last | trimSuffix "-" -}}
{{-     end -}}
{{-   end -}}
{{- else -}}
{{-   (join "-" .) | lower | replace "." "-" | replace "/" "-" | replace "_" "-" | replace "--" "-" | replace " " "-" | trimPrefix "-" | trunc 63 | trimSuffix "-" -}}
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
