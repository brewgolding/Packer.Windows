packer {
  required_plugins {
    windows-update = {
      version = "0.14.0"
      source = "github.com/rgl/windows-update"
      }
    }
}

variable "iso_checksum" {}
variable "winrm_timeout" {}
variable "iso_url" {}
variable "cpus" {}
variable "disk_size" {}
variable "memory" {}
variable "enable_secure_boot" {}
variable "communicator" {}
variable "secure_boot_template" {}
variable "cd_files" {}
variable "hyperv_shutdown_command" {}
variable switch {}
variable winrm_password {}
variable winrm_username {}

source "hyperv-iso" "Windows-Server-2022-Datacenter-Core-ISO" {
  boot_command         = ["a<wait>a<wait>a<wait>a<wait>a<wait>a<wait>a"]
  boot_wait            = "2s"
  cd_files             = var.cd_files
  cd_label             = "cidata"
  communicator         = var.communicator
  cpus                 = var.cpus
  disk_size            = var.disk_size
  enable_secure_boot   = var.enable_secure_boot
  generation           = 2
  iso_checksum         = "md5:${var.iso_checksum}"
  iso_url              = "${var.iso_url}"
  memory               = var.memory
  secure_boot_template = var.secure_boot_template
  shutdown_command     = var.hyperv_shutdown_command
  switch_name          = var.switch
  winrm_password       = var.winrm_password
  winrm_timeout        = "${var.winrm_timeout}"
  winrm_username       = var.winrm_username
}

build {
  name = "Base-Install"

  source "source.hyperv-iso.Windows-Server-2022-Datacenter-Core-ISO" {
    name = "Windows-Server-Datacenter-Core-VMCX"
  }

  provisioner "windows-update" {
    search_criteria = "IsInstalled=0"
    filters = [
      "exclude:$_.Title -like '*Preview*'",
      "include:$true",
    ]
    update_limit = 100
  }
}
