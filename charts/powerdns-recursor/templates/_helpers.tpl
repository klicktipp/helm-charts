{{/*
Expand the name of the chart.
*/}}
{{- define "pdns.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "pdns.fullname" -}}
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
{{- define "pdns.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels.
*/}}
{{- define "pdns.labels" -}}
helm.sh/chart: {{ include "pdns.chart" . }}
{{ include "pdns.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels.
*/}}
{{- define "pdns.selectorLabels" -}}
app.kubernetes.io/name: {{ include "pdns.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use.
*/}}
{{- define "pdns.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "pdns.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Render image reference.
*/}}
{{- define "pdns.image" -}}
{{- if .Values.image.registry -}}
{{- printf "%s/%s:%s" .Values.image.registry .Values.image.repository (.Values.image.tag | default .Chart.AppVersion) -}}
{{- else -}}
{{- printf "%s:%s" .Values.image.repository (.Values.image.tag | default .Chart.AppVersion) -}}
{{- end -}}
{{- end }}

{{/*
Backwards compatible podMonitor enabled flag.
*/}}
{{- define "pdns.podMonitorEnabled" -}}
{{- if kindIs "bool" .Values.podMonitor -}}
{{- .Values.podMonitor -}}
{{- else -}}
{{- default false .Values.podMonitor.enabled -}}
{{- end -}}
{{- end }}

{{/*
Selected workload type.
*/}}
{{- define "pdns.workloadType" -}}
{{- $workloadType := default "Deployment" .Values.workload.type -}}
{{- if not (has $workloadType (list "Deployment" "DaemonSet")) -}}
{{- fail (printf "workload.type must be either Deployment or DaemonSet, got %q" $workloadType) -}}
{{- end -}}
{{- $workloadType -}}
{{- end }}

{{/*
Internal traffic policy with DaemonSet-aware default.
*/}}
{{- define "pdns.internalTrafficPolicy" -}}
{{- if .Values.service.internalTrafficPolicy -}}
{{- .Values.service.internalTrafficPolicy -}}
{{- else if eq (include "pdns.workloadType" .) "DaemonSet" -}}
{{- "Local" -}}
{{- end -}}
{{- end }}

{{/*
Shared affinity configuration.
*/}}
{{- define "pdns.affinity" -}}
{{- if .Values.affinity }}
affinity:
  {{- toYaml .Values.affinity | nindent 2 }}
{{- else if and (eq (include "pdns.workloadType" .) "Deployment") (ne (default "soft" .Values.podAntiAffinity.type) "disabled") }}
affinity:
  podAntiAffinity:
    {{- $instanceLabel := .Release.Name }}
    {{- $topologyKey := default "kubernetes.io/hostname" .Values.podAntiAffinity.topologyKey }}
    {{- if eq (default "soft" .Values.podAntiAffinity.type) "hard" }}
    requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
            - key: app.kubernetes.io/instance
              operator: In
              values:
                - {{ $instanceLabel }}
        topologyKey: {{ $topologyKey | quote }}
    {{- else }}
    preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        podAffinityTerm:
          labelSelector:
            matchExpressions:
              - key: app.kubernetes.io/instance
                operator: In
                values:
                  - {{ $instanceLabel }}
          topologyKey: {{ $topologyKey | quote }}
    {{- end }}
{{- end }}
{{- end }}

{{/*
Shared pod spec for Deployment and DaemonSet.
*/}}
{{- define "pdns.podSpec" -}}
serviceAccountName: {{ include "pdns.serviceAccountName" . }}
{{- with .Values.imagePullSecrets }}
imagePullSecrets:
  {{- toYaml . | nindent 2 }}
{{- end }}
securityContext:
  {{- toYaml .Values.podSecurityContext | nindent 2 }}
{{- with .Values.priorityClassName }}
priorityClassName: {{ . | quote }}
{{- end }}
{{- with .Values.nodeSelector }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- include "pdns.affinity" . }}
{{- with .Values.tolerations }}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
containers:
  - name: {{ .Chart.Name }}
    image: {{ include "pdns.image" . | quote }}
    imagePullPolicy: {{ default .Values.image.imagePullPolicy .Values.image.pullPolicy }}
    securityContext:
      {{- toYaml .Values.securityContext | nindent 6 }}
    ports:
      - name: dns-udp
        containerPort: {{ .Values.pdns.port }}
        protocol: UDP
      - name: dns-tcp
        containerPort: {{ .Values.pdns.port }}
        protocol: TCP
      {{- if or .Values.pdns.api.enabled (include "pdns.podMonitorEnabled" . | trim | eq "true") }}
      - name: api
        containerPort: {{ .Values.pdns.api.port }}
        protocol: TCP
      {{- end }}
    livenessProbe:
      tcpSocket:
        port: dns-tcp
      initialDelaySeconds: {{ .Values.probes.liveness.initialDelaySeconds }}
      periodSeconds: {{ .Values.probes.liveness.periodSeconds }}
      timeoutSeconds: {{ .Values.probes.liveness.timeoutSeconds }}
      failureThreshold: {{ .Values.probes.liveness.failureThreshold }}
    readinessProbe:
      tcpSocket:
        port: dns-tcp
      initialDelaySeconds: {{ .Values.probes.readiness.initialDelaySeconds }}
      periodSeconds: {{ .Values.probes.readiness.periodSeconds }}
      timeoutSeconds: {{ .Values.probes.readiness.timeoutSeconds }}
      failureThreshold: {{ .Values.probes.readiness.failureThreshold }}
    resources:
      {{- toYaml .Values.resources | nindent 6 }}
    volumeMounts:
      - name: pdns-config
        mountPath: /etc/powerdns/recursor.yml
        subPath: recursor.yml
      {{- if or .Values.pdns.lua.enabled .Values.pdns.config.recursor.lua_config_file }}
      - name: pdns-lua
        mountPath: /etc/powerdns/recursor.lua
        subPath: recursor.lua
      {{- end }}
volumes:
  - name: pdns-config
    configMap:
      name: {{ include "pdns.fullname" . }}-config
  {{- if or .Values.pdns.lua.enabled .Values.pdns.config.recursor.lua_config_file }}
  - name: pdns-lua
    configMap:
      name: {{ include "pdns.fullname" . }}-lua
  {{- end }}
{{- end }}
