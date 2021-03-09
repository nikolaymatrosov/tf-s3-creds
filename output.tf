output "ip_address" {
  value = yandex_compute_instance.test-vm.network_interface[0].nat_ip_address
}