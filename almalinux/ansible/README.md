


ansible-playbook -i hosts/docker site.yml -l almalinux8

ansible-playbook -i hosts/docker site.yml -l almalinux8 -tags webmin

# AnisbleでLAMPServer 構築 (CentOS7)

![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)
![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/webdimension/ansible-softether-for-conoha?include_prereleases)

## 概要
- VPSなどのサーバー立ち上げ
- Ansibleで初期設定 (Root)
  - Rootでログイン
  - 一般ユーザー作成 ( ssh鍵登録 ）
  - sshd Root login を無効
  - パスワード認証無効  (鍵認証のみ)
  - ssh port変更
  - ssh 許可IP設定
  - Firewalld 設定
  - hostname 設定
- AnsibleでApache, PHP, MySQL,etc(tools)... をInstall
  - Let'sencrypt 対応
  - Postfix SMTP-Auth
  - SELINUX Enable

## 環境
***Local***
- Ubuntu 18.04 On Vagrant + VMware fusion
- Ansible 2.9.7

***Server***
- CentOS 7.8

## 設定
### hosts/product

```yml
[lamp]
# Server IP address
Product-CentOS7-Init ansible_host=xxx.xxx.xxx.xxx
Product-CentOS7

[product]
Product-CentOS7-Init
Product-CentOS7

[centos7]
Product-CentOS7-Init
Product-CentOS7

[centos8]

[Product-CentOS7-Init]
Product-CentOS7-Init
[Product-CentOS7-Init:vars]
ansible_ssh_user=root
ansible_port=22
ansible_ssh_pass={{ secret.root_user_password }}
```

### group_vars/all/secret
```yml
secret:
  # For Ansible user
  ansible_users:
    - name: 'ansible'
      groups: 'wheel'
      append: 'yes'
      state: 'present'
      remove: 'no'
      password: "ansible"
      public_key: "~/.ssh/id_rsa.pub"
      login_shell: '/bin/bash'
      create_home: 'yes'
      sudo: 'present'
      comment: 'ansible user'
      expires: '-1'

  # users
  users:
    webuser:
      name: 'develop_001'
      groups: 'wheel,manager'
      append: 'yes'
      state: 'present'
      remove: 'no'
      password: "password"
      public_key: "~/.ssh/id_rsa.pub"
      login_shell: '/bin/bash'
      create_home: 'yes'
      sudo: 'absent'
      comment: 'something'
      expires: '-1'
      docker_group: true

  # groups
  user_groups:
    wheel:
      name: 'wheel'
      state: 'present'
    manager:
      name: 'manager'
      state: 'present'

# For not use let'sencrypt
  ca_CN: "{{ httpd_domain }}"
  #countryName
  ca_C: JP
  #emailAddress
  ca_EMail: mail@xxx.com
  #localityName
  ca_L: Shibuya
  #organizationName
  ca_O: company
  #organizationalUnitName
  ca_OU: unit
  #stateOrProvinceName
  ca_ST: Tokyo

  postfix:
  # SMTP Auth
    smtp_host: "smtp host"
    smtp_port: "port"
    smtp_user: "Account"
    smtp_password: "password"
    smtp_myhostname: "mail.xxx.jp"
    smtp_mydomain: "xxx.jp"
    smtp_inet_interfaces: "localhost"
    smtp_inet_protocols: "ipv4"
    
  databases:
    worker1_db:
      username:       "worker1"
      password:       "root"
      user_state:     "present"
      host:           "localhost"
      db_name:        'worker1'
      db_state:       "present"
    worker2_db:
      username:       "worker2"
      password:       "root"
      user_state:     "present"
      host:           "localhost"
      db_name:        'worker2'
      db_state:       "present"
      state: 'present'
```
### group_vars/product/sshs.yml
```yml
# ssh port
sshd_port: 50022 #Default 22
```
### group_vars/product/httpd.yml
```yml
letsencrypt: true
letsencrypt_email: your_mail_address
crontab:
  letsencrypt:
    name: "letsencrypt {{ httpd_domain }}"
    state: 'present'
    user: 'root'
    job: /bin/bash -lc "certbot certonly --force-renew --webroot -w {{ httpd_document_root }}{{ httpd_public_dir }} -d {{ httpd_domain }} --post-hook 'systemctl reload httpd' > /dev/null 2>&1"
    minute: "0"
    hour: "12"
    day: "1"
    month: "*"
    weekday: "*"
```

### group_vars/product/secret.yml
```yml
secret:
  root_user_password: 'Server_Root_Password'
  mysql57_root_password: 'MySQL_Root_Password'

  firewalld_service:
    - service: 'http'
      zone: 'public'
      permanent: 'yes'
      state: 'enabled'
      immediate: true
    - service: 'https'
      zone: 'public'
      permanent: 'yes'
      state: 'enabled'
      immediate: true
    - service: 'ssh'
      zone: 'public'
      permanent: 'yes'
      state: 'enabled'
      immediate: true

  firewalld_rich_rules:
    - port: "{{ sshd_port }}"
      protocol: tcp
      control: accept
      ips:
        - xxx.xxx.xxx.xxx  # Allow ssh IP

```

### host_vars/*/hostname.yml
```yml
# Sever hostname
hostname: 'something hostnmae'
```

### host_vars/*/httpd.yml
```yml
# Apache Domain
httpd_domain: 'your_domain'
```

## For vagrant
### Install all
Install all without init
```bash
ansible-playbook -i hosts/vagrant site.yml -l Vagrant-CentOS7 --skip-tags init
```

## For Product
### Add Ansible user and sshd setting, firewalld
Add ansible user From root login and sshd, firewalld
```bash
ansible-playbook -i hosts/product site.yml -l Product-CentOS7-Init -t init -t firewalld
```

### Install all
Install all without init
```bash
ansible-playbook -i hosts/product site.yml -l Product-CentOS7 --skip-tags init
```
### 機密情報の暗号化
### vault pass
```bash
echo 'vault_password_file = ./vaultpass' > ansible.cfg
cp valtpass.sample valtpass
echo 'your_vault_password' > vaultpass
```

#### 暗号化
```bash
ansible-vault encrypt group_vars/*/secret.yml 
```

#### 復号化
```bash
ansible-vault decrypt group_vars/*/secret.yml 
```

## License
MIT
