Данная конфигурация позволяет развернуть комплекс из 6 виртуальных машин на CentOS 7 в провайдере Advanced Hosting (AH):

В комплексе использованы следующие технологии:
- ISCSI Target FileIO + multipath
- Pacemaker-кластер для подключения общей сетевой папки по ISCSI и контроля PHP-FPM
- Кластер БД с PostgreSQL, Patroni, PgBouncer
- Consul-кластер, Consul-template
- Nextcloud

**Комплекс продолжит работать, если будет отказ одной ноды с Postgres (db1 или db2) и/или отказ одной ноды Pacemaker/Nginx (node1 или node2)**

Настройка будет происходить через Ansible. 

Виртуальные машины будут развёрнуты с адресами из подсетей 192.168.2.0/24 и 192.168.3.0/24. 

**Требования для запуска данной конфигурации:** 
-Наличие Linux-машины (Или Unix)
-Установленные пакеты Git, Ansible и Terraform.
-Аккаунт в Advanced Hosting, c добавленым токеном и ssh fingerprint. 
-В аккаунте AH не должно быть заведено сетей 192.168.2.0/24 и 192.168.3.0/24.


**Описание terraform-файлов:**
-ansible.cfg - файл с конфигурацией Ansible
-main.tf - главный файл для terraform. Указываем наш провайдер и токен для работы с провайдером. 
-variables.tf - описание типов всех переменных
-vm.tf - файл, с описанием ВМ
-terraform.tfvars - файл, в котором хранятся все значения переменных. НУЖНО ЗАПОЛНИТЬ ПЕРЕД запуском команды terraform apply
-template.tf - сценарий, в котором содержится инструкция по выводу всех адресов в файл hosts
-output.tf - terraform-сценарий, который выводит нам IP-адрес созданной виртуальной машины
-provision.yml - Ansible-playbook для установки для развертывания кластера, ISCSI и GFS2.
-inventory.tpl - указываем формат файла hosts


**Как развернуть конфигурацию:** 
1) На подготовленную Linux-машину клонируем данный репозиторий `git clone https://github.com/tv1n94/patroni_consul.git`
2) Открываем файл terraform.tfvars и вносим следующие значения параметров:
  -ah_dc - можно указать значение ams1 (Дата-центр в Амстердаме) или ash1 (Дата-центр в Америке)
  -ah_token - указываем значение из AH - API - Manage API access tokens
  -ah_machine_type - указываем тип машины, например "start-xs" все типы можно посмотреть в  AH - API - Slugs - Cloud Servers
  -ah_image_type - "centos-7-x64", список всех образов можно посмотреть в AH - API - Slugs - Images

3) В файле vm.tf в разделе указываем ssh_key fingerprint вашего ключа из AH - SSH KEYS

4) Находясь в каталоге, выполняем команду `terraform plan` Данная команда поможет проверить, не было ли допущено ошибок

5) Выполняем команду `terraform apply -auto-approve`


**Проверка корректного выполнения скрипта:**
1) Смотрим в файле hosts адрес Proxy-сервера `cat hosts`
2) Вводим в адресной строке адрес proxy-сервера
3) Откроется окно первоначальной настройки nextcloud. Вводим следующие данные:
- Имя пользователя и пароль
- Выбираем БД PostgreSQL
- Имя базы данных - nextcloud
- Имя пользователя БД - nextcloud
- Пароль пользователя БД - nextcloud
- localhost:5432

4) После настройки можно будет пользоваться Nextcloud



**Удаление всего стенда с конфигурацией:**
Для удаления ВМ достаточно ввести команду: `terraform destroy -auto-approve`


**Дополнительная информация**
Веб-интерфейс Consul - `<IP ISCSI-сервера>:8500`

Доступ к БД:
Ноды db1 или db2: 
`sudo su - postgres`
`psql -p 5433 -h /var/data/base/`
Служба Postgresql будет отключена, так как она управляется Patroni
node1: 
`sudo su - postgres`
`psql -h localhost`