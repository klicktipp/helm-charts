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
{{- if not .Values.transparentDNS.clusterDNS.namespace -}}
{{- fail "transparentDNS.enabled=true requires transparentDNS.clusterDNS.namespace to be set" -}}
{{- end -}}
{{- if and .Values.transparentDNS.clusterDNS.upstreamService.create (not .Values.transparentDNS.customClusterDNSIP) (empty .Values.transparentDNS.clusterDNS.selector) -}}
{{- fail "transparentDNS.enabled=true with transparentDNS.clusterDNS.upstreamService.create=true requires transparentDNS.clusterDNS.selector to be set" -}}
{{- end -}}
{{- if not .Values.transparentDNS.clusterDomain -}}
{{- fail "transparentDNS.enabled=true requires transparentDNS.clusterDomain to be set" -}}
{{- end -}}
{{- $incoming := default (dict) (get .Values.pdns.config "incoming") -}}
{{- $incomingPort := get $incoming "port" -}}
{{- $incomingListen := default (list) (get $incoming "listen") -}}
{{- if and $incomingListen (not (has "0.0.0.0" $incomingListen)) -}}
{{- fail "transparentDNS.enabled=true requires pdns.config.incoming.listen to include 0.0.0.0 when the listen list is set" -}}
{{- end -}}
{{- if and $incomingPort (ne (toString $incomingPort) (toString .Values.pdns.port)) -}}
{{- fail "transparentDNS.enabled=true requires pdns.port to match pdns.config.incoming.port when the latter is set" -}}
{{- end -}}
{{- if and (not .Values.transparentDNS.customClusterDNSIP) (not .Values.transparentDNS.clusterDNS.upstreamService.clusterIP) -}}
{{- fail "transparentDNS.enabled=true requires either transparentDNS.customClusterDNSIP or transparentDNS.clusterDNS.upstreamService.clusterIP to be set" -}}
{{- end -}}
{{- if eq .Values.transparentDNS.customClusterDNSIP .Values.transparentDNS.clusterDNS.serviceIP -}}
{{- fail "transparentDNS.enabled=true requires transparentDNS.customClusterDNSIP to be different from transparentDNS.clusterDNS.serviceIP to avoid DNS recursion loops" -}}
{{- end -}}
{{- if and .Values.transparentDNS.clusterDNS.upstreamService.clusterIP (eq .Values.transparentDNS.clusterDNS.upstreamService.clusterIP .Values.transparentDNS.clusterDNS.serviceIP) -}}
{{- fail "transparentDNS.enabled=true requires transparentDNS.clusterDNS.upstreamService.clusterIP to be different from transparentDNS.clusterDNS.serviceIP to avoid DNS recursion loops" -}}
{{- end -}}
{{- if and (not .Values.transparentDNS.customClusterDNSIP) .Values.transparentDNS.clusterDNS.upstreamService.create (not .Values.transparentDNS.clusterDNS.upstreamService.clusterIP) -}}
{{- fail "transparentDNS.enabled=true requires transparentDNS.clusterDNS.upstreamService.clusterIP when transparentDNS.clusterDNS.upstreamService.create=true" -}}
{{- end -}}
{{- if and (not .Values.transparentDNS.clusterDNS.upstreamService.create) (not .Values.transparentDNS.customClusterDNSIP) -}}
{{- fail "transparentDNS.enabled=true with transparentDNS.clusterDNS.upstreamService.create=false requires transparentDNS.customClusterDNSIP to be set" -}}
{{- end -}}
{{- $workload := default (dict) (get .Values "workload") -}}
{{- $daemonSet := default (dict) (get $workload "daemonSet") -}}
{{- $updateStrategy := default (dict) (get $daemonSet "updateStrategy") -}}
{{- $rollingUpdate := default (dict) (get $updateStrategy "rollingUpdate") -}}
{{- $maxSurge := get $rollingUpdate "maxSurge" -}}
{{- if and $maxSurge (ne (toString $maxSurge) "0") -}}
{{- fail "transparentDNS.enabled=true requires workload.daemonSet.updateStrategy.rollingUpdate.maxSurge=0 to avoid hostNetwork DaemonSet surge rollouts" -}}
{{- end -}}
{{- end -}}
{{- end }}

