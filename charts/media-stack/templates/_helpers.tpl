{{/*
Expand the name of the chart.
*/}}
{{- define "media-stack.name-prefix" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

