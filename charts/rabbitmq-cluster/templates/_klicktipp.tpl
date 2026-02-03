
{{/*
slugify the string to be (k8s) DNS name compatible
*/}}
{{- define "com.klicktipp.slugify-string" -}}
{{- $r := . | lower | replace "." "-" | replace "/" "-" | replace "_" "-" | replace " " "-" | replace "--" "-" | trimPrefix "-" | trunc 63 | trimSuffix "-" }}
{{- $r }}
{{- end -}}
