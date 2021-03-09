resource "yandex_vpc_network" "demo" {
  name = "demo"
}

resource "yandex_vpc_subnet" "demo-subnet-a" {
  name           = "demo-ru-central1-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.demo.id
  v4_cidr_blocks = ["10.128.0.0/24"]
}