{{/*
Effective DaemonSet update strategy with transparent DNS-aware maxSurge default.
*/}}
{{- define "pdns.daemonSetUpdateStrategy" -}}
{{- $strategy := deepCopy (default (dict) .Values.workload.daemonSet.updateStrategy) -}}
{{- $rollingUpdate := default (dict) (get $strategy "rollingUpdate") -}}
{{- $maxSurge := get $rollingUpdate "maxSurge" -}}
{{- $maxUnavailable := get $rollingUpdate "maxUnavailable" -}}
{{- if and .Values.transparentDNS.enabled (eq (toString $maxSurge) "") -}}
{{- $_ := set $rollingUpdate "maxSurge" 0 -}}
{{- else if eq (toString $maxSurge) "" -}}
{{- $_ := set $rollingUpdate "maxSurge" 1 -}}
{{- end -}}
{{- if and .Values.transparentDNS.enabled (eq (toString $maxUnavailable) "0") -}}
{{- $_ := set $rollingUpdate "maxUnavailable" 1 -}}
{{- else if eq (toString $maxUnavailable) "" -}}
{{- $_ := set $rollingUpdate "maxUnavailable" 0 -}}
{{- end -}}
{{- $_ := set $strategy "rollingUpdate" $rollingUpdate -}}
{{- toYaml $strategy -}}
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
Dedicated iptables chain name for transparent DNS interception.
*/}}
{{- define "pdns.transparentDNSChainName" -}}
{{- printf "PDNSDNS-%s" (sha256sum (include "pdns.fullname" .) | trunc 8) -}}
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
{{- $config := deepCopy (default (dict) .Values.pdns.config) -}}
{{- if .Values.transparentDNS.enabled -}}
{{- $recursor := default (dict) (get $config "recursor") -}}
{{- $existing := default (list) (get $recursor "forward_zones_recurse") -}}
{{- $upstreamIP := include "pdns.transparentDNSClusterDNSIP" . -}}
{{- $transparentZones := list .Values.transparentDNS.clusterDomain "in-addr.arpa" "ip6.arpa" -}}
{{- $filtered := list -}}
{{- range $entry := $existing -}}
  {{- if not (and (kindIs "map" $entry) (has (get $entry "zone") $transparentZones)) -}}
    {{- $filtered = append $filtered $entry -}}
  {{- end -}}
{{- end -}}
{{- $zones := list
    (dict "zone" .Values.transparentDNS.clusterDomain "recurse" true "forwarders" (list (printf "%s:53" $upstreamIP)))
    (dict "zone" "in-addr.arpa" "recurse" true "forwarders" (list (printf "%s:53" $upstreamIP)))
    (dict "zone" "ip6.arpa" "recurse" true "forwarders" (list (printf "%s:53" $upstreamIP))) -}}
{{- $_ := set $recursor "forward_zones_recurse" (concat $filtered $zones) -}}
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
        set -eu
        # Enable pipefail when the selected shell supports it.
        (set -o pipefail) 2>/dev/null || true
        {{- if and .Values.transparentDNS.interceptor.enableRuntimeInstall .Values.transparentDNS.interceptor.installPackagesCommand }}
        {{ .Values.transparentDNS.interceptor.installPackagesCommand }}
        {{- else }}
        # Runtime package installation is disabled; the interceptor image must already contain iptables and iproute2/ip.
        {{- end }}

        CHAIN="{{ include "pdns.transparentDNSChainName" . }}"
        PDNS_PORT="{{ .Values.pdns.port }}"
        PDNS_PORT_HEX="$(printf '%04X' "${PDNS_PORT}")"

        is_recursor_ready() {
          grep -qiE "^[[:space:]]*[0-9]+:[[:space:]][0-9A-F]{8,32}:${PDNS_PORT_HEX}[[:space:]]" /proc/net/tcp /proc/net/tcp6 /proc/net/udp /proc/net/udp6 2>/dev/null
        }

        ensure_chain() {
          iptables -t nat -N "${CHAIN}" 2>/dev/null || true
          iptables -t nat -F "${CHAIN}"
          iptables -t nat -A "${CHAIN}" -p udp --dport 53 -j REDIRECT --to-ports "${PDNS_PORT}"
          iptables -t nat -A "${CHAIN}" -p tcp --dport 53 -j REDIRECT --to-ports "${PDNS_PORT}"
        }

        ensure_jump() {
          iptables -t nat -C "$1" -d {{ .Values.transparentDNS.clusterDNS.serviceIP }} -p "$2" --dport 53 -j "${CHAIN}" 2>/dev/null \
            || iptables -t nat -I "$1" 1 -d {{ .Values.transparentDNS.clusterDNS.serviceIP }} -p "$2" --dport 53 -j "${CHAIN}"
        }

        remove_jump() {
          while iptables -t nat -C "$1" -d {{ .Values.transparentDNS.clusterDNS.serviceIP }} -p "$2" --dport 53 -j "${CHAIN}" 2>/dev/null; do
            iptables -t nat -D "$1" -d {{ .Values.transparentDNS.clusterDNS.serviceIP }} -p "$2" --dport 53 -j "${CHAIN}" || true
          done
        }

        install_rules() {
          ensure_chain
          ensure_jump PREROUTING udp
          ensure_jump PREROUTING tcp
          if [ "{{ .Values.transparentDNS.captureOutput }}" = "true" ]; then
            ensure_jump OUTPUT udp
            ensure_jump OUTPUT tcp
          fi
        }

        remove_rules() {
          remove_jump PREROUTING udp
          remove_jump PREROUTING tcp
          if [ "{{ .Values.transparentDNS.captureOutput }}" = "true" ]; then
            remove_jump OUTPUT udp
            remove_jump OUTPUT tcp
          fi
          iptables -t nat -F "${CHAIN}" 2>/dev/null || true
          iptables -t nat -X "${CHAIN}" 2>/dev/null || true
        }

        cleanup() {
          if [ "{{ .Values.transparentDNS.setupIptables }}" = "true" ]; then
            remove_rules
          fi
        }

        signal_handler() {
          cleanup
          exit 0
        }

        trap signal_handler TERM INT
        trap cleanup EXIT

        rules_active=0
        while true; do
          if [ "{{ .Values.transparentDNS.setupIptables }}" = "true" ] && is_recursor_ready; then
            if [ "${rules_active}" -eq 0 ]; then
              install_rules
              rules_active=1
            fi
          else
            if [ "${rules_active}" -eq 1 ]; then
              remove_rules
              rules_active=0
            fi
          fi
          sleep 2
        done
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
