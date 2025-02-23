---
title: "Disaster Recovery: Understanding Failure Modes"
date: 2024-12-08T10:00:00-00:00
draft: false
---

# Introduction

In the [previous post](/posts/disaster-plan-1), we covered the importance of backups and outlined a robust plan to secure your digital life. However, backups are just one piece of the puzzle. In this post, we’ll explore **failure modes/scenarios** where things go wrong and how to recover from them effectively.

A failure mode is a specific scenario where something critical fails, leading to potential data loss or access issues. They can range from losing your phone while traveling to complete disk failures on your home server. Each situation demands a tailored response, and this guide categorizes them by likelihood and impact.

---

## Failure Modes and Recovery Strategies

### 1. **Lost Phone abroad without access to other devices**

#### Scenario  
Imagine you’re abroad, and your phone is stolen. Suddenly, you lose access to:  
- Your SIM card, making it impossible to communicate.  
- Phone numbers for friends and family, further complicating communication.  
- Your Google account, which requires two-factor authentication (2FA) or recovery through your phone.  
- Your password manager database, storing all your passwords. 
- Access to your home network, preventing a quick recovery.

To make matters worse, a lot of services, require OTPs sent to your phone or email, complicating any recovery. Feeling stuck and panicked is inevitable. Let’s break this down using a personal example of how to recover from such a situation.  

#### Priorities  

Once the shock subsides, the immediate priorities (in order) are:  
1. **Block Payment Cards**: Prevent misuse of contactless payments. If physical cards are also stolen, the risk is even higher.  
2. **Contact Friends/Family**: For emotional support and logistical help.  
3. **Access Your Google Account**: To retrieve contacts, find your device, and access email.  
4. **Retrieve the password manager database**: To regain access to critical accounts.  
5. **Access Your Home Network**: To recover additional services if necessary.  

#### Pre-Trip Checklist 

How many of you remember your friends’ or family members’ phone numbers? Or the emergency numbers for your bank? I certainly don’t. That’s why preparation is critical.

1. **Prepare an SOS card** (physical and digital), which contains:  
   - Emergency contact numbers for banks and friends/family.  
   - A guide for steps needed to follow. When in stress, humans make mistakes!
  
Okay now you have blocked payment cards, contacted friends/family, let's try to get into the Google services. To access your Google account, you’ll need your password (`G`) and a 2FA. Generally Google does 2FA by sending a notification on your phone (but remember you don't have your phone). So let's go old-school:  

