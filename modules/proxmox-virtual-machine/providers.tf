terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = ">= 0.38.1"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}
