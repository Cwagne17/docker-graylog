# Operating Manual

This file describes the specifications for the graylog environment and a tutorial to building the environment.

## ProxMox Configuration

1. Select the "Create VM" button
2. General Tab (see figure a.)
   1. choose either (cyberops 1/2/3/4) for the team
   2. Specify any three-digit VM ID number
   3. The VM name should match the hostname
   4. The resource pool should match your team and node

| <img src="../assets/proxmox-general-tab.png" width="500px"> |
|:--:|
| <b>figure 1. Prox Mox General Tab</b> |

3. OS Tab
   1. Select the `ISO image` as `ubuntu-20.04-desktop-amd64.iso`

| <img src="../assets/proxmox-os-tab.png" width="500px"> |
|:--:|
| <b>figure 2. Prox Mox OS Tab</b> |

4. System Tab (settings should be left as default)
5. Hard Disk Tab
   1. Select the `Storage` that has larger `Avail`

| <img src="../assets/proxmox-hard-disk-tab.png" width="500px"> |
|:--:|
| <b>figure 3. Prox Mox Hard Disk Tab</b> |

6. CPU Tab
   1. Select 2 `Cores` (increase as needed)
   2. `Type` **MUST** be set to `host`
      1. An alternative CPU `Type` **MUST** support [`AVX (Advanced Vector Extensions)`](https://en.wikipedia.org/wiki/Advanced_Vector_Extensions)

| <img src="../assets/proxmox-cpu-tab.png" width="500px"> |
|:--:|
| <b>figure 4. Prox Mox CPU Tab</b> |

7. Memory Tab
   1. Recommended that **ATLEAST** `3072 to 4096` MiB of `Memory` are used (increase as needed)
      1. The log server has been tested with `2048` MiB and works but will be working hard

| <img src="../assets/proxmox-memory-tab.png" width="500px"> |
|:--:|
| <b>figure 5. Prox Mox Memory Tab</b> |

8. Network Tab
   1. It is **CRITICAL** that `Bridge` is set to `vmbr1`

| <img src="../assets/proxmox-network-tab.png" width="500px"> |
|:--:|
| <b>figure 6. Prox Mox Network Tab</b> |

9. Confirm Tab
   1.  Select the `Finish` button at the bottom right

## Network Configuration

1. Set a Hostname
   1. The example uses `cardiff.telecom.england` as the hostname

```bash
$ sudo hostnamectl set-hostname cardiff.telecom.england

# use the following command to verify
$ sudo hostnamectl status
```

2. Set a Static IP
   1. Use the Network Manager to configure a static IP address

| <img src="../assets/ubuntu-network-manager.png" width="500px"> |
|:--:|
| <b>figure 6. Ubuntu Network Manager</b> |

3. Restart the Network Service

```bash
$ sudo systemctl restart NetworkManager
```

## APT Configuration

1. Setup Proxy Configuration
   1. Add the following to `/etc/apt/apt.conf.d/proxy.conf`

```conf
Acquire {
        HTTP::proxy "http://zathras:password1!@172.18.0.1:3128";
        HTTPS::proxy "http://zathras:password1!@172.18.0.1:3128";
}
```

2. Refresh Cache & Download/Install Updates

```bash
$ sudo apt update && sudo apt upgrade -y
```

## Docker Installation

The following instructions are based on the [official Install Docker Engine on Ubuntu documentation](https://docs.docker.com/engine/install/ubuntu/).

1. Install packages to allow APT to use a repository over HTTPS

```bash
$ sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```

2. Add Docker's officla GPG key

```bash
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

3. Setup the `stable` docker repository in APT
   1. The error, `An unexpected TLS packet was received` may occur if APT `proxy.conf` is not configured correctly, [refer here](https://askubuntu.com/questions/1014973/apt-update-could-not-handshake-an-unexpected-tls-packet-was-received)

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

4. Install the ***latest*** Docker Engine, Containerd, and Docker Compose

```bash
$ sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

5. Install a ***specific version*** of Docker Engine, Containerd, and Docker Compose

```bash
$ VERSION_STRING=5:23.0.1-1~ubuntu.20.04~focal
$ sudo apt-get install docker-ce=$VERSION_STRING docker-ce-cli=$VERSION_STRING containerd.io docker-buildx-plugin docker-compose-plugin
```

---
**NOTE**

At the time of writing, the latest verison of Docker Engine is `23.0.1-1`. The version string may need to be updated in the future. The stable version strings can be found [here](https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/). The graylog implementation **should not** be dependent on the engine version. However, these instructions **may** need to be updated in the future.

---

### Recommended Docker Engine Configuration

The following instructions are based on the [Linux post-installation steps for Docker Engine](https://docs.docker.com/engine/install/linux-postinstall/).

1. Manage Docker as a non-root user
   1. Create the `docker` group

```bash
$ sudo groupadd docker
```

2. Add your user to the `docker` group (re-login to apply changes)

```bash
$ sudo usermod -aG docker $USER
```

3. Verify that you can run `docker` commands without `sudo`
   1. Run an image on the machine

```bash
# list images on the machine
$ docker images

# run an image
$ docker run <image-name>
```

4. Configure Docker to start on boot

```bash
$ sudo systemctl enable docker.service
$ sudo systemctl enable containerd.service
```

### Additional Docker Engine Configuration

1. Configure Docker Daemon to use an [HTTP/HTTPS proxy](https://docs.docker.com/config/daemon/systemd/#httphttps-proxy)
   1. Otherwise, follow the guide below to copy docker images from a remote host
2. [Restrict remote access to the Docker Daemon](https://docs.docker.com/network/iptables/#restrict-connections-to-the-docker-host)
3. Security Considerations for [Docker Engine](https://docs.docker.com/engine/security/)

## Docker Image Configuration

1. On a remote host install the Docker Desktop application which includes the `docker` CLI
   1. [Install Docker Desktop on Windows](https://docs.docker.com/docker-for-windows/install/)
   2. [Install Docker Desktop on Mac](https://docs.docker.com/docker-for-mac/install/)
   3. [Install Docker Desktop on Linux](https://docs.docker.com/desktop/install/linux-install/)
2. Pull the following images required for the graylog implmentation

```bash
# sha256:f972e0a57141ddacb7431cd93510919acfc3d9b9bcf8c62972a3513738d70329
$ docker pull graylog/graylog:5.0

# sha256:2c257b68f361872e13bdd476cba152e232a314ec61b0eedfc1f71b628ba39432
$ docker pull docker.elastic.co/elasticsearch/elasticsearch-oss:7.10.2

# sha256:a4f2db6f54aeabba562cd07e5cb758b55d6192dcc6f36322a334ba0b0120aaf1
$ docker pull mongo:6.0.4
```

---
**NOTE**

The docker tag is used to pull the latest version of the tag. A docker tag is not unique to an image. An image may recieve an update and the tag will remain the same. Alternatively, the image can be pulled by the SHA256 hash. `docker pull <image-name>@sha256:<hash>` can be used to ensure the correct image is pulled.

---

1. Save the images to a tar file

```bash
$ docker save -o graylog.tar graylog/graylog:5.0 docker.elastic.co/elasticsearch/elasticsearch-oss:7.10.2 mongo:6.0.4
```

4. Copy the tar file to the target machine

```bash
$ scp graylog.tar <user>@<target-machine>:/home/<user>
```

---
**NOTE**

The tar file should be backed up on the target machine (and a remote host) in case the images needs to be reloaded.

---

5. Load the images on the target machine

```bash
$ docker load -i graylog.tar
```

## Docker Deployment

1. Setup a graylog directory

```bash
$ mkdir /opt/graylog
```

2. Create a Docker Compose Script

```yaml
# /opt/graylog/docker-compose.yml

version: '3'
services:
  # MongoDB: https://hub.docker.com/_/mongo/
  mongo:
    image: mongo:6.0.4
    ports:
      - "27017:27017"
    networks:
      - graylog

  # Elasticsearch: https://www.elastic.co/guide/en/elasticsearch/reference/7.10/docker.html
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch-oss:7.10.2
    environment:
      - http.host=0.0.0.0
      - transport.host=localhost
      - network.host=0.0.0.0
      - "ES_JAVA_OPTS=-Dlog4j2.formatMsgNoLookups=true -Xms512m -Xmx512m"
    ports:
      - 9200:9200
    ulimits:
      memlock:
        soft: -1
        hard: -1
    deploy:
      resources:
        limits:
          memory: 1g
    networks:
      - graylog

  # Graylog: https://hub.docker.com/r/graylog/graylog/
  graylog:
    image: graylog/graylog:5.0
    environment:
      # CHANGE ME (must be at least 16 characters)!
      - GRAYLOG_PASSWORD_SECRET=somepasswordpepper
      # Password: admin
      - GRAYLOG_ROOT_PASSWORD_SHA2=8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918
      - GRAYLOG_HTTP_EXTERNAL_URI=http://127.0.0.1:9000/
    entrypoint: /usr/bin/tini -- wait-for-it elasticsearch:9200 -- /docker-entrypoint.sh
    networks:
      - graylog
    restart: always
    depends_on:
      - mongo
      - elasticsearch
    ports:
      # Graylog web interface and REST API
      - 9000:9000
      # Syslog TCP
      #- 1514:1514
      # Syslog UDP
      - 514:514/udp
      # GELF TCP
      - 12201:12201
      # GELF UDP
      - 12201:12201/udp

networks:
  graylog:
    driver: bridge
```

2. Deploy the Docker Compose Script

```bash
$ docker compose up -d
```

3. Verify the deployment

```bash
$ docker compose ps -a
```

4. Sping down the deployment to configure Systemd

```bash
$ docker compose down
```

## Systemd Configuration

1. Create a Systemd Service File

```ini
# /etc/systemd/system/graylog.service

[Unit]
Description=Graylog Docker Compose
Requires=docker.service
After=docker.service

[Service]
Restart=always
ExecStart=/usr/local/bin/docker compose -f /opt/graylog/docker-compose.yml up -d
ExecStop=/usr/local/bin/docker compose -f /opt/graylog/docker-compose.yml down
WorkingDirectory=/opt/graylog

[Install]
WantedBy=multi-user.target
```

2. Enable the Systemd Service

```bash
$ systemctl enable graylog
```

3. Start the Systemd Service

```bash
$ systemctl start graylog
```

4. Verify the Systemd Service

```bash
$ systemctl status graylog
```
