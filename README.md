Production-Grade Cloud Platform on Amazon EKS


Project Overview:

This project demonstrates the design and implementation of a production-ready cloud platform on Amazon EKS, built to replicate the core capabilities of a modern cloud-native environment.

The platform illustrates the automation of infrastructure provisioning, application delivery, security, scaling, and observability through the integration of Terraform, GitHub Actions, ArgoCD, and Kubernetes-native tooling.

The primary objective was to develop an end-to-end cloud-native platform capable of hosting and operating containerised applications through the application of industry-standard DevOps and Platform Engineering practices. Application delivery follows a GitOps approach, enabling declarative, auditable, and automated deployments directly from source control.

Constructed as a production-inspired environment, it provides dynamic scaling, automated DNS and TLS management, integrated security scanning, and end-to-end observability, demonstrating how scalable, secure, and reliable applications can be operated on AWS.

Core Components:
- Amazon EKS for container orchestration
- Terraform for Infrastructure as Code
- GitHub Actions for CI/CD automation
- ArgoCD for GitOps-based deployments
- Karpenter for dynamic node provisioning
- NGINX Ingress Controller for traffic routing
- ExternalDNS for automated Route53 record management
- cert-manager for automated TLS certificate issuance
- Prometheus and Grafana for monitoring and observability
- Trivy and Checkov for security scanning
- Terraform state is stored remotely in an S3 backend.
  
- The application is accessible through a custom domain secured with HTTPS:
https://eks.gnavaei.com

Architecture Overview:

Internet User
       │
       ▼
Route53 (eks.gnavaei.com)
       │
       ▼
AWS Load Balancer
       │
       ▼
NGINX Ingress Controller
       │
       ▼

┌──────────────────────────────┐
│        Amazon EKS            │
│                              │
│  URL Shortener Application   │
│  Redis                       │
│  PostgreSQL                  │
└──────────────────────────────┘


GitHub Repository
       │
       ▼
GitHub Actions
(Build + Trivy)
       │
       ▼
Amazon ECR
       │
       ▼
ArgoCD
       │
       ▼
Amazon EKS


ExternalDNS ───► Route53

Cert Manager ──► Let's Encrypt

Karpenter ─────► EC2 Worker Nodes

Prometheus ────► Grafana

