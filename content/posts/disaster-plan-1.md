---
title: "Disaster Recovery: Backups from a personal example"
date: 2024-12-08T00:00:00-00:00
draft: false
---

## Introduction

About 3-4 years ago, I embarked on a journey to organize my digital life in a way that felt intuitive, secure, and resilient. The story of how this journey began is for another time (started as fun little hobby), but like many, things go wrong and unpredictable at times. It led me to take matters into my own hands and set up a home server. 

When you take ownership of your digital infrastructure, it's only a matter of time before you face some form of data loss or device failure. There’s a famous saying: 

> There are two types of people in the world - those who have lost data and those who will lose data.

This series aims to shed light on managing your digital footprint in a way that ensures continuity even in the face of failures or disasters. Drawing inspiration from disaster recovery practices at my work at Google, as outlined in [Google's SRE principles](https://sre.google/sre-book/lessons-learned/), I’ve developed a plan to address potential failure modes and mitigate losses.

This series will cover:
1. **Data audit and Backups**
2. **Failure modes and their recovery procedures**
3. **Emergency kits**

In this post, we’ll focus auditing our data and it's backup plans.

Since my last [tech-stack update](/posts/tech-stack/), the setup has grown both in complexity and capability, so this might be a good time to read about it in [Home Server Setup](/posts/home-server-setup/) as it touches the tools and systems I use to achieve the disaster recovery strategies.

---

## Data Overview

Before we find out a backup strategy, the first thing to do is to sit-down and write all the various digital footprint we have (trust me, do this exercise). Doing that will give you an idea of what is at the biggest risk.

Personally for me most of my critical data resides on my home server, complemented by some data still present on Google services. Over time, I've been transitioning away from centralized platforms like Google (a topic for another post) but my Google account is still a critical piece of the puzzle. Here’s how my data is organized, categorized by tags to be referenced later:

### Categories and Tags
1. **Personal Important Data** (`#personal`): Critical digital life
   - **Passwords:** Managed via [KeePassXC](https://keepassxc.org) password manager, stored as a `secrets.kbdx` file.
   - **Photos & Videos:** Self-hosted using [Immich](https://immich.app) on my server and partially on Google Photos.
   - **Documents:** Stored as individual files.
   
2. **Configuration Data** (`#config`): All the data needed to keep my home server running
   - Kubernetes container volumes (state data for containers).
   - Kubernetes YAML configurations (deployment/bootstrap configs).
   - Kubernetes etcd backups (cluster state snapshots).
   - SeaweedFS metadata (storage service configurations).
   
3. **Media Data** (`#media`):
   - Files for my self-hosted [Plex](https://plex.tv) server.

4. **Google Account** (`#google`):
   - Emails, Google Drive files, Contacts, Photos, and more.

5. **Mobile Devices** (`#mobile`):
   - Messaging apps (e.g., WhatsApp, Signal)
   - Photos and some documents
  
6. **Misc Online data**:
   - Data stored in various other services, which is only related to that service like say Instagram, Twitter, Spotify, Netflix etc.

---

## Backup strategies
 
A very classic strategy that has stood the test of time is the [3-2-1 backup strategy](https://www.seagate.com/gb/en/blog/what-is-a-3-2-1-backup-strategy/). Basically the crux of it is, you have 3 copies of the data, 2 on different mediums and 1 in an off-site location. 

Once you identify the datasets, try to consolidate them at a single place first (goes against the philosophy of multiple copies), but trust me it makes reasoning about the scattered mess, way straight forward.

Let's see how my data categories are stacking against this strategy:

1. **Personal Data** (`#personal`)
   - Storage: Redundantly stored on two separate HDDs across different machines on my homeserver, meaning 1 drive can fail without causing any loss of data
   - Backup: Synced nightly to [Backblaze B2 cloud storage](https://www.backblaze.com/cloud-storage) in the `us-east` region to ensure geographical redundancy.

2. **Configuration Data** (`#config`)
   - Storage: Stored on one or two SSDs across the two machines.
   - Backup: Similarly backed up to Backblaze.

3. **Media Data** (`#media`)
   - Storage: Stored on a single HDD without any external backups. Loss is acceptable as media files can be re-created, albeit with time.

4. **Google Account** (`#google`)
   - Trust in Google: Working at Google, means I’m confident in Google’s infrastructure, but a local copy will be useful.

5. **Mobile Devices** (`#mobile`)
   - Syncing: Regularly backed up to the `#personal` category on the home server using [Syncthing](https://syncthing.net)..
  
6. **Misc Online data**
   - No need for any backups, very specific for a service.


### How is offsite backup done?

A nice tool I encountered is [Duplicacy](https://duplicacy.com/) which allows to encrypt, chunk data (into ~16MB blocks), and upload it to various different storage sinks. Backblaze is one of them natively supported, and so is many other cloud providers. A nightly cron job (in my manager service) uploads revisions, and old versions beyond 30 days are pruned to minimize storage costs.

## Gaps and Future Plans

Now, I can see that I have 1 offsite backup of everything important (`#personal`, `#config`) with Backblaze, 2 copies locally - which means I kinda satisfy the `3-2-1` backup strategy. All of these local copies are part of the same homeserver setup (both are either on HDD or SSD), meaning I can very well loose both copies simultaneously due to a software issue (as likely as a disk failure). Modern approaches like [3-2-2](https://www.unitrends.com/blog/3-2-1-backup-sucks) advocate for additional copies and I currently lack sufficient redundancy.

### Future Actions
1. Periodically archive all home server data onto an external HDD stored offline aka not connected to my homeserver.
2. Maybe maintain an offsite copy of critical data at friends' place for geographical redundancy.
3. Experiment with low-cost, cold storage options like Google Cloud's [ARCHIVE](https://cloud.google.com/storage/docs/storage-classes#classes) or [COLDLINE](https://cloud.google.com/storage/docs/storage-classes#classes).

I will keep you posted on what I do in the future!

---

Performing this exercise allowed me to clearly understand the types of data I have and what redudancies I have or lack. I would suggest you to perform a same for your devices and data!