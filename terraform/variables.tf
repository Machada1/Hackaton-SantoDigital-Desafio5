variable "project_id" {
  description = "HackatonSD"
  type        = string
}

variable "region" {
  description = "Região do GCP"
  default     = "us-central1"
}

variable "zone" {
  description = "Zona do GCP"
  default     = "us-central1-a"
}

variable "subnet1_cidr" {
  description = "CIDR para a primeira sub-rede"
  default     = "192.168.1.0/24"
}

variable "subnet2_cidr" {
  description = "CIDR para a segunda sub-rede"
  default     = "10.152.0.0/24"
}

variable "instance_types" {
  description = "Tipos de instâncias para as VMs"
  default     = {
    "vm-instance-01" = "e2-medium"
    "vm-instance-02" = "e2-medium"
  }
}
