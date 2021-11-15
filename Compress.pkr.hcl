build {
  name = "Compress"
  source "hyperv-vmcx.Windows-Server-Datacenter-Core-VMCX" {
    name = "Windows-Server-Datacenter-Core-VMCX"
  }

    post-processor "compress" {
      output = "packer_{{.BuildName}}_bundle.zip"
      compression_level = 5
  }
}
