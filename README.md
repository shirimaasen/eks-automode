# 🧩 EKS Auto Mode + PetClinic + AWS Secrets Manager

This repo provisions a full **EKS Auto Mode cluster** using **Terraform**, deploys the **Spring PetClinic** app via **Helm**, and integrates **AWS Secrets Manager** using **IRSA** and the **CSI driver**.

---

## 📦 Stack Overview

- ☁️ **EKS Auto Mode**
- 🛠 **Terraform** for infrastructure
- 🐳 **Helm** for app deployment
- 🔐 **IRSA + AWS SM + CSI Driver** for secret injection
- 🧪 **GitHub Actions** for CI/CD

---

## ⚙️ Prerequisites

- AWS CLI configured
- Terraform ≥ 1.3
- Helm ≥ 3.9
- GitHub repo with OIDC configured

---

## 🚀 Deployment Steps

### 1. Create your Terraform `backend.tf`

```hcl
terraform {
  backend "s3" {
    bucket         = "your-bucket"
    key            = "eksautomode/terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
    dynamodb_table = "your-lock-table"
  }
}
```

### 2. Add these GitHub Secrets

| Secret Name                | Description                                      |
|---------------------------|--------------------------------------------------|
| `AWS_ACCOUNT_ID`          | Your AWS Account ID                              |
| `AWS_DEFAULT_REGION`      | Region where EKS is deployed (e.g. `eu-north-1`) |
| `TF_BACKEND_BUCKET`       | S3 bucket name for Terraform state               |
| `TF_BACKEND_KEY`          | S3 key path                                      |
| `TF_BACKEND_DDB`          | DynamoDB table for state locking                 |
| `DB_SECRET_USERNAME`      | Username stored in Secrets Manager               |

---

## 🔐 Validating Secrets Injection

```bash
kubectl get pods -n petclinic
kubectl exec -n petclinic <pod> -- env | grep DB_
kubectl exec -n petclinic <pod> -- cat /mnt/secrets/dbuser
kubectl exec -n petclinic <pod> -- cat /mnt/secrets/dbpass
```
