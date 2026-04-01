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
{{- $maxSurgeStr := toString $maxSurge -}}
{{- $maxSurgeNormalized := trimSuffix "%" $maxSurgeStr -}}
{{- if and $maxSurge (ne $maxSurgeNormalized "0") -}}
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
Effective DNS port exposed by the pod.
*/}}
{{- define "pdns.effectiveDNSPort" -}}
{{- if .Values.transparentDNS.enabled -}}
53
{{- else -}}
{{- .Values.pdns.port -}}
{{- end -}}
{{- end }}

{{/*
Dedicated iptables chain name for transparent DNS interception.
*/}}
{{- define "pdns.transparentDNSChainName" -}}
{{- printf "PDNSDNS-%s" (sha256sum (printf "%s-%s" (include "pdns.fullname" .) .Release.Namespace) | trunc 8) -}}
{{- end }}

{{/*
Dedicated raw table chain name for transparent DNS interception.
*/}}
{{- define "pdns.transparentDNSRawChainName" -}}
{{- printf "%s-R" (include "pdns.transparentDNSChainName" .) -}}
{{- end }}

{{/*
Dedicated filter table chain name for transparent DNS interception.
*/}}
{{- define "pdns.transparentDNSFilterChainName" -}}
{{- printf "%s-F" (include "pdns.transparentDNSChainName" .) -}}
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
{{- $incoming := default (dict) (get $config "incoming") -}}
{{- $_ := set $incoming "port" 53 -}}
{{- $_ := set $incoming "listen" (list "0.0.0.0") -}}
{{- $_ := set $config "incoming" $incoming -}}
{{- $recursor := default (dict) (get $config "recursor") -}}
{{- $existing := default (list) (get $recursor "forward_zones") -}}
{{- $upstreamIP := include "pdns.transparentDNSClusterDNSIP" . -}}
{{- $transparentZones := list .Values.transparentDNS.clusterDomain "in-addr.arpa" "ip6.arpa" -}}
{{- $filtered := list -}}
{{- range $entry := $existing -}}
  {{- if not (and (kindIs "map" $entry) (has (get $entry "zone") $transparentZones)) -}}
    {{- $filtered = append $filtered $entry -}}
  {{- end -}}
{{- end -}}
{{- $zones := list
    (dict "zone" .Values.transparentDNS.clusterDomain "forwarders" (list (printf "%s:53" $upstreamIP)))
    (dict "zone" "in-addr.arpa" "forwarders" (list (printf "%s:53" $upstreamIP)))
    (dict "zone" "ip6.arpa" "forwarders" (list (printf "%s:53" $upstreamIP))) -}}
{{- $_ := set $recursor "forward_zones" (concat $filtered $zones) -}}
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
Effective container security context.
*/}}
{{- define "pdns.containerSecurityContext" -}}
{{- $securityContext := deepCopy (default (dict) .Values.securityContext) -}}
{{- if .Values.transparentDNS.enabled -}}
{{- $_ := set $securityContext "runAsUser" 0 -}}
{{- $_ := set $securityContext "runAsGroup" 0 -}}
{{- if hasKey $securityContext "runAsNonRoot" -}}
{{- $_ := set $securityContext "runAsNonRoot" false -}}
{{- end -}}
{{- $capabilities := default (dict) (get $securityContext "capabilities") -}}
{{- $capAdd := default (list) (get $capabilities "add") -}}
{{- if not (has "NET_BIND_SERVICE" $capAdd) -}}
{{- $capAdd = append $capAdd "NET_BIND_SERVICE" -}}
{{- end -}}
{{- $_ := set $capabilities "add" $capAdd -}}
{{- $_ := set $securityContext "capabilities" $capabilities -}}
{{- end -}}
{{- toYaml $securityContext -}}
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
      {{- include "pdns.containerSecurityContext" . | nindent 6 }}
    ports:
      - name: dns-udp
        containerPort: {{ include "pdns.effectiveDNSPort" . | int }}
        protocol: UDP
      - name: dns-tcp
        containerPort: {{ include "pdns.effectiveDNSPort" . | int }}
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

        SERVICE_IP="{{ .Values.transparentDNS.clusterDNS.serviceIP }}"
        SERVICE_CIDR="${SERVICE_IP}/32"
        DNS_PORT="53"
        DNS_PORT_HEX="$(printf '%04X' "${DNS_PORT}")"
        COMMENT_PREFIX="PowerDNS transparent DNS"
        RAW_CHAIN="{{ include "pdns.transparentDNSRawChainName" . }}"
        FILTER_CHAIN="{{ include "pdns.transparentDNSFilterChainName" . }}"
        IPTABLES_WAIT_SECONDS="5"
        SERVICE_IP_HEX=""

        ipt() {
          iptables -w "${IPTABLES_WAIT_SECONDS}" "$@"
        }

        case "${SERVICE_IP}" in
          *.*)
            IFS=.
            set -- ${SERVICE_IP}
            unset IFS
            if [ "$#" -eq 4 ]; then
              SERVICE_IP_HEX="$(printf '%02X%02X%02X%02X' "$4" "$3" "$2" "$1")"
            fi
            ;;
        esac

        is_recursor_ready() {
          if [ -n "${SERVICE_IP_HEX}" ]; then
            grep -qiE "^[[:space:]]*[0-9]+:[[:space:]]*(00000000|${SERVICE_IP_HEX}):${DNS_PORT_HEX}[[:space:]]" /proc/net/tcp /proc/net/udp 2>/dev/null
          else
            grep -qiE "^[[:space:]]*[0-9]+:[[:space:]][0-9A-F]{8,32}:${DNS_PORT_HEX}[[:space:]]" /proc/net/tcp /proc/net/tcp6 /proc/net/udp /proc/net/udp6 2>/dev/null
          fi
        }

        has_local_service_ip() {
          ip -o addr show dev lo to "${SERVICE_CIDR}" >/dev/null 2>&1
        }

        ensure_local_service_ip() {
          has_local_service_ip || ip addr add "${SERVICE_CIDR}" dev lo
        }

        remove_local_service_ip() {
          has_local_service_ip && ip addr del "${SERVICE_CIDR}" dev lo || true
        }

        ensure_raw_chain() {
          ipt -t raw -N "${RAW_CHAIN}" 2>/dev/null || true
          ipt -t raw -F "${RAW_CHAIN}"
          ipt -t raw -A "${RAW_CHAIN}" -d "${SERVICE_IP}" -p udp --dport "${DNS_PORT}" -m comment --comment "${COMMENT_PREFIX}: skip conntrack" -j NOTRACK
          ipt -t raw -A "${RAW_CHAIN}" -d "${SERVICE_IP}" -p tcp --dport "${DNS_PORT}" -m comment --comment "${COMMENT_PREFIX}: skip conntrack" -j NOTRACK
          if [ "{{ .Values.transparentDNS.captureOutput }}" = "true" ]; then
            ipt -t raw -A "${RAW_CHAIN}" -s "${SERVICE_IP}" -p udp --sport "${DNS_PORT}" -m comment --comment "${COMMENT_PREFIX}: skip conntrack" -j NOTRACK
            ipt -t raw -A "${RAW_CHAIN}" -s "${SERVICE_IP}" -p tcp --sport "${DNS_PORT}" -m comment --comment "${COMMENT_PREFIX}: skip conntrack" -j NOTRACK
          fi
        }

        ensure_filter_chain() {
          ipt -t filter -N "${FILTER_CHAIN}" 2>/dev/null || true
          ipt -t filter -F "${FILTER_CHAIN}"
          ipt -t filter -A "${FILTER_CHAIN}" -d "${SERVICE_IP}" -p udp --dport "${DNS_PORT}" -m comment --comment "${COMMENT_PREFIX}: allow DNS traffic" -j ACCEPT
          ipt -t filter -A "${FILTER_CHAIN}" -d "${SERVICE_IP}" -p tcp --dport "${DNS_PORT}" -m comment --comment "${COMMENT_PREFIX}: allow DNS traffic" -j ACCEPT
          ipt -t filter -A "${FILTER_CHAIN}" -s "${SERVICE_IP}" -p udp --sport "${DNS_PORT}" -m comment --comment "${COMMENT_PREFIX}: allow DNS traffic" -j ACCEPT
          ipt -t filter -A "${FILTER_CHAIN}" -s "${SERVICE_IP}" -p tcp --sport "${DNS_PORT}" -m comment --comment "${COMMENT_PREFIX}: allow DNS traffic" -j ACCEPT
        }

        ensure_jump() {
          table_name="$1"
          proto="$2"
          table_chain="$3"
          target_chain="$4"
          match_direction="$5"
          case "${match_direction}" in
            destination)
              shift_args="-d ${SERVICE_IP} --dport ${DNS_PORT}"
              ;;
            source)
              shift_args="-s ${SERVICE_IP} --sport ${DNS_PORT}"
              ;;
            *)
              echo "unsupported jump match direction: ${match_direction}" >&2
              exit 1
              ;;
          esac
          # shellcheck disable=SC2086
          ipt -t "${table_name}" -C "${table_chain}" -p "${proto}" ${shift_args} -m comment --comment "${COMMENT_PREFIX}: jump" -j "${target_chain}" 2>/dev/null \
            || ipt -t "${table_name}" -I "${table_chain}" 1 -p "${proto}" ${shift_args} -m comment --comment "${COMMENT_PREFIX}: jump" -j "${target_chain}"
        }

        remove_jump() {
          table_name="$1"
          proto="$2"
          table_chain="$3"
          target_chain="$4"
          match_direction="$5"
          case "${match_direction}" in
            destination)
              shift_args="-d ${SERVICE_IP} --dport ${DNS_PORT}"
              ;;
            source)
              shift_args="-s ${SERVICE_IP} --sport ${DNS_PORT}"
              ;;
            *)
              echo "unsupported jump match direction: ${match_direction}" >&2
              exit 1
              ;;
          esac
          # shellcheck disable=SC2086
          while ipt -t "${table_name}" -C "${table_chain}" -p "${proto}" ${shift_args} -m comment --comment "${COMMENT_PREFIX}: jump" -j "${target_chain}" 2>/dev/null; do
            ipt -t "${table_name}" -D "${table_chain}" -p "${proto}" ${shift_args} -m comment --comment "${COMMENT_PREFIX}: jump" -j "${target_chain}" || true
          done
        }

        install_rules() {
          ensure_local_service_ip
          ensure_raw_chain
          ensure_filter_chain
          ensure_jump raw udp PREROUTING "${RAW_CHAIN}" destination
          ensure_jump raw tcp PREROUTING "${RAW_CHAIN}" destination
          if [ "{{ .Values.transparentDNS.captureOutput }}" = "true" ]; then
            ensure_jump raw udp OUTPUT "${RAW_CHAIN}" destination
            ensure_jump raw tcp OUTPUT "${RAW_CHAIN}" destination
          fi
          ensure_jump raw udp OUTPUT "${RAW_CHAIN}" source
          ensure_jump raw tcp OUTPUT "${RAW_CHAIN}" source
          ensure_jump filter udp INPUT "${FILTER_CHAIN}" destination
          ensure_jump filter tcp INPUT "${FILTER_CHAIN}" destination
          ensure_jump filter udp OUTPUT "${FILTER_CHAIN}" source
          ensure_jump filter tcp OUTPUT "${FILTER_CHAIN}" source
        }

        remove_rules() {
          remove_jump raw udp PREROUTING "${RAW_CHAIN}" destination
          remove_jump raw tcp PREROUTING "${RAW_CHAIN}" destination
          if [ "{{ .Values.transparentDNS.captureOutput }}" = "true" ]; then
            remove_jump raw udp OUTPUT "${RAW_CHAIN}" destination
            remove_jump raw tcp OUTPUT "${RAW_CHAIN}" destination
          fi
          remove_jump raw udp OUTPUT "${RAW_CHAIN}" source
          remove_jump raw tcp OUTPUT "${RAW_CHAIN}" source
          remove_jump filter udp INPUT "${FILTER_CHAIN}" destination
          remove_jump filter tcp INPUT "${FILTER_CHAIN}" destination
          remove_jump filter udp OUTPUT "${FILTER_CHAIN}" source
          remove_jump filter tcp OUTPUT "${FILTER_CHAIN}" source
          ipt -t raw -F "${RAW_CHAIN}" 2>/dev/null || true
          ipt -t raw -X "${RAW_CHAIN}" 2>/dev/null || true
          ipt -t filter -F "${FILTER_CHAIN}" 2>/dev/null || true
          ipt -t filter -X "${FILTER_CHAIN}" 2>/dev/null || true
          remove_local_service_ip
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
