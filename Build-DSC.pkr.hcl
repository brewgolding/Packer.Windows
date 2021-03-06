build {
  name = "DSCProvision"
  source "hyperv-vmcx.hyperv-vmcx.Base-EFI-VMCX" {
    name = "Windows-11-Pro-DSC"
    clone_from_vmcx_path = "${var.build.directory}/Base.${var.windows_11_pro.name}"
    output_directory = "${var.build.directory}/${var.windows_11_pro.name}"
    vm_name = "packer-${var.windows_11_pro.name}.DSCProvision"
  }

  source "hyperv-vmcx.hyperv-vmcx.Base-EFI-VMCX" {
    name = "Windows-Server-2022-Datacenter-DSC"
    clone_from_vmcx_path = "${var.build.directory}/Base.${var.server_2022.name}"
    output_directory = "${var.build.directory}/${var.server_2022.name}"
    vm_name = "packer-${var.server_2022.name}.DSCProvision"
  }

  provisioner "file" {
    source = "Configs/"
    destination = "C:/Configs"
  }
  provisioner "powershell" {
    inline = ["Enable-PSTrace -Force; & C:/Configs/BeforeAll.ps1"]
  }
}
