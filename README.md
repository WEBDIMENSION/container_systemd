# サーバ ( systemd )を Docker で起動

- [用途](#用途)
  - [メリット](#メリット)
  - [デメリット](#デメリット)
- [Servers](#servers)
  - [Almalinux8](#almalinux8)
    - [動作確認](#動作確認)
  - [centos7](#centos7)
  - [amazonlinux2](#amazonlinux2)
- [各サーバーに固定 IP 設定のため Docker Network 作成](#各サーバーに固定-ip-設定のため-docker-network-作成)
  - [Public_key Import](#public_key-import)
- [Usage (Example)](#usage-example)
  - [修正箇所](#修正箇所)
  - [Start](#start)
  - [Ansble](#ansble)
  - [ssh](#ssh)

## 用途

- Ansible のテスト
- AWS などの Cloud、その他 VPS などを用意するまでもない作業

### メリット

- 軽量なためスクラップ・ビルドが用意(早い)

### デメリット

- AWS などの Cloud、その他 VPS のような本番環境と同等ではない部分がある。  
  (本来 Docker はこのような使い方は推奨していない。1Process,1Container 推奨)

## Servers

### Almalinux8

#### 動作確認

Image is here [DockerHub](https://hub.docker.com/repository/docker/webdimension/almalinux8_systemd)

- [x] Docker for MAC version 4.3.1.
- [x] Ubuntu20 On vagrant Docker version 20.10.10

### centos7

Image is here [DockerHub](https://hub.docker.com/repository/docker/webdimension/centos7_systemd)

- [ ] Docker for MAC version 4.3.1.  
  (systemd のバージョンが古いためサポートされない。 Docker Desktop の仕様)  
  \*Docker Desktop の ダウングレード
- [x] Ubuntu20 On vagrant Docker version 20.10.10

### amazonlinux2

Image is here [DockerHub](https://hub.docker.com/repository/docker/webdimension/amazonlinux2_systemd)

- [ ] Docker for MAC version 4.3.1.  
  (systemd のバージョンが古いためサポートされない。 Docker Desktop の仕様)  
  \*Docker Desktop の ダウングレード

- [x] Ubuntu20 On vagrant Docker version 20.10.10

## 各サーバーに固定 IP 設定のため Docker Network 作成

[create_network.sh](create_network.sh)

- network name: dev
- subnet: 172.30.0.0/24

Root login no RSA login yes

### Public_key Import

- 第一引数 ~/.ssh/ ないの public_key
- 第二引数 Doker/xxx のディレクトリ名

```bash
#!/usr/bin/env bash
if [ $# != 2 ]; then
    echo Please public_key name: $*
    echo Please deploy dir name: $*
    exit 1
else
  echo $HOME/.ssh/$1 to ./Docker/$2/$1
  cp $HOME/.ssh/$1 ./Docker/$2/$1
fi

```

## Usage (Example)

### 修正箇所

```bash
systemd
 ├── Dockerfile
 └── ansible_rsa.pub
```

DockerFile
```dockerfile
## Your Public_key
ADD ansible_rsa.pub /tmp/public_key 
```


### Start

```bash
# docker-compose up -d <サービス名>
docker-compose up -d almalinux8_systemd
```

### Ansble

```bash
# host
# docker-compose exec <サービス名> bash 
docker-compose exec almalinux8_systemd bash 
```

```bash
# Container
./plaubook.sh
```

 ```bash
#!/usr/bin/env bash
ansible-playbook -i hosts/docker site.yml -l almalinux8  -vvv
# As you like
 ```

### ssh

```bash
# Your environment 
ssh master@localhost -p xxxx -i ~/.ssh/xxxx
```