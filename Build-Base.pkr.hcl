packer {
  required_plugins {
    windows-update = {
      version = "0.14.0"
      source = "github.com/rgl/windows-update"
      }
    }
}

build {
  name = "Base-Install"
  source "hyperv-iso.Base-EFI-ISO" {
    name = "Windows-Server-2022-Datacenter-Core-EFI"
    iso_checksum         = "md5:${var.server_2022.iso_checksum}"
    iso_url              = "${var.server_2022.iso_url}"
    cd_files             = [var.server_2022.unattended_xml, var.winrm_setup_script]
    vm_name = "packer-${var.server_2022.name}"
    output_directory = "${var.build.directory}/${var.server_2022.name}"
  }

  source "hyperv-iso.Base-EFI-ISO" {
    name = "Windows-11-Pro-Base-EFI"
    cd_files             = [var.windows_11_pro.unattended_xml, var.winrm_setup_script]
    iso_checksum         = "md5:${var.windows_11_pro.iso_checksum}"
    iso_url              = "${var.windows_11_pro.iso_url}"
    vm_name = "packer-${var.windows_11_pro.name}"
    output_directory = "${var.build.directory}/${var.windows_11_pro.name}"
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
