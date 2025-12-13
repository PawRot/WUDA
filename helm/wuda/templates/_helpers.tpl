{{/*
Common template helpers
*/}}

{{- define "wuda.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "wuda.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "wuda.componentName" -}}
{{- $root := index . 0 -}}
{{- $component := index . 1 -}}
{{- printf "%s-%s" (include "wuda.fullname" $root) $component | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "wuda.labels" -}}
app.kubernetes.io/name: {{ include "wuda.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
{{- end -}}

{{- define "wuda.backendHostname" -}}
{{- if .Values.frontend.env.BACKEND_HOSTNAME -}}
{{ .Values.frontend.env.BACKEND_HOSTNAME -}}
{{- else -}}
{{ include "wuda.componentName" (list . "backend") -}}
{{- end -}}
{{- end -}}

{{- define "wuda.dbHostname" -}}
{{- if .Values.backend.env.POSTGRES_HOST -}}
{{ .Values.backend.env.POSTGRES_HOST -}}
{{- else -}}
{{ include "wuda.componentName" (list . "db") -}}
{{- end -}}
{{- end -}}
