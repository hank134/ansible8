# Provider
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}
provider "yandex" {
  service_account_key_file = "/home/tim/key.json"
  cloud_id  = "b1ghn66scihrboe3sfhv"
  folder_id = "b1goftamkelavkhtqfcd"
  zone = "ru-central1-a"
}
# VM
resource "yandex_compute_instance" "vm-1" {
  name = "vm01"
  platform_id = "standard-v3"

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd80le4b8gt2u33lvubr"
      type     = "network-hdd"
      size     = "20"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}

#Net
resource "yandex_vpc_network" "network-1" {
  name = "network1"
}
resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}


output "VM-01_local" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}




output "VM1_ip" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}
