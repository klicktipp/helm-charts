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
{{- if not .Values.transparentDNS.localIP -}}
{{- fail "transparentDNS.enabled=true requires transparentDNS.localIP to be set to a dedicated node-local DNS IP" -}}
{{- end -}}
{{- if and .Values.transparentDNS.takeoverClusterIP (not .Values.transparentDNS.clusterDNS.serviceIP) -}}
{{- fail "transparentDNS.enabled=true with transparentDNS.takeoverClusterIP=true requires transparentDNS.clusterDNS.serviceIP to be set to the kube-dns/CoreDNS Service IP" -}}
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
{{- if and .Values.transparentDNS.clusterDNS.serviceIP (eq .Values.transparentDNS.localIP .Values.transparentDNS.clusterDNS.serviceIP) -}}
{{- fail "transparentDNS.enabled=true requires transparentDNS.localIP to be different from transparentDNS.clusterDNS.serviceIP" -}}
{{- end -}}
{{- if and .Values.service.enabled .Values.service.clusterIP (eq .Values.transparentDNS.localIP .Values.service.clusterIP) -}}
{{- fail "transparentDNS.enabled=true requires transparentDNS.localIP to be different from service.clusterIP" -}}
{{- end -}}
{{- if and .Values.service.local.enabled .Values.service.local.clusterIP (eq .Values.transparentDNS.localIP .Values.service.local.clusterIP) -}}
{{- fail "transparentDNS.enabled=true requires transparentDNS.localIP to be different from service.local.clusterIP" -}}
{{- end -}}
{{- if and .Values.transparentDNS.clusterDNS.serviceIP (eq .Values.transparentDNS.customClusterDNSIP .Values.transparentDNS.clusterDNS.serviceIP) -}}
{{- fail "transparentDNS.enabled=true requires transparentDNS.customClusterDNSIP to be different from transparentDNS.clusterDNS.serviceIP to avoid DNS recursion loops" -}}
{{- end -}}
{{- if and .Values.service.enabled .Values.service.clusterIP .Values.transparentDNS.clusterDNS.serviceIP (eq .Values.service.clusterIP .Values.transparentDNS.clusterDNS.serviceIP) -}}
{{- fail "transparentDNS.enabled=true requires service.clusterIP to be different from transparentDNS.clusterDNS.serviceIP" -}}
{{- end -}}
{{- if and .Values.service.local.enabled .Values.service.local.clusterIP .Values.transparentDNS.clusterDNS.serviceIP (eq .Values.service.local.clusterIP .Values.transparentDNS.clusterDNS.serviceIP) -}}
{{- fail "transparentDNS.enabled=true requires service.local.clusterIP to be different from transparentDNS.clusterDNS.serviceIP" -}}
{{- end -}}
{{- if and .Values.service.enabled .Values.service.clusterIP .Values.service.local.enabled .Values.service.local.clusterIP (eq .Values.service.clusterIP .Values.service.local.clusterIP) -}}
{{- fail "transparentDNS.enabled=true requires service.clusterIP to be different from service.local.clusterIP" -}}
{{- end -}}
{{- if and .Values.transparentDNS.clusterDNS.upstreamService.clusterIP (eq .Values.transparentDNS.clusterDNS.upstreamService.clusterIP .Values.transparentDNS.clusterDNS.serviceIP) -}}
{{- fail "transparentDNS.enabled=true requires transparentDNS.clusterDNS.upstreamService.clusterIP to be different from transparentDNS.clusterDNS.serviceIP to avoid DNS recursion loops" -}}
{{- end -}}
{{- if eq .Values.transparentDNS.localIP .Values.transparentDNS.customClusterDNSIP -}}
{{- fail "transparentDNS.enabled=true requires transparentDNS.localIP to be different from transparentDNS.customClusterDNSIP to avoid DNS recursion loops" -}}
{{- end -}}
{{- if and .Values.transparentDNS.clusterDNS.upstreamService.clusterIP (eq .Values.transparentDNS.localIP .Values.transparentDNS.clusterDNS.upstreamService.clusterIP) -}}
{{- fail "transparentDNS.enabled=true requires transparentDNS.localIP to be different from transparentDNS.clusterDNS.upstreamService.clusterIP to avoid DNS recursion loops" -}}
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
{{- if and .Values.service.local.enabled (ne (include "pdns.workloadType" .) "DaemonSet") -}}
{{- fail "service.local.enabled=true requires workload.type=DaemonSet" -}}
{{- end -}}
{{- if and .Values.service.local.enabled (not .Values.service.local.clusterIP) -}}
{{- fail "service.local.enabled=true requires service.local.clusterIP to be set" -}}
{{- end -}}
{{- if .Values.service.internalTrafficPolicy -}}
{{- fail "service.internalTrafficPolicy is not supported on the primary service; use service.local.enabled=true with service.local.clusterIP for node-local routing" -}}
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
Optional primary PowerDNS Service ClusterIP to keep directly reachable in transparent DNS mode.
*/}}
{{- define "pdns.transparentDNSPrimaryServiceIP" -}}
{{- if and .Values.service.enabled .Values.service.clusterIP -}}
{{- .Values.service.clusterIP -}}
{{- end -}}
{{- end }}

