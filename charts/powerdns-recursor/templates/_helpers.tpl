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
Validate cross-field settings.
*/}}
{{- define "pdns.validate" -}}
{{- if .Values.transparentDNS.enabled -}}
{{- if ne (include "pdns.workloadType" .) "DaemonSet" -}}
{{- fail "transparentDNS.enabled=true requires workload.type=DaemonSet" -}}
{{- end -}}
{{- if not .Values.transparentDNS.clusterDNS.serviceIP -}}
{{- fail "transparentDNS.enabled=true requires transparentDNS.clusterDNS.serviceIP to be set to the kube-dns/CoreDNS Service IP" -}}
{{- end -}}
{{- if and (not .Values.transparentDNS.customClusterDNSIP) .Values.transparentDNS.clusterDNS.upstreamService.create (not .Values.transparentDNS.clusterDNS.upstreamService.clusterIP) -}}
{{- fail "transparentDNS.enabled=true requires transparentDNS.clusterDNS.upstreamService.clusterIP when transparentDNS.clusterDNS.upstreamService.create=true" -}}
{{- end -}}
{{- end -}}
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
Name of the auxiliary CoreDNS upstream service.
*/}}
{{- define "pdns.transparentDNSUpstreamServiceName" -}}
{{- if .Values.transparentDNS.clusterDNS.upstreamService.name -}}
{{- .Values.transparentDNS.clusterDNS.upstreamService.name -}}
{{- else -}}
{{- printf "%s-cluster-dns-upstream" (include "pdns.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end }}

{{/*
Effective CoreDNS upstream IP for transparent DNS forwarding.
*/}}
{{- define "pdns.transparentDNSClusterDNSIP" -}}
{{- if .Values.transparentDNS.customClusterDNSIP -}}
{{- .Values.transparentDNS.customClusterDNSIP -}}
{{- else -}}
{{- .Values.transparentDNS.clusterDNS.upstreamService.clusterIP -}}
{{- end -}}
{{- end }}

{{/*
Priority class with transparent DNS-aware default.
*/}}
{{- define "pdns.priorityClassName" -}}
{{- if .Values.priorityClassName -}}
{{- .Values.priorityClassName -}}
{{- else if .Values.transparentDNS.enabled -}}
{{- "system-node-critical" -}}
{{- end -}}
{{- end }}

{{/*
Effective tolerations.
*/}}
{{- define "pdns.tolerations" -}}
{{- if .Values.tolerations -}}
{{- toYaml .Values.tolerations -}}
{{- else if .Values.transparentDNS.enabled -}}
{{- toYaml .Values.transparentDNS.tolerations -}}
{{- end -}}
{{- end }}

{{/*
Rendered PDNS config with transparent DNS forwarding when enabled.
*/}}
{{- define "pdns.config" -}}
{{- $config := mustDeepCopy .Values.pdns.config -}}
{{- if .Values.transparentDNS.enabled -}}
{{- $recursor := default (dict) (get $config "recursor") -}}
{{- $existing := default (list) (get $recursor "forward_zones_recurse") -}}
{{- $upstreamIP := include "pdns.transparentDNSClusterDNSIP" . -}}
{{- $zones := list
    (dict "zone" .Values.transparentDNS.clusterDomain "recurse" true "forwarders" (list (printf "%s:53" $upstreamIP)))
    (dict "zone" "in-addr.arpa" "recurse" true "forwarders" (list (printf "%s:53" $upstreamIP)))
    (dict "zone" "ip6.arpa" "recurse" true "forwarders" (list (printf "%s:53" $upstreamIP))) -}}
{{- $_ := set $recursor "forward_zones_recurse" (concat $existing $zones) -}}
{{- $_ := set $config "recursor" $recursor -}}
{{- end -}}
{{- toYaml $config -}}
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
{{- if .Values.transparentDNS.enabled }}
hostNetwork: true
dnsPolicy: Default
{{- end }}
securityContext:
  {{- toYaml .Values.podSecurityContext | nindent 2 }}
{{- with (include "pdns.priorityClassName" .) }}
priorityClassName: {{ . | quote }}
{{- end }}
{{- with .Values.nodeSelector }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- include "pdns.affinity" . }}
{{- with (include "pdns.tolerations" .) }}
tolerations:
  {{- . | nindent 2 }}
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
  {{- if .Values.transparentDNS.enabled }}
  - name: dns-interceptor
    image: "{{ .Values.transparentDNS.interceptor.image.repository }}:{{ .Values.transparentDNS.interceptor.image.tag }}"
    imagePullPolicy: {{ .Values.transparentDNS.interceptor.image.pullPolicy }}
    securityContext:
      {{- toYaml .Values.transparentDNS.securityContext | nindent 6 }}
    command:
      - /bin/sh
      - -ec
    args:
      - |
        set -euo pipefail
        {{ .Values.transparentDNS.interceptor.installPackagesCommand }}

        add_ip() {
          ip addr add {{ .Values.transparentDNS.localIP }}/32 dev lo 2>/dev/null || true
        }

        del_ip() {
          ip addr del {{ .Values.transparentDNS.localIP }}/32 dev lo 2>/dev/null || true
        }

        add_rule() {
          local chain="$1"
          local proto="$2"
          iptables -t nat -C "${chain}" -d {{ .Values.transparentDNS.clusterDNS.serviceIP }} -p "${proto}" --dport 53 -j DNAT --to-destination {{ .Values.transparentDNS.localIP }}:{{ .Values.pdns.port }} 2>/dev/null \
            || iptables -t nat -A "${chain}" -d {{ .Values.transparentDNS.clusterDNS.serviceIP }} -p "${proto}" --dport 53 -j DNAT --to-destination {{ .Values.transparentDNS.localIP }}:{{ .Values.pdns.port }}
        }

        del_rule() {
          local chain="$1"
          local proto="$2"
          iptables -t nat -D "${chain}" -d {{ .Values.transparentDNS.clusterDNS.serviceIP }} -p "${proto}" --dport 53 -j DNAT --to-destination {{ .Values.transparentDNS.localIP }}:{{ .Values.pdns.port }} 2>/dev/null || true
        }

        cleanup() {
          if [ "{{ .Values.transparentDNS.skipTeardown }}" = "true" ]; then
            exit 0
          fi
          if [ "{{ .Values.transparentDNS.setupIptables }}" = "true" ]; then
            del_rule PREROUTING udp
            del_rule PREROUTING tcp
            if [ "{{ .Values.transparentDNS.captureOutput }}" = "true" ]; then
              del_rule OUTPUT udp
              del_rule OUTPUT tcp
            fi
          fi
          if [ "{{ .Values.transparentDNS.setupInterface }}" = "true" ]; then
            del_ip
          fi
        }

        trap cleanup TERM INT EXIT

        if [ "{{ .Values.transparentDNS.setupInterface }}" = "true" ]; then
          add_ip
        fi

        if [ "{{ .Values.transparentDNS.setupIptables }}" = "true" ]; then
          add_rule PREROUTING udp
          add_rule PREROUTING tcp
          if [ "{{ .Values.transparentDNS.captureOutput }}" = "true" ]; then
            add_rule OUTPUT udp
            add_rule OUTPUT tcp
          fi
        fi

        while true; do sleep 3600; done
    resources:
      {{- toYaml .Values.transparentDNS.resources | nindent 6 }}
    volumeMounts:
      - mountPath: /run/xtables.lock
        name: xtables-lock
        readOnly: false
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
  {{- if .Values.transparentDNS.enabled }}
  - name: xtables-lock
    hostPath:
      path: /run/xtables.lock
      type: FileOrCreate
  {{- end }}
{{- end }}
