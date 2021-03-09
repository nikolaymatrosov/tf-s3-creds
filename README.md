1. Скопировать `terraform.tfvars.example` в `terraform.tfvars` и заполнить
2. Выполлнить
  ```shell
  terraform init
  terraform apply
```
3. ssh на vm
```shell
aws --endpoint-url=https://storage.yandexcloud.net \
  s3api get-object --bucket $BUCKET --key $KEY \
  output
```