{{- define "media-stack.deployment-template" -}}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .namePrefix }}-{{ .appName }}-deployment
spec:
  replicas: {{ .replicaCount | default 1 }}
  selector:
    matchLabels:
      app: {{ .appName }}
  template:
    metadata:
      labels:
        app: {{ .appName }}
    spec:
      nodeName: {{ .nodeName }}
      containers:
      - name: {{ .appName }}
        image: "{{ .image }}"
        ports:
        {{- range .ports }}
          - name: {{ .name }}
            containerPort: {{ .containerPort }}
        {{- end }}
        env:
        {{- range .env }}
          - name: "{{ .name }}"
            value: "{{ .value }}"
        {{- end }}
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "1000m"
        volumeMounts:
        {{- range .volumes }}
        - name: {{ .name }}
          mountPath: {{ .mountPath }}
        {{- end }}
      volumes:
      {{- range .volumes }}
      - name: {{ .name }}
        {{- if eq .type "hostPath"  }}
        hostPath:
          path: {{ .hostPath }}
          type: Directory
        {{- end }}
      {{- end }}
{{- end }}
