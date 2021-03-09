data "yandex_compute_image" "ubuntu-20-04" {
  family = "ubuntu-2004-lts"
}

data "template_file" "cloud_init" {
  template = file("cloud-init.tmpl.yaml")
  vars = {
    user = var.user
    ssh_key = file(var.public_key_path)
  }
}

data "template_file" "creds" {
  template = file("aws/credentials.tmpl")
  vars = {
    secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
    access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  }
}

resource "yandex_compute_instance" "test-vm" {
  name = "test-vm"
  folder_id = var.folder_id
  platform_id = "standard-v2"
  zone = "ru-central1-a"

  resources {
    cores = 2
    memory = 2

  }
  boot_disk {
    mode = "READ_WRITE"
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-20-04.id
      type = "network-ssd"
      size = 13
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.demo-subnet-a.id
    nat = true
  }

  metadata = {
    user-data = data.template_file.cloud_init.rendered
    serial-port-enable = 1
  }

  connection {
    type = "ssh"
    user = var.user
    private_key = file(var.private_key_path)
    host = self.network_interface[0].nat_ip_address
  }

  provisioner "file" {
    source = "./aws"
    destination = "~/.aws"
  }

  provisioner "file" {
    content = data.template_file.creds.rendered
    destination = "~/.aws/credentials"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get install unzip",
      "curl \"https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip\" -o \"awscliv2.zip\"",
      "unzip awscliv2.zip",
      "sudo ./aws/install"
    ]
  }

  timeouts {
    create = "10m"
  }
}

