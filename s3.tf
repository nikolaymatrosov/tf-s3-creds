resource "yandex_iam_service_account" "s3-test" {
  name = "s3-test"
  description = "service account to for AWS S3 cred demo"
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.s3-test.id
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.folder_id

  role = "editor"

  members = [
    "serviceAccount:${yandex_iam_service_account.s3-test.id}"
  ]
}
