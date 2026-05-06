# VPN Multicloud — AWS + GCP + Azure

**Gabriel Pereira Lamata — RM562093 | FIAP Cloud Computing**

---

## Objetivo

Provisionar máquinas virtuais nas três principais clouds (AWS, GCP e Azure) com conectividade segura via SSH, HA VPN (AWS↔GCP) e WireGuard (AWS↔Azure↔GCP), usando Terraform como IaC e GitHub Actions como pipeline CI/CD automatizado.

---

## Stack

| Tecnologia        | Versão / Serviço                            |
|-------------------|---------------------------------------------|
| Terraform         | 1.10+                                       |
| GitHub Actions    | —                                           |
| AWS               | EC2, VPC, Security Groups                   |
| GCP               | Compute Engine, VPC, Firewall Rules         |
| Azure             | Linux VM, VNet, NSG                         |
| Segurança         | Trivy + Checkov                             |

---

## Arquitetura

```
┌─────────────────────────────────────────────────────────────┐
│                    GitHub Actions CI/CD                      │
│         push → branch test → fmt + validate + apply         │
└──────────────┬──────────────┬──────────────┬────────────────┘
               │              │              │
       ┌───────▼──┐   ┌───────▼──┐   ┌──────▼──────┐
       │   AWS    │   │   GCP    │   │    Azure    │
       │ us-east-1│   │ us-east1 │   │   East US   │
       │          │   │          │   │             │
       │  EC2     │   │ Compute  │   │  Linux VM   │
       │ t3.micro │   │ e2-micro │   │  Standard   │
       │          │   │          │   │    B1s      │
       │10.0.0.0  │   │10.128.0.0│   │172.16.0.0   │
       │  /16     │   │  /20     │   │  /16        │
       └────┬─────┘   └────┬─────┘   └──────┬──────┘
            │   HA VPN     │                 │
            │◄─────────────►                 │
            │        WireGuard UDP 51820      │
            │◄────────────────────────────────►
```

**Conexões VPN:**
- **AWS ↔ GCP**: HA VPN (configuração manual pós-apply via console)
- **AWS ↔ Azure ↔ GCP**: WireGuard UDP 51820 (configuração manual pós-apply via `/etc/wireguard/wg0.conf`)

---

## Estrutura de Pastas

```
multicloud-vpn/
├── .github/
│   └── workflows/
│       └── multiprovider.yaml
├── terraform/
│   ├── aws/
│   │   ├── modules/
│   │   │   ├── compute/
│   │   │   │   ├── cloud_init.sh
│   │   │   │   ├── outputs.tf
│   │   │   │   ├── vars.tf
│   │   │   │   └── vm.tf
│   │   │   └── rede/
│   │   │       ├── outputs.tf
│   │   │       ├── vars.tf
│   │   │       └── vpc.tf
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── provider.tf
│   │   └── vars.tf
│   ├── gcp/
│   │   ├── modules/
│   │   │   ├── compute/
│   │   │   │   ├── cloud_init.sh
│   │   │   │   ├── outputs.tf
│   │   │   │   ├── vars.tf
│   │   │   │   └── vm.tf
│   │   │   └── rede/
│   │   │       ├── outputs.tf
│   │   │       ├── vars.tf
│   │   │       └── vpc.tf
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── provider.tf
│   │   └── vars.tf
│   └── azure/
│       ├── modules/
│       │   ├── compute/
│       │   │   ├── cloud_init.sh
│       │   │   ├── outputs.tf
│       │   │   ├── vars.tf
│       │   │   └── vm.tf
│       │   ├── rede/
│       │   │   ├── outputs.tf
│       │   │   ├── vars.tf
│       │   │   └── vnet.tf
│       │   └── rg/
│       │       ├── rg.tf
│       │       └── vars.tf
│       ├── backend.tf
│       ├── main.tf
│       ├── outputs.tf
│       ├── provider.tf
│       └── vars.tf
├── .gitignore
├── LICENSE
└── README.md
```

---

## Pipeline CI/CD

