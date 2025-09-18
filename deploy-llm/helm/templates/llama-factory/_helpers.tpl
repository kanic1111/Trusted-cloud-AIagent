{{/*
Expand the name of the chart.
*/}}
{{- define "Trusted-cloud-llm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "Trusted-cloud-llm.fullname" -}}
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
{{- define "Trusted-cloud-llm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "Trusted-cloud-llm.labels" -}}
helm.sh/chart: {{ include "Trusted-cloud-llm.chart" . }}
{{ include "Trusted-cloud-llm.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "Trusted-cloud-llm.selectorLabels" -}}
app.kubernetes.io/name: {{ include "Trusted-cloud-llm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "Trusted-cloud-llm.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "Trusted-cloud-llm.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "llama_factory.renderBashCommand" -}}
    {{- $base := printf "llamafactory-cli %s %s" .cli_args.mode .templatepath }}
    {{- $args := list (printf "%s " $base) }}
    {{- $args = append $args (printf "infer_backend=%s" .cli_args.infer_backend) }}
    {{- if eq .cli_args.infer_backend "vllm" }}
        {{- if .cli_args.vllm }}
            {{- $extra := .cli_args.vllm.extraArgs }}
            {{- $keys := keys $extra | sortAlpha }}
            {{- range $i, $k := $keys }}
                {{- $val := index $extra $k }}
                {{- $item := printf "%s=%v" $k $val }}
                {{- $args = append $args $item }}
            {{- end }}
        {{- end }}
    {{- end }}

    {{- $lastIndex := sub (len $args) 1 }}
    {{- range $i, $line := $args }}
        {{- if lt $i $lastIndex }}
            {{ $line }} \
        {{- else }}
            {{ $line }}
        {{- end }}
    {{- end }}
{{- end }}