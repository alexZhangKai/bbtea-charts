{{- define "media-stack.ingress-template" -}}
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ .namePrefix }}-{{ .appName }}-ingress
  namespace: {{ .namespace }}
  annotations:
    kubernetes.io/ingress.class: "kong"
    konghq.com/protocols: https,http
spec:
  rules:
    - host: {{ .appName }}.home.arpa
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: {{ .namePrefix }}-{{ .appName }}-service
                port:
                  number: 80
    - host: {{ .appName }}.bbtea.dev
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: {{ .namePrefix }}-{{ .appName }}-service
                port:
                  number: 80
{{- end }}
