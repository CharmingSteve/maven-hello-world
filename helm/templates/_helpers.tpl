{{/* Generate the name for the application */}}
{{- define "maven-hello-world.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Generate the fullname for the application - this will include the release name and the application name */}}
{{- define "maven-hello-world.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Generate the chart name for the application */}}
{{- define "maven-hello-world.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Generate the labels for the application */}}
{{- define "maven-hello-world.labels" -}}
helm.sh/chart: {{ include "maven-hello-world.chart" . }}
{{ include "maven-hello-world.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/* Generate the selector labels for the application */}}
{{- define "maven-hello-world.selectorLabels" -}}
app.kubernetes.io/name: {{ include "maven-hello-world.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
