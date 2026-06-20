Production-Grade Cloud Platform on Amazon EKS


## Project Overview:

This project demonstrates the design and implementation of a production-ready cloud platform on Amazon EKS, built to replicate the core capabilities of a modern cloud-native environment.

The platform illustrates the automation of infrastructure provisioning, application delivery, security, scaling, and observability through the integration of Terraform, GitHub Actions, ArgoCD, and Kubernetes-native tooling.

The primary objective was to develop an end-to-end cloud-native platform capable of hosting and operating containerised applications through the application of industry-standard DevOps and Platform Engineering practices. Application delivery follows a GitOps approach, enabling declarative, auditable, and automated deployments directly from source control.

Constructed as a production-inspired environment, it provides dynamic scaling, automated DNS and TLS management, integrated security scanning, and end-to-end observability, demonstrating how scalable, secure, and reliable applications can be operated on AWS.

## Core Components

- Amazon EKS for container orchestration
- Terraform for Infrastructure as Code
- GitHub Actions for CI/CD automation
- ArgoCD for GitOps-based deployments
- Karpenter for dynamic node provisioning
- NGINX Ingress Controller for traffic routing
- ExternalDNS for automated Route53 record management
- cert-manager for automated TLS certificate issuance
- Prometheus and Grafana for monitoring and observability
  
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

## Infrastructure Provisioning

The platform infrastructure was provisioned using Terraform, enabling a fully repeatable, version-controlled, and automated deployment process.

A modular Infrastructure as Code (IaC) approach was adopted to improve maintainability and separation of concerns. Individual Terraform modules were used to provision networking, Amazon EKS, Karpenter, ExternalDNS, and GitHub Actions OIDC integration, allowing infrastructure components to be managed independently while remaining reusable and scalable.

The environment was deployed within a custom Amazon Virtual Private Cloud (VPC) spanning multiple Availability Zones to provide high availability and fault tolerance. The network architecture consisted of both public and private subnets, with public subnets supporting ingress traffic and load balancers, while private subnets hosted Kubernetes worker nodes and application workloads.

Key infrastructure resources provisioned through Terraform included:

- Amazon VPC
- Public and Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- Amazon EKS Cluster
- Managed Node Groups
- IAM Roles and Policies
- Karpenter Node Provisioning Resources
- ExternalDNS IAM Resources
- GitHub Actions OIDC Integration

Terraform state was stored remotely in Amazon S3, providing centralised state management and enabling consistent infrastructure lifecycle operations.

## Terraform Module Structure

Infrastructure was organised into dedicated Terraform modules to separate responsibilities and simplify maintenance:

- VPC Module – networking resources and routing
- EKS Module – cluster and node group provisioning
- Karpenter Module – dynamic node provisioning resources
- ExternalDNS Module – DNS automation permissions
- GitHub Actions Module – OIDC federation and CI/CD permissions

This modular structure improved reusability and reduced complexity as the platform evolved.

## CI/CD Pipeline

Continuous Integration and Continuous Deployment (CI/CD) was implemented using GitHub Actions to automate application delivery and infrastructure validation.

The platform uses OpenID Connect (OIDC) federation to securely authenticate GitHub Actions with AWS, eliminating the need for long-lived access keys and improving overall security.

### Application Deployment Workflow

The application deployment pipeline is triggered when changes are pushed to the repository.

The workflow performs the following steps:

1. Checkout the source code
2. Authenticate to AWS using GitHub OIDC
3. Build the Docker container image
4. Perform vulnerability scanning using Trivy
5. Push the image to Amazon ECR

This automated workflow ensures that application images are consistently built, validated, and stored within a central container registry before deployment.

## Infrastructure Quality Gates

A separate GitHub Actions workflow was implemented to validate Infrastructure as Code changes before deployment.

The workflow performs:

1. Terraform formatting validation
2. Terraform configuration validation
3. Terraform plan generation
4. Checkov security scanning

This approach helps identify configuration errors and security misconfigurations early in the development lifecycle.
## GitOps Deployment

Application deployments were managed using ArgoCD, enabling a GitOps-based approach to Kubernetes application delivery.

ArgoCD continuously monitored the Git repository for changes and ensured that the running state of the cluster matched the desired state defined within version control. This provided automated deployment, drift detection, and self-healing capabilities without requiring manual intervention within the cluster.

The application manifests were stored within the repository and synchronised to Amazon EKS through ArgoCD. When changes were committed to GitHub, ArgoCD automatically detected the updates and reconciled the cluster to the latest desired configuration.

## GitOps Workflow

1. Changes are committed and pushed to GitHub
2. ArgoCD detects repository updates
3. Kubernetes manifests are synchronised
4. Amazon EKS is updated to the desired state
5. ArgoCD continuously monitors for configuration drift

This approach ensured that the Git repository remained the single source of truth for Kubernetes deployments, improving consistency, traceability, and operational reliability.

## Security

Security was integrated throughout the platform using secure authentication, automated validation, and encrypted communication.

GitHub Actions authenticated with AWS using OpenID Connect (OIDC), eliminating the need for long-lived access keys. Security checks were incorporated into the CI/CD pipeline using Trivy for container vulnerability scanning and Checkov for Infrastructure as Code validation.

External traffic was secured using HTTPS, with Cert Manager automating TLS certificate provisioning and renewal through Let's Encrypt.

## Monitoring & Observability

Platform observability was implemented using Prometheus and Grafana, providing real-time visibility into cluster health, resource utilisation, and application performance.
Metrics were collected from Kubernetes nodes and workloads, enabling monitoring of CPU, memory, networking, and pod-level activity. Grafana dashboards were used to visualise operational metrics and support troubleshooting, capacity planning, and platform health monitoring.

## Project Outcomes

This project successfully delivered a cloud-native application platform on Amazon EKS using modern DevOps and Platform Engineering practices.
The platform demonstrated Infrastructure as Code through Terraform, automated application delivery through GitHub Actions and ArgoCD, secure external access through automated TLS certificate management, dynamic node provisioning with Karpenter, and operational visibility through Prometheus and Grafana.
By combining IaC, GitOps, CI/CD, security validation, monitoring, and cloud-native infrastructure, the project provided a practical implementation of a production-inspired Kubernetes platform that can be consistently deployed, managed, and scaled through code.



