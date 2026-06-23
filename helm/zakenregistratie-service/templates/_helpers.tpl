{{- define "zakenregistratie-service.name" -}}
zakenregistratie-service
{{- end }}

{{- define "zakenregistratie-service.fullname" -}}
{{ include "zakenregistratie-service.name" . }}
{{- end }}