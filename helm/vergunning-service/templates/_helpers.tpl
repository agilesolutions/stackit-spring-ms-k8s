{{- define "vergunning-service.name" -}}
vergunning-service
{{- end }}

{{- define "vergunning-service.fullname" -}}
{{ include "vergunning-service.name" . }}
{{- end }}