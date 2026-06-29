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
Given a list of strings, concatenate all of them with a dash ("-")
and slugify the string to be DNS name compatible
*/}}
{{- define "com.klicktipp.slugify-volume-name" -}}
{{- $r := (join "-" .) | lower | replace "." "-" | replace "/" "-" | replace "_" "-" | replace "--" "-" | replace " " "-" | trimPrefix "-" | trunc 63 | trimSuffix "-" }}
{{- $r }}
{{- end -}}

{{/*
Collision-free PV / PVC names. Accepts the same list as slugify-volume-name:
  [prefix, infix..., suffix]
  prefix – first element (namespace for PVs, release name for PVCs); kept as-is
  infix  – all middle elements; joined and sha256-hashed to 8 hex chars
  suffix – last element (EFS access-point ID without "fsap-" prefix); kept as-is

Result: prefix-hash(infix)-suffix  (≤ 63 chars)

When the result would exceed 63 chars the prefix is right-truncated to fit;
any trailing dash introduced by truncation is stripped.

Because the hash covers the full infix and the access-point ID sits verbatim in
the suffix, names are globally unique even if the same access point is mounted
more than once or two jobs share the same name prefix.

Enable per release with .Values.slugifyVolumeNamesV2: true.
*/}}
{{- define "com.klicktipp.slugify-volume-name-v2" -}}
{{- $first  := first . | lower | replace "." "-" | replace "/" "-" | replace "_" "-" | replace "--" "-" | replace " " "-" | trimPrefix "-" | trimSuffix "-" -}}
{{- $last   := last  . | lower | replace "." "-" | replace "/" "-" | replace "_" "-" | replace "--" "-" | replace " " "-" | trimPrefix "-" | trimSuffix "-" -}}
{{- $hash   := join "-" (rest (initial .)) | sha256sum | trunc 8 -}}
{{- $result := printf "%s-%s-%s" $first $hash $last -}}
{{- if le (len $result) 63 -}}
{{-   $result -}}
{{- else -}}
{{-   $max := int (sub 53 (len $last)) -}}
{{-   if le $max 0 -}}
{{-     printf "%s-%s" $hash $last | trunc 63 | trimSuffix "-" -}}
{{-   else -}}
{{-     $f := $first | trunc $max | trimSuffix "-" | trimPrefix "-" -}}
{{-     if eq $f "" -}}
{{-       printf "%s-%s" $hash $last -}}
{{-     else -}}
{{-       printf "%s-%s-%s" $f $hash $last -}}
{{-     end -}}
{{-   end -}}
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