{{/*
Optional local-only PowerDNS Service ClusterIP to keep directly reachable in transparent DNS mode.
*/}}
{{- define "pdns.transparentDNSSecondaryServiceIP" -}}
{{- if and .Values.service.local.enabled .Values.service.local.clusterIP -}}
{{- .Values.service.local.clusterIP -}}
{{- end -}}
{{- end }}

{{/*
Explicit listen addresses for transparent DNS mode.
*/}}
{{- define "pdns.transparentDNSListenAddresses" -}}
{{- $listen := list .Values.transparentDNS.localIP -}}
{{- if and .Values.transparentDNS.takeoverClusterIP .Values.transparentDNS.clusterDNS.serviceIP -}}
{{- $listen = append $listen .Values.transparentDNS.clusterDNS.serviceIP -}}
{{- end -}}
{{- $primaryServiceIP := include "pdns.transparentDNSPrimaryServiceIP" . | trim -}}
{{- if and $primaryServiceIP (not (has $primaryServiceIP $listen)) -}}
{{- $listen = append $listen $primaryServiceIP -}}
{{- end -}}
{{- $secondaryServiceIP := include "pdns.transparentDNSSecondaryServiceIP" . | trim -}}
{{- if and $secondaryServiceIP (not (has $secondaryServiceIP $listen)) -}}
{{- $listen = append $listen $secondaryServiceIP -}}
{{- end -}}
{{- toYaml $listen -}}
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
Private reverse lookup zones forwarded to CoreDNS in transparent DNS mode.
*/}}
{{- define "pdns.transparentDNSPrivateReverseZones" -}}
{{- $zones := list
    "10.in-addr.arpa"
    "16.172.in-addr.arpa"
    "17.172.in-addr.arpa"
    "18.172.in-addr.arpa"
    "19.172.in-addr.arpa"
    "20.172.in-addr.arpa"
    "21.172.in-addr.arpa"
    "22.172.in-addr.arpa"
    "23.172.in-addr.arpa"
    "24.172.in-addr.arpa"
    "25.172.in-addr.arpa"
    "26.172.in-addr.arpa"
    "27.172.in-addr.arpa"
    "28.172.in-addr.arpa"
    "29.172.in-addr.arpa"
    "30.172.in-addr.arpa"
    "31.172.in-addr.arpa"
    "168.192.in-addr.arpa"
    "c.f.ip6.arpa"
    "d.f.ip6.arpa" -}}
{{- toYaml $zones -}}
{{- end }}