Os quatro jobs (`aws`, `gcp`, `azure`, `security`) rodam em **paralelo** a cada push.

| Branch | Comportamento                                          |
|--------|--------------------------------------------------------|
| `test` | `fmt` + `init` + `validate` + `plan` + **`apply`**    |
| `main` | `fmt` + `init` + `validate` + `plan` (sem apply)      |

---

## Secrets Necessários

Configure no repositório em **Settings → Secrets and variables → Actions**:

| Secret                  | Descrição                                         |
|-------------------------|---------------------------------------------------|
| `AWS_ACCESS_KEY_ID`     | Chave de acesso AWS                               |
| `AWS_SECRET_ACCESS_KEY` | Chave secreta AWS                                 |
| `GCP_CREDENTIALS_JSON`  | JSON completo da service account GCP              |
| `GCP_PROJECT_ID`        | ID do projeto GCP                                 |
| `AZURE_CLIENT_ID`       | Client ID do service principal Azure              |
| `AZURE_CLIENT_SECRET`   | Client secret do service principal Azure          |
| `AZURE_SUBSCRIPTION_ID` | ID da subscription Azure                          |
| `AZURE_TENANT_ID`       | Tenant ID do Azure Active Directory               |
| `SSH_PUBLIC_KEY`        | Chave SSH pública (conteúdo de `~/.ssh/id_rsa.pub`) |

---

## Como Rodar Localmente

### Pré-requisitos

- Terraform 1.10+
- AWS CLI configurado (`aws configure`)
- gcloud CLI autenticado (`gcloud auth application-default login`)
- Azure CLI autenticado (`az login`)

### AWS

```bash
cd terraform/aws
terraform init
terraform plan -var="ssh_public_key=$(cat ~/.ssh/id_rsa.pub)"
terraform apply -var="ssh_public_key=$(cat ~/.ssh/id_rsa.pub)"
```

### GCP

```bash
cd terraform/gcp
terraform init
terraform plan \
  -var="projeto=SEU_PROJECT_ID" \
  -var="ssh_public_key=$(cat ~/.ssh/id_rsa.pub)"
terraform apply \
  -var="projeto=SEU_PROJECT_ID" \
  -var="ssh_public_key=$(cat ~/.ssh/id_rsa.pub)"
```

### Azure

```bash
az login
cd terraform/azure
terraform init
terraform plan -var="ssh_public_key=$(cat ~/.ssh/id_rsa.pub)"
terraform apply -var="ssh_public_key=$(cat ~/.ssh/id_rsa.pub)"
```

---

## Custo Estimado (mensal)

| Cloud    | Recurso                     | Custo Estimado |
|----------|-----------------------------|----------------|
| AWS      | EC2 t3.micro (us-east-1)    | ~$8/mês        |
| GCP      | e2-micro (us-east1)         | ~$5/mês        |
| Azure    | Standard_B1s (East US)      | ~$8/mês        |
| **Total**|                             | **~$21/mês**   |

> Valores aproximados para instâncias sempre ligadas. Execute `terraform destroy` em cada diretório para evitar cobranças quando não estiver usando o ambiente.

---

## Conectividade VPN (pós-Terraform)

> O Terraform provisiona a infraestrutura base — VMs, redes e regras de firewall/NSG. A configuração da conectividade VPN é realizada **manualmente** após o `terraform apply`, conforme o roteiro do lab FIAP "VPN Multicloud: SSH, HA VPN e WireGuard":

**HA VPN — AWS ↔ GCP:**
Configure via console AWS (Virtual Private Gateway + Customer Gateway) e console GCP (Cloud VPN Gateway + VPN Tunnel), usando os IPs públicos das instâncias como endpoints de cada lado.

**WireGuard — AWS ↔ Azure ↔ GCP:**
O WireGuard já está instalado nas três VMs pelo `cloud_init.sh`. A configuração é feita editando `/etc/wireguard/wg0.conf` em cada VM com as chaves e endpoints correspondentes, seguido de `wg-quick up wg0`.

---

## Licença

MIT License — Gabriel Pereira Lamata — RM562093
