source "hyperv-vmcx" "Windows-Server-Datacenter-Core-VMCX" {
  clone_from_vmcx_path = "output-Windows-Server-2022-Datacenter-Core-ISO/"
  communicator         = var.communicator
  cpus                 = var.cpus
  enable_secure_boot   = var.enable_secure_boot
  memory               = var.memory
  secure_boot_template = var.secure_boot_template
  shutdown_command     = var.hyperv_shutdown_command
  switch_name          = var.switch
  winrm_password       = var.winrm_password
  winrm_timeout        = var.winrm_timeout
  winrm_username       = var.winrm_username
}
