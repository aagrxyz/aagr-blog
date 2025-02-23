---
title: "Home server: How? What?"
date: 2024-12-01T00:00:00-00:00
draft: false
---

Since my last [tech-stack update](/posts/tech-stack/), the setup has grown both in complexity and capability. This calls for an update on what is running on my home server and how?. Hopefully it encourages to also try out this hobby.

### Hardware overview

My home server setup consists of:
- A **[Raspberry Pi 4](https://en.wikipedia.org/wiki/Raspberry_Pi_4)**: Equipped with a USB stick for quick block storage and a USB-powered external hard disk.
- An **[Intel NUC](https://en.wikipedia.org/wiki/Next_Unit_of_Computing)**: Configured with an internal NVMe SSD and an additional SATA hard disk.
- At my parent’s home, I also have a **[Raspberry Pi Zero](https://www.waveshare.com/wiki/Raspberry_Pi_Zero)**: With a small microSD card for lightweight tasks. This is a remote node and not part of a cluster setup.

This is a pretty basic setup but you can achieve a lot with software. Keeping in mind, that I will add more hardware, I waned to look at software systems that allow me to easily expand to more devices.

### Base services

1. All of the devices are running Ubuntu server as the OS and have been assigned static IPs at my router.
2. Storage is managed using a distributed file system via [SeaweedFS](https://github.com/seaweedfs/seaweedfs). The NUC acts as the master node and both of them run volume servers to store redundant copies of data across two nodes. This setup allows flexible storage across multiple mediums (SSD/HDD) with customizable replication levels.
3. Both devices are part of a Kubernetes cluster running [k3s](https://k3s.io/) with the NUC being the master.
4. The majority of services on my home server are accessible only within the internal network. For external access, I use a WireGuard VPN server, granting secure remote access. 

Once you have an OS, job scheduling, networking and storage configured you are ready to run services on your cluster! I run everything else over k8s making it super easy to manage services.

### Services I run?

Over time as I find some interesting use-case, I try to find self-hosted versions of a tool rather than relying on another cloud provider. A curated personal list of services I host (in no particular order):

1. This blog that you are reading - [Github](https://github.com/aagrxyz/aagr-blog)
2. [Airtrail](https://github.com/johanohly/AirTrail) - Track my flight history.
3. [Home assistant](https://www.home-assistant.io/) - My self-hosted smart home
4. [Cloudflare tunnels](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/) - Access to some services over the public internet (like this blog)
5. [Immich](https://immich.app/) - Self-hosted photos management
6. [Matrix server](https://matrix.org/) - Open network for decentralized communication
7. Media stack - [Plex](https://www.plex.tv/) and other stuff
8. [Ntfy](https://ntfy.sh/) - Push notifications
9. [Your Spotify](https://github.com/Yooooomi/your_spotify) - My spotify listening stats
10. [Pingvin](https://github.com/stonith404/pingvin-share) - File-sharing platform
11. Monitoring stack - [Prometheus](https://prometheus.io/), [Grafana](https://grafana.com/)
12. [Syncthing](https://syncthing.net/) - Continuous file synchronization program. 
13. [Tailscale](https://tailscale.com/) - Secure remote access to other nodes
14. Manager - A custom written service to manage the various periodic tasks like backups
---
