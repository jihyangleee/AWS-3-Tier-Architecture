# Terraform 3-Tier Architecture on AWS

AWS 클라우드에서 고가용성 3계층 아키텍처를 Terraform으로 구축하는 IaC 프로젝트입니다.

## 🏗️ Architecture

```mermaid
flowchart TB
    subgraph Internet[" "]
        USER((🌐 Internet))
    end
    
    subgraph AWS["AWS Cloud"]
        subgraph Region["Region - ap-northeast-2"]
            IGW[Internet Gateway]
            
            subgraph VPC["VPC (172.16.0.0/16)"]
                subgraph AZ1["Availability Zone - ap-northeast-2a"]
                    subgraph PUB1["Public Subnet<br/>172.16.1.0/24"]
                        SG1[Security Group]
                        BASTION[🖥️ Bastion]
                    end
                    
                    subgraph PRIV1["Private Subnet<br/>172.16.10.0/24"]
                        SG3[Security Group]
                        APP1[🖥️ EC2]
                    end
                    
                    subgraph DATA1["Private Subnet<br/>172.16.20.0/24"]
                        SG5[Security Group]
                        RDS1[(🗄️ RDS)]
                    end
                end
                
                subgraph AZ2["Availability Zone - ap-northeast-2c"]
                    subgraph PUB2["Public Subnet<br/>172.16.2.0/24"]
                        NAT[🔄 NAT Gateway]
                    end
                    
                    subgraph PRIV2["Private Subnet<br/>172.16.11.0/24"]
                        SG4[Security Group]
                        APP2[🖥️ EC2]
                    end
                    
                    subgraph DATA2["Private Subnet<br/>172.16.21.0/24"]
                        SG6[Security Group]
                        RDS2[(🗄️ RDS)]
                    end
                end
                
                ALB[⚖️ Application Load Balancer]
                ASG[Auto Scaling Group]
                RT[Route Table<br/>172.16.0.0<br/>172.16.1.0<br/>172.16.2.0]
                NACL[🔒 Network ACL]
            end
        end
    end
    
    USER --> IGW
    IGW --> ALB
    IGW --> BASTION
    ALB --> APP1
    ALB --> APP2
    BASTION -.->|SSH| APP1
    BASTION -.->|SSH| APP2
    APP1 --> RDS1
    APP2 --> RDS1
    APP1 --> NAT
    APP2 --> NAT
    NAT --> IGW
    ASG -.- APP1
    ASG -.- APP2
    
    style VPC fill:#e6f3ff,stroke:#0066cc
    style PUB1 fill:#90EE90,stroke:#228B22
    style PUB2 fill:#90EE90,stroke:#228B22
    style PRIV1 fill:#87CEEB,stroke:#4682B4
    style PRIV2 fill:#87CEEB,stroke:#4682B4
    style DATA1 fill:#FFB6C1,stroke:#DC143C
    style DATA2 fill:#FFB6C1,stroke:#DC143C
    style SG1 fill:#FF6B6B,stroke:#CC0000
    style SG3 fill:#FF6B6B,stroke:#CC0000
    style SG4 fill:#FF6B6B,stroke:#CC0000
    style SG5 fill:#FF6B6B,stroke:#CC0000
    style SG6 fill:#FF6B6B,stroke:#CC0000
```

## 📋 Overview

| Tier | Components | Subnet |
|------|------------|--------|
| **Web/Public** | Bastion Host, NAT Gateway, ALB | Public Subnet (172.16.1.0/24, 172.16.2.0/24) |
| **Application** | EC2 Auto Scaling Group | Private Subnet (172.16.10.0/24, 172.16.11.0/24) |
| **Data** | RDS MySQL | Private Subnet (172.16.20.0/24, 172.16.21.0/24) |

## 🌐 Network Configuration

- **VPC CIDR**: `172.16.0.0/16`
- **Availability Zones**: 2개 (ap-northeast-2a, ap-northeast-2c)
- **NAT Gateway**: 1개 (Public Subnet 2)
- **Internet Gateway**: 1개
- **Network ACL**: Private Subnet 보호

### Subnet Layout

| Subnet Type | AZ 1 (ap-northeast-2a) | AZ 2 (ap-northeast-2c) |
|-------------|------------------------|------------------------|
| Public | 172.16.1.0/24 | 172.16.2.0/24 |
| Private (App) | 172.16.10.0/24 | 172.16.11.0/24 |
| Private (Data) | 172.16.20.0/24 | 172.16.21.0/24 |

## 📁 Project Structure

```
.
├── backend/                 # Terraform backend (S3 + DynamoDB)
│   ├── dynamodb.tf
│   ├── provider.tf
│   └── s3.tf
├── dev/                     # Development environment
│   ├── backend.tf
│   ├── main.tf
│   ├── provider.tf
│   ├── variable.tf
│   └── script/
│       └── install_apach.sh
├── staging/                 # Staging environment
│   ├── backend.tf
│   ├── main.tf
│   ├── provider.tf
│   └── variable.tf
├── module/
│   ├── network/             # VPC, Subnet, NAT, IGW, Route Tables, NACL
│   ├── application/         # EC2, ALB, Auto Scaling
│   ├── container/           # ECS, ECR (staging용)
│   └── data/                # RDS, Subnet Group
└── docs/                    # Documentation
```

## 🚀 Getting Started

### Prerequisites

- [Terraform](https://www.terraform.io/downloads) >= 1.0
- AWS CLI configured
- AWS Account with appropriate permissions

### Deployment

1. **Backend 초기화** (최초 1회)
   ```bash
   cd backend
   terraform init
   terraform apply
   ```

2. **환경 배포**
   ```bash
   # Development
   cd dev
   terraform init
   terraform plan
   terraform apply

   # Staging
   cd staging
   terraform init
   terraform plan
   terraform apply
   ```

### Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `environment` | Environment name (dev/staging) | - |
| `database_password` | RDS master password | - |

## 🔒 Security

- **Bastion Host**: Public Subnet에 위치, SSH 접근 제어
- **Application EC2**: Private Subnet에 위치, Bastion을 통해서만 SSH 접근
- **RDS**: Isolated Subnet에 위치, Application 계층에서만 접근 가능
- **ALB**: AWS WAF로 보호, HTTPS 지원

## � References

- [Building a Secure and Scalable Three-Tier Architecture on AWS using CloudFormation](https://repost.aws/articles/ARGpERJ3jISbOAlnmfVUsvMQ/building-a-secure-and-scalable-three-tier-architecture-on-aws-using-cloudformation) - AWS Community
- [Terraform-3-Tier-Architecture](https://github.com/yaini/Terraform-3-Tier-Architecture) - yaini

## �📝 License

This project is licensed under the MIT License.
