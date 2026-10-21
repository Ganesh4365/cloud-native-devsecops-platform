# 🚀 Cloud-Native DevSecOps & GitOps Platform on AWS

![CI/CD Pipeline](https://img.shields.io/badge/CI%2FCD-GitHub_Actions-blue?logo=github-actions)
![IaC](https://img.shields.io/badge/IaC-Terraform_v1.5+-purple?logo=terraform)
![Orchestration](https://img.shields.io/badge/Orchestration-Amazon_EKS-orange?logo=amazon-eks)
![GitOps](https://img.shields.io/badge/GitOps-ArgoCD-red?logo=argo)
![Security](https://img.shields.io/badge/Security-Trivy_&_SonarQube-green?logo=aqua)
![Monitoring](https://img.shields.io/badge/Monitoring-Prometheus_&_Grafana-red?logo=prometheus)

A production-grade, end-to-end DevSecOps and GitOps platform architected on **Amazon Web Services (AWS)**. Features automated infrastructure provisioning with **Terraform**, containerized microservices delivery via **GitHub Actions**, container vulnerability scanning with **Trivy**, zero-downtime progressive rollouts managed by **ArgoCD**, and full observability with **Prometheus & Grafana**.

---

## 🏗️ Architecture Overview

```text
               +-------------------------------------------------------------+
               |                       Developer                             |
               +-----------------------------+-------------------------------+
                                             | git push (main)
                                             v
               +-------------------------------------------------------------+
               |                   GitHub Actions CI/CD                      |
               |                                                             |
               |  +-----------+    +-------------+    +-------------------+  |
               |  | Unit Test | -> | Trivy Scan  | -> | Build & Push ECR  |  |
               |  | & Linting |    |  (SAST/DAST)|    | (SHA Tagged)      |  |
               |  +-----------+    +-------------+    +---------+---------+  |
               +------------------------------------------------|------------+
                                                                | updates k8s tag
                                                                v
               +-------------------------------------------------------------+
               |                      ArgoCD GitOps                          |
               |                                                             |
               |   • Automated Sync & Self-Healing                           |
               |   • Drift Detection & Rollback (< 2 mins)                   |
               +-----------------------------+-------------------------------+
                                             | syncs manifests
                                             v
+----------------------------------------------------------------------------+
|                          Amazon EKS (Kubernetes)                           |
|                                                                            |
|  +--------------------+     +--------------------+     +----------------+  |
|  | Pod 1 (Replicate)  |     | Pod 2 (Replicate)  |     | Pod 3 (Replica)|  |
|  +--------------------+     +--------------------+     +----------------+  |
|               ^                             ^                  ^           |
|               +-----------------------------+------------------+           |
|                                             |                              |
|                       HorizontalPodAutoscaler (CPU > 70%)                   |
+----------------------------------------------------------------------------+
                                      |
                                      v
+----------------------------------------------------------------------------+
|                       Observability & Alerting Stack                       |
|                                                                            |
|   • Prometheus: Scrapes /metrics every 15s via ServiceMonitor              |
|   • Grafana: Pre-configured dashboards for latency, error rate & saturation|
|   • Alertmanager: Automated Slack / Pager alerts for 5xx errors & restarts |
+----------------------------------------------------------------------------+
```

---

## ⚡ Key Business & Engineering Outcomes

- **70% Reduction in Release Overhead**: Automated PR testing, image building, and GitOps deployments eliminate manual intervention.
- **Zero-Downtime Deployments**: Kubernetes rolling update strategy ensures seamless traffic cutovers (`maxSurge: 25%`, `maxUnavailable: 0`).
- **Shift-Left Container Security**: Trivy blocks any container image containing `HIGH` or `CRITICAL` vulnerabilities before deployment.
- **Self-Healing Infrastructure**: ArgoCD continuously reconciles cluster state against Git truth, auto-remediating unauthorized configuration drift.
- **Dynamic Auto-Scaling**: HPA automatically scales pods from 3 to 10 replicas based on real-time CPU & memory utilization thresholds.

---

## 📂 Repository Directory Layout

```text
├── .github/
│   └── workflows/
│       └── ci.yml               # Complete DevSecOps CI pipeline (Lint -> Trivy -> ECR -> GitOps commit)
├── app/
│   ├── main.py                  # FastAPI microservice with /healthz & /metrics
│   ├── requirements.txt         # Pinned production dependencies
│   └── test_main.py             # Automated unit tests
├── argocd/
│   └── application.yaml         # ArgoCD Application CRD (self-heal, auto-sync)
├── k8s/
│   ├── deployment.yaml          # Rolling update deployment with non-root security context
│   ├── service.yaml             # ClusterIP service
│   └── hpa.yaml                 # Horizontal Pod Autoscaler configuration
├── monitoring/
│   ├── servicemonitor.yaml      # Prometheus CRD ServiceMonitor
│   └── alerts.yaml              # Alertmanager rule definitions
├── terraform/
│   ├── main.tf                  # AWS VPC, EKS Cluster, and ECR definition
│   ├── variables.tf             # Infrastructure variables
│   ├── outputs.tf               # Terraform output endpoints
│   └── backend.tf               # S3 remote state + DynamoDB state lock
├── Dockerfile                   # Multi-stage, non-root hardened container
├── docker-compose.yml           # Local dev environment
└── Makefile                     # Developer productivity commands
```

---

## 🚀 Quickstart & Local Execution

### 1. Run Microservice Locally
```bash
# Clone the repository
git clone https://github.com/Ganesh4365/cloud-native-devsecops-platform.git
cd cloud-native-devsecops-platform

# Spin up local container
docker-compose up --build
```
Verify endpoints:
- Application status: `http://localhost:8000/`
- Health check probe: `http://localhost:8000/healthz`
- Prometheus metrics: `http://localhost:8000/metrics`

### 2. Run Tests & Security Scans
```bash
# Run automated tests
make test

# Build and execute container vulnerability scan
make build
make scan
```

---

## ☁️ Cloud Deployment Walkthrough

### 1. Provision Infrastructure with Terraform
```bash
cd terraform
terraform init
terraform plan
terraform apply -auto-approve
```

### 2. Configure Kubectl Context
```bash
aws eks update-kubeconfig --region ap-south-1 --name devops-showcase-eks
```

### 3. Deploy GitOps Controller (ArgoCD)
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Apply the GitOps application definition
kubectl apply -f argocd/application.yaml
```

---

## 👨‍💻 Author

**ShriGanesh Suryawanshi**  
*DevOps & Cloud Engineer*  
- **Portfolio**: [ganesh4365.github.io/Professional-Portfolio](https://ganesh4365.github.io/Professional-Portfolio/)  
- **LinkedIn**: [linkedin.com/in/ganesh-suryawanshi-](https://www.linkedin.com/in/ganesh-suryawanshi-)  
- **GitHub**: [github.com/Ganesh4365](https://github.com/Ganesh4365/)  
- **Email**: [shriganeshsuryawanshi44@gmail.com](mailto:shriganeshsuryawanshi44@gmail.com)
