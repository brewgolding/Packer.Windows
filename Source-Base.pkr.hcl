source "hyperv-iso" "Base-EFI-ISO" {
  boot_command         = ["a<wait>a<wait>a<wait>a<wait>a<wait>a<wait>a"]
  boot_wait            = "2s"
  cd_label             = "cidata"
  communicator         = var.communicator
  cpus                 = var.cpus
  disk_size            = var.disk_size
  enable_secure_boot   = var.enable_secure_boot
  generation           = 2
  memory               = var.memory
  secure_boot_template = var.secure_boot_template
  shutdown_command     = var.hyperv_shutdown_command
  switch_name          = var.switch
  winrm_password       = var.winrm_password
  winrm_timeout        = "${var.winrm_timeout}"
  winrm_username       = var.winrm_username
  headless             = true
}
