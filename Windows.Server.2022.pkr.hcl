packer {
  required_plugins {
    windows-update = {
      version = "0.14.0"
      source = "github.com/rgl/windows-update"
      }
    }
}

variable "iso_checksum" {
  type    = string
  default = "FFBCD49D7BD6A1C1A49E830384272BEC"
}

variable "iso_url" {
  type    = string
  default = "ISO/Windows Server 2022.iso"
}

source "hyperv-iso" "Windows-Server-2022-Datacenter-Core" {
  boot_command         = ["a<wait>a<wait>a<wait>a<wait>a<wait>a<wait>a"]
  boot_wait            = "2s"
  cd_files             = ["answer_files/Server.2022/Autounattend.xml", "scripts/winrm.ps1"]
  cd_label             = "cidata"
  communicator         = "winrm"
  cpus                 = 4
  disk_size            = 131072
  enable_secure_boot   = true
  generation           = 2
  iso_checksum         = "md5:${var.iso_checksum}"
  iso_url              = "${var.iso_url}"
  memory               = 2048
  secure_boot_template = "MicrosoftWindows"
  shutdown_command     = "shutdown /s /t 10 /f /d p:4:1 /c Packer_Provisioning_Shutdown"
  switch_name          = "Default Switch"
  winrm_password       = "password"
  winrm_timeout        = "5h"
  winrm_username       = "Administrator"
}

build {
  name = "Basic Install"
  sources = ["source.hyperv-iso.Windows-Server-2022-Datacenter-Core"]

  provisioner "windows-update" {
    search_criteria = "IsInstalled=0"
    filters = [
      "exclude:$_.Title -like '*Preview*'",
      "include:$true",
    ]
    update_limit = 100
  }

  post-processor "compress" {
    output = "${build.name}_Bundle.zip"
    compression_level = 5
  }
}
