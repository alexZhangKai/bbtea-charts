{{- define "media-stack.ingress-template" -}}
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ .namePrefix }}-{{ .appName }}-ingress
spec:
  ingressClassName: traefik
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
