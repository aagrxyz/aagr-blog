---
title: "Disaster Recovery: Backups from a personal example"
date: 2024-12-08T00:00:00-00:00
draft: false
---

## Introduction

About 3-4 years ago, I embarked on a journey to organize my digital life in a way that felt intuitive, secure, and resilient. The story of how this journey began is for another time, but like many, I was driven by growing privacy concerns and the increasing number of digital incidents in the world. It led me to take matters into my own hands and set up a home server. Since my last [tech-stack update](https://aagr.xyz/posts/tech-stack/), the setup has grown both in complexity and capability.

When you take ownership of your digital infrastructure, it's only a matter of time before you face some form of data loss or device failure.

> There’s a famous saying: There are two types of people in the world - those who have lost data and those who will lose data.

This series aims to shed light on managing your digital footprint in a way that ensures continuity even in the face of failures or disasters. Drawing inspiration from disaster recovery practices at my work at Google, as outlined in [Google's SRE principles](https://sre.google/sre-book/lessons-learned/), I’ve developed a plan to address potential failure modes and mitigate losses.

This series will cover:
1. **Data audit and Backups**
2. **Failure modes and their recovery procedures**
3. **Emergency kits**

In this post, we’ll focus on backup plans.

---

## Hardware Overview

Before diving into the backup strategy, it's important to understand the underlying hardware and its configuration.

### Home Setup
My home server consists of:
- **[Raspberry Pi 4](https://en.wikipedia.org/wiki/Raspberry_Pi_4):** Equipped with a USB stick for quick block storage and a USB-powered external hard disk.
- **[Intel NUC](https://en.wikipedia.org/wiki/Next_Unit_of_Computing):** Configured with an internal NVMe SSD and an additional SATA hard disk.

Both devices are part of a Kubernetes cluster running a distributed file system via [SeaweedFS](https://github.com/seaweedfs/seaweedfs). This setup allows flexible storage across multiple mediums (SSD/HDD) with customizable replication levels.

### Remote Node
At my parent’s home:
- **[Raspberry Pi Zero](https://www.waveshare.com/wiki/Raspberry_Pi_Zero):** With a small microSD card for lightweight tasks.

### Network Access
The majority of services on my home server are accessible only within the internal network. For external access, I use a WireGuard VPN server, granting secure remote access. Additionally, my phone and laptop hold the necessary credentials for seamless integration with my home network.

---

## Data Overview

Most of my critical data resides on my home server, complemented by some data still present on Google services. Over time, I've been transitioning away from centralized platforms like Google (a topic for another post on "de-Googling" your life) but my Google account is still a critical piece of the puzzle.

Here’s how my data is organized, categorized by root storage location:

### Categories and Tags
1. **Personal Important Data (`#personal`)**:
   - **Passwords:** Managed via [KeePassXC](https://keepassxc.org), stored in a `secrets.kbdx` file.
   - **Photos:** Self-hosted on [Immich](https://immich.app) and partially on Google Photos.
   - **Documents:** Stored as individual files.
   
2. **Configuration Data (`#config`)**:
   - Kubernetes container volumes (state data for containers).
   - Kubernetes YAML configurations (deployment/bootstrap configs).
   - Kubernetes etcd backups (cluster state snapshots).
   - SeaweedFS metadata (storage service configurations).
   
3. **Media Data (`#media`)**:
   - Files for my self-hosted [Plex](https://plex.tv) server.

4. **Google Account (`#google`)**:
   - Emails, Google Drive files, Contacts, Photos, and more.

5. **Mobile Devices (`#mobile`)**:
   - Messaging apps (e.g., WhatsApp, Signal) and synced directories via [Syncthing](https://syncthing.net).

---

## Backup Strategy

Let’s delve into how each category is backed up.

### Personal Data (`#personal`)
- **Storage:** Redundantly stored on two separate HDDs across different nodes, meaning 1 drive can fail without causing any loss of data
- **Backup:** Synced nightly to [Backblaze B2 cloud storage](https://www.backblaze.com/cloud-storage) in the `us-east` region to ensure geographical redundancy.

### Configuration Data (`#config`)
- **Storage:** Stored on one or two SSDs across the nodes.
- **Backup:** Similarly backed up to Backblaze.

### Media Data (`#media`)
- **Storage:** Stored on a single HDD without external backups. Loss is acceptable as media files can be re-created, albeit with time.

### Google Account (`#google`)
- **Trust in Google:** I’m confident in Google’s infrastructure, but a seperate failure mode, means I need to slowly have a local copy too.

### Mobile Devices (`#mobile`)
- **Syncing:** Regularly backed up to the `#personal` directory on the home server using Syncthing.

---

## Tools and Processes

### Duplicacy for Cloud Backups
I use [Duplicacy](https://duplicacy.com/) to encrypt, chunk (into ~16MB blocks), and upload my data to Backblaze. A nightly cron job uploads revisions, and old versions beyond 30 days are pruned to minimize storage costs.

### Syncthing for Cross-Device Sync
With all of the data having it's root at the homeserver, I need access to some of it on mobile devices, which is where Syncthing excels. Syncthing ensures key directories are synced across devices, enabling offline access—a lifesaver during flights or in areas with no connectivity.

---

## Gaps and Future Plans

Despite this robust setup, some gaps remain when compared to the [3-2-1 backup strategy](https://www.seagate.com/gb/en/blog/what-is-a-3-2-1-backup-strategy/). While modern approaches like [3-2-2](https://www.unitrends.com/blog/3-2-1-backup-sucks) advocate for additional copies, I currently lack sufficient redundancy.

### Future Actions
1. Periodically archive all home server data onto an external HDD stored offline.
2. Maintain an offsite copy of critical data at my parent’s home for geographical redundancy.
3. Experiment with low-cost, cold storage options like Google Cloud's [ARCHIVE](https://cloud.google.com/storage/docs/storage-classes#classes) or [COLDLINE](https://cloud.google.com/storage/docs/storage-classes#classes).

I will keep you posted on what I do in the future!

---

Performing this exercise allowed me to clearly understand the types of data I have and what redudancies I have or lack. I would suggest you to perform a same for your devices and data!