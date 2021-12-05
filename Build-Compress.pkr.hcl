build {
  name = "Compress"
  source "hyperv-vmcx.hyperv-vmcx.Base-EFI-VMCX" {
    name = "Windows-11-Pro-Base-EFI"
    clone_from_vmcx_path = "Out/${var.windows_11_pro.name}"
    output_directory = "Out/temp/${var.windows_11_pro.name}"
    vm_name = "${var.build.directory}/packer-${var.windows_11_pro.name}"
  }

  source "hyperv-vmcx.hyperv-vmcx.Base-EFI-VMCX" {
    name = "Windows-Server-2022-Datacenter-Core-EFI"
    clone_from_vmcx_path = "Out/${var.server_2022.name}"
    output_directory = "Out/temp/${var.server_2022.name}"
    vm_name = "${var.build.directory}/packer-${var.server_2022.name}"
  }

    post-processor "compress" {
      output = "${var.build.directory}/packer_${source.name}_bundle.zip"
      compression_level = 5
  }
}
