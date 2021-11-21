build {
  name = "Compress"
  source "hyperv-vmcx.hyperv-vmcx.Base-EFI-VMCX" {
    name = "Windows-11-Enterprise-Base-EFI"
    clone_from_vmcx_path = "output-Windows-11-Enterprise-Base-EFI/"
  }
    source "hyperv-vmcx.hyperv-vmcx.Base-EFI-VMCX" {
    name = "Windows-Server-2022-Datacenter-Core-EFI"
    clone_from_vmcx_path = "output-Windows-Server-2022-Datacenter-Core-EFI/"
  }

    post-processor "compress" {
      output = "packer_{{.BuildName}}_bundle.zip"
      compression_level = 5
  }
}
