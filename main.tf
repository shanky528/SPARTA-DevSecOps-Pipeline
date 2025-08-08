terraform {
  required_version = ">= 1.0.0"
}

resource "null_resource" "vagrant_vm" {
  # Run 'vagrant up' to create the VM
  provisioner "local-exec" {
    command     = "vagrant up"
    working_dir = "C:/Terraform/vagrant"
  }

  # Run 'vagrant destroy -f' to destroy the VM on terraform destroy
  provisioner "local-exec" {
    when        = destroy
    command     = "vagrant destroy -f"
    working_dir = "C:/Terraform/vagrant"
  }
}

