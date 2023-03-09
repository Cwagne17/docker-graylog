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
sudo hostnamectl set-hostname cardiff.telecom.england

# use the following command to verify
sudo hostnamectl status
```

2. Set a Static IP
   1. Use the Network Manager to configure a static IP address

| <img src="../assets/ubuntu-network-manager.png" width="500px"> |
|:--:|
| <b>figure 6. Ubuntu Network Manager</b> |

3. Restart the Network Service

```bash
sudo systemctl restart NetworkManager
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
sudo apt update && sudo apt upgrade -y
```

## Docker Installation

1. Update APT package index
2. Add Docker's officla GPG key
3. Add Docker's official APT repository
4. Install Docker Enginer, Containerd, and Docker Compose

### Recommended Docker Engine Configuration

1. Manage Docker as a non-root user
   1. Create the `docker` group

```bash
sudo groupadd docker
```

   2. Add your user to the `docker` group (re-login to apply changes)

```bash
sudo usermod -aG docker $USER
```

   3. Verify that you can run `docker` commands without `sudo`
      1. Run an image on the machine

```bash
# list images on the machine
docker images

# run an image
docker run <image-name>
```

1. Configure Docker to start on boot
2. Configure Default Logging Driver

### Additional Docker Engine Configuration



## Docker Deployment

## Systemd Configuration