{{/*
Rendered PDNS config with transparent DNS forwarding when enabled.
*/}}
{{- define "pdns.config" -}}
{{- $config := deepCopy (default (dict) .Values.pdns.config) -}}
{{- if .Values.transparentDNS.enabled -}}
{{- $incoming := default (dict) (get $config "incoming") -}}
{{- $_ := set $incoming "port" 53 -}}
{{- $_ := set $incoming "listen" (fromYamlArray (include "pdns.transparentDNSListenAddresses" .)) -}}
{{- $_ := set $config "incoming" $incoming -}}
{{- $recursor := default (dict) (get $config "recursor") -}}
{{- $existing := default (list) (get $recursor "forward_zones") -}}
{{- $upstreamIP := include "pdns.transparentDNSClusterDNSIP" . -}}
{{- $privateReverseZones := fromYamlArray (include "pdns.transparentDNSPrivateReverseZones" .) -}}
{{- $transparentZones := concat (list .Values.transparentDNS.clusterDomain) $privateReverseZones -}}
{{- $filtered := list -}}
{{- range $entry := $existing -}}
  {{- if not (and (kindIs "map" $entry) (has (get $entry "zone") $transparentZones)) -}}
    {{- $filtered = append $filtered $entry -}}
  {{- end -}}
{{- end -}}
{{- $zones := list (dict "zone" .Values.transparentDNS.clusterDomain "forwarders" (list (printf "%s:53" $upstreamIP))) -}}
{{- range $zone := $privateReverseZones -}}
{{- $zones = append $zones (dict "zone" $zone "forwarders" (list (printf "%s:53" $upstreamIP))) -}}
{{- end -}}
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
{{- if .Values.transparentDNS.enabled }}
initContainers:
  - name: dns-interceptor-init
    image: "{{ .Values.transparentDNS.interceptor.image.repository }}:{{ .Values.transparentDNS.interceptor.image.tag }}"
    imagePullPolicy: {{ .Values.transparentDNS.interceptor.image.pullPolicy }}
    securityContext:
      {{- toYaml .Values.transparentDNS.securityContext | nindent 6 }}
    command:
      - /usr/local/bin/init.sh
    env:
      - name: LOCAL_IP
        value: {{ .Values.transparentDNS.localIP | quote }}
      - name: SERVICE_IP
        value: {{ .Values.transparentDNS.clusterDNS.serviceIP | quote }}
      - name: PRIMARY_SERVICE_IP
        value: {{ include "pdns.transparentDNSPrimaryServiceIP" . | trim | quote }}
      - name: ADDITIONAL_SERVICE_IP
        value: {{ include "pdns.transparentDNSSecondaryServiceIP" . | trim | quote }}
      - name: TAKEOVER_CLUSTER_IP
        value: {{ ternary "true" "false" .Values.transparentDNS.takeoverClusterIP | quote }}
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
    {{- if .Values.transparentDNS.enabled }}
    startupProbe:
      tcpSocket:
        host: {{ .Values.transparentDNS.localIP | quote }}
        port: dns-tcp
      initialDelaySeconds: {{ .Values.probes.startup.initialDelaySeconds }}
      periodSeconds: {{ .Values.probes.startup.periodSeconds }}
      timeoutSeconds: {{ .Values.probes.startup.timeoutSeconds }}
      failureThreshold: {{ .Values.probes.startup.failureThreshold }}
    {{- end }}
    livenessProbe:
      tcpSocket:
        {{- if .Values.transparentDNS.enabled }}
        host: {{ .Values.transparentDNS.localIP | quote }}
        {{- end }}
        port: dns-tcp
      initialDelaySeconds: {{ .Values.probes.liveness.initialDelaySeconds }}
      periodSeconds: {{ .Values.probes.liveness.periodSeconds }}
      timeoutSeconds: {{ .Values.probes.liveness.timeoutSeconds }}
      failureThreshold: {{ .Values.probes.liveness.failureThreshold }}
    readinessProbe:
      tcpSocket:
        {{- if .Values.transparentDNS.enabled }}
        host: {{ .Values.transparentDNS.localIP | quote }}
        {{- end }}
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
      - /usr/local/bin/interceptor.sh
    env:
      - name: LOCAL_IP
        value: {{ .Values.transparentDNS.localIP | quote }}
      - name: SERVICE_IP
        value: {{ .Values.transparentDNS.clusterDNS.serviceIP | quote }}
      - name: PRIMARY_SERVICE_IP
        value: {{ include "pdns.transparentDNSPrimaryServiceIP" . | trim | quote }}
      - name: ADDITIONAL_SERVICE_IP
        value: {{ include "pdns.transparentDNSSecondaryServiceIP" . | trim | quote }}
      - name: TAKEOVER_CLUSTER_IP
        value: {{ ternary "true" "false" .Values.transparentDNS.takeoverClusterIP | quote }}
      - name: DNS_PORT
        value: "53"
      - name: COMMENT_PREFIX
        value: "PowerDNS transparent DNS"
      - name: RAW_CHAIN
        value: {{ include "pdns.transparentDNSRawChainName" . | quote }}
      - name: FILTER_CHAIN
        value: {{ include "pdns.transparentDNSFilterChainName" . | quote }}
      - name: IPTABLES_WAIT_SECONDS
        value: "5"
      - name: SETUP_IPTABLES
        value: {{ ternary "true" "false" .Values.transparentDNS.setupIptables | quote }}
      - name: CAPTURE_OUTPUT
        value: {{ ternary "true" "false" .Values.transparentDNS.captureOutput | quote }}
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
