{{- define "media-stack.service-template" -}}
---
apiVersion: v1
kind: Service
metadata:
  name: {{ .namePrefix }}-{{ .appName }}-service
spec:
  selector:
    app: {{ .appName }}
  ports:
  {{- range .ports -}}
  {{ if .servicePort }}
    - protocol: {{ .protocol }}
      targetPort: {{ .containerPort }}
      port: {{ .servicePort }}
  {{ end }}
  {{- end -}}
  type: ClusterIP
{{- end -}}
