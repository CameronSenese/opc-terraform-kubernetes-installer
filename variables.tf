# Build Kubernetes based on the Oracle Linux Container Services for use with Kubernetes.
# Oracle Container Services for use with Kubernetes version 1.1.9 is based on Kubernetes version 1.9.1, as released upstream.
# Developer branch is is based on Kubernetes version v1.11.3, as released upstream.

### Credentials ###
  variable "ociUser" {
      description = "Username - OCI-Classic user account with Compute_Operations rights"
  }
  variable "ociPass" {
      description = "Password - OCI-Classic user account with Compute_Operations rights"
  }
  variable "idDomain" {
      description = "Platform version dependent - Either tenancy ID Domain or Compute Service Instance ID"
  }
  variable "apiEndpoint" {
      description = "OCI-Classic Compute tenancy REST Endpoint URL"
  }
  variable "containerRepoUser" {
      description = "Username - Oracle Container Registry"
  }
  variable "containerRepoPass" {
      description = "Password - Oracle Container Registry"
  }

### Version ###
  variable "verDeveloper" {
      description = "Install Kubernetes from the Developer preview branch (More recent version, however Oracle suggests these not be used in production.)"
  }

### Environments ###
  variable "envDashMonMet" {
      description = "Enhanced Monitoring and Metrics (Grafana, Heapster, & InfluxDB)"
  }
  variable "envIngress" {
      description = "Kubernetes Ingress (Include Traefik Ingress and sample applications)"
  }
  variable "envMicroSvc" {
      description = "Microservices Environment (Include WeaveScope Dashbord and E-Commerce application)"
  }
  variable "envSvcMesh" {
      description = "Service Mesh (Include Istio & BookInfo application)"
  }

### Keys ###
  variable ssh_user {
    description = "Username - Account for ssh access to the image"
    default     = "opc"
  }
  variable ssh_private_key {
    description = "File location of the ssh private key"
    default     = "./ssh/id_rsa"
  }
  variable ssh_public_key {
    description = "File location of the ssh public key"
    default     = "./ssh/id_rsa.pub"
  }
