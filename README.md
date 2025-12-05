# k8-s Cluster for Kasten

This Terraform project deploys an Amazon EKS cluster configured with EBS CSI driver using IAM Roles for Service Accounts (IRSA) for secure storage access. The setup supports Kasten K10 demonstrations and lectures on Kubernetes data protection.

## Features
- Complete EKS cluster with managed node groups
- EBS CSI driver deployment with IRSA for least-privilege access
- VPC networking with public/private subnets
- S3 bucket provisioning for backups
- Kasten namespace and service account pre-configured
- IAM roles and policies for EKS and EBS operations

## Prerequisites
- AWS CLI configured with appropriate permissions
- Terraform >= 1.5.0
- AWS account with EKS and EC2 quotas available
- kubectl for cluster validation (optional)

## Usage

1. Clone the repository:
```bash
git clone https://github.com/Berracoski/k8-s_Cluster_for_kasten.git
cd k8-s_Cluster_for_kasten
```

2. Configure variables in `terraform.tfvars` or use environment variables:

aws_region = "us-east-1"
cluster_name = "k8s-kasten-demo"

3. Initialize and apply:
```bash
terraform init
terraform plan
terraform apply
```

4. Update kubeconfig:
```bash
aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME
```

## Post-Deployment

Verify EBS CSI driver:

```bash
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-ebs-csi-driver
```

Kasten installation
```bash
kubectl create ns kasten-io
helm repo add kasten https://charts.kasten.io/
helm install k10 kasten/k10 --namespace=kasten-io
```

## Files Overview
| File | Purpose |
|------|---------|
| `eks-cluster.tf` | EKS control plane and add-ons |
| `ebs-csi-driver.tf` | EBS CSI driver with IRSA |
| `vpc.tf` | VPC, subnets, and networking |
| `node-group.tf` | Managed node groups |
| `kasten_namespace_and _SA.tf` | Kasten prerequisites |
| `providers.tf` | AWS and Kubernetes providers |

## Cleanup
```bash
terraform destroy
```

## Kasten Lecture Workflow
1. Deploy cluster with this Terraform code
2. Install Kasten K10 via EKS Add-on or Helm
3. Configure S3 export location using created bucket
4. Demonstrate backup/restore policies

**Note:** Customize variables for production use. Review IAM policies for security.