2. Carry a [physical Yubikey](https://www.yubico.com/) as a backup 2FA to decouple authentication from your phone.  

Okay now you are logged into your account, we may need to login into other services, and for that we need to access your password manager database:

3. Ensure it’s backed up to a service you can access without needing the vault itself. For example, store it on Google Drive, even if your main backup is somewhere else (which requires the vault password) - break classic cyclic dependencies!

If nothing works, you still need to get back home, so:

4. **ALWAYS ALWAYS** print a copy of your visa, passport and other critical travel documents.


#### Recovery Playbook 

Here’s how to recover, step by step. If a step relies on a pre-condition (like having your Yubikey), I’ll also cover fallback options.  

1. **Find Communication Access**  
   - Use a borrowed device or public facilities to call your bank and freeze accounts using the SOS card. Take a deep breath now!  
   - Inform your friends/family about the situation and ask for help if possible!

2. **Regain Google Account Access**  
   - Log into your Google account using the password (`G`) and your Yubikey.  
   - Retrieve contacts, locate your device using “Find My Device,” and access your email. 
  
3. **Access the password manager Database**  
   - Download the `secrets.kbdx` file from Google Drive.
   - Decrypt it with the password (`P1`) to restore access to other accounts as needed.

#### Mitigation: Lost SOS Card  

If the SOS card is lost or inaccessible, you should still be able to recover using a digital fallback.

For example, I have a password-protected version of the SOS card at [https://aagr.xyz/sos](https://aagr.xyz/sos). This file contains the same critical information, hosted securely but publicly accessible if needed.  

If you can't do that, go old-school remember a friend's phone number and give them a copy! 

#### Mitigation: Lost Yubikey  

Losing the Yubikey adds complexity, as it locks you out of your Google account. You can get recovery codes for your Google Account, but where do you store them? A piece of paper, or maybe in your password manager itself? which you may have no access to. Here’s the fallback plan:  

1. A trusted friend or family member has a **limited recovery vault** (`recovery.kbdx`) encrypted with a separate password (`P2`). What should this include?  
   - Instructions for restoring the main `secrets.kbdx`.  
   - A copy of the SOS card.  
   - Recovery codes for your Google account.  
   - Critical document numbers (e.g., passport).
   - ... and more depending on your situation

2. Once you obtain the recovery vault, decrypt it using `P2`.  
   - Use the recovery codes to regain access to your Google account.  
   - Follow the playbook for recovery of `secrets.kbdx`


**Why not share `secrets.kbdx` directly?**

Since passowrd managers are encrypted by default, it should be okay to just share that file too with people. But sharing the full vault increases risk. The threat model, I am planning for is to require two passwords to get access to my main vault. My setup ensures that:  
- Someone needs **both** `P1` **AND** (`P2` OR `G`) to unlock the main `secrets.kbdx`.  
- Even if a friend misplaces `recovery.kbdx`, an attacker still needs two distinct passwords to access sensitive information.
- Accessing `secrets.kbdx` via Google Drive requires not only password `G` but also 2FA, adding another layer of security.  

#### Post-Trip Restore

Once back, perform a restore of various accounts and the SIM card. A lot of restore especially into banking apps requires access to the phone number, so:

1. Order a replacement SIM card for the same number. 
2. Follow the restore procedures for various messaging and banking apps that you have!

---

### 2. **Lost Phone With Access to Other Devices**

#### Scenario  
Losing your phone while at home is less severe if you have access to a laptop or other trusted devices. 

#### Recovery Playbook  
1. Follow the same initial steps as above to block bank cards.
2. Restore access on a new phone using your backups and recovery procedures.  

---

### 3. **Loss of Home Internet**

#### Scenario  
A home internet outage can disrupt:  
- Backups from mobile devices to the server.
- Offsite backups to Backblaze. 
- Access to your digital SOS page if hosted locally.

The impact of this is minimal on it's own unless coupled with other failures and thus to prevent additional impact, we need ways to mitigate it.

#### Mitigation Strategy  
- Deploy a redundant server at another location. I already covered this in [tech-stack post](https://aagr.xyz/posts/tech-stack/) 
- Configure automated alerts for service outages.

---

### 4. **Disk Failure on Home Server**

#### Scenario  
> **ALL** disks will inevitably fail.

Losing a disk containing important data without redundancy can lead to permanent loss. This is where [Backups](/posts/disaster-plan-1) come into picture!

#### Recovery Playbook  
1. If you have local copies (like I have with my home-server setup), restore from replicated disks.
2. Otherwise download backups from offsite copy.  
   - Note: Backblaze provides 3x the stored data per month for free downloads, but large-scale recovery may incur costs.  

#### Mitigation Strategy  
As mentioned in the previous post, a better mitigation strategy will be beneficial.
- Create periodic dumps of critical data onto an external HDD and store it offline.  
- Explore additional redundancy with a secondary offsite server.  

---

## Lessons Learned and Next Steps  

This post highlights the importance of **planning for failure modes** and having clear recovery strategies. Some next steps for me personally include:  
1. **Expand Redundancy**: Fix the gaps in your [backup plan](/posts/disaster-plan-1)!
2. **Improve Accessibility**: Ensure recovery playbooks and resources are always accessible in emergencies.  
3. **Test Recovery Plans**: Regularly test your recovery workflows to identify gaps.

In the next post, we’ll dive deeper into **emergency disaster planning**, outlining how to proactively prepare for less likely but high-impact scenarios like losing access to all your devices, access to google account or even your memory!

Stay tuned, and remember: **It’s not about *if* things will fail—it’s about *when*.**