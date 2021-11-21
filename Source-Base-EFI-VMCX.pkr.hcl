source "hyperv-vmcx" "Base-EFI-VMCX" {
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
  generation           = 2
  headless             = true
}
