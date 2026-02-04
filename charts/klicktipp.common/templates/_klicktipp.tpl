{{/*
slugify the string to be (k8s) DNS name compatible
*/}}
{{- define "com.klicktipp.slugify-string" -}}
{{- /* 1) Make sure we’re working with a string, and lowercase it */ -}}
{{- $text := . | toString | lower -}}

{{- /* 2) Replace “anything that is NOT a-z or 0-9” (in runs) with a dash */ -}}
{{- $text = regexReplaceAll "[^a-z0-9]+" $text "-" -}}

{{- /* 3) Remove dashes at the start or end */ -}}
{{- $text = trimAll "-" $text -}}

{{- /* 4) Limit to 63 characters, then remove a trailing dash if truncation created one */ -}}
{{- $text = $text | trunc 63 | trimSuffix "-" -}}

{{- /* Step 5: If nothing is left (e.g. input was only symbols), fail fast */ -}}
{{- if eq $text "" -}}
{{- fail "slugify: input became empty after sanitizing (must contain at least one a-z/0-9)" -}}
{{- end -}}

{{- /* Final: output the slug */ -}}
{{- $text -}}
{{- end -}}
