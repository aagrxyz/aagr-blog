---
title: "How My Raspberry Pi Blog Stays Online?"
date: 2024-03-30T00:00:00-00:00
draft: false
---

I recently implemented some behind-the-scenes changes to significantly increase the reliability and performance of my blog. Using the power of multiple Raspberry Pis and Cloudflare Argo Tunnels, I've set up load balancing and redundancy that will keep my blog up and running – even if things go wrong at home.

**The Original Setup**

Let's step back and look at how things started:

* **Humble Pi Power:** At its heart, my blog is powered by a tiny Raspberry Pi 4 tucked away in the corner of my home office. 
* **Markdown + Hugo:** I write posts in the convenient Markdown format. Hugo, a static site generator, transforms the Markdown into HTML files.
* **Nginx: The Local Web Server:** The HTML files are served by an Nginx server running on that same Raspberry Pi.
* **Cloudflare Argo Tunnels: Secure Access:** Cloudflare Argo Tunnels create a secure connection between my Pi server and Cloudflare's global network, allowing my blog to be publicly accessible without revealing my home IP address.

**The Downtime!**

Everything went smoothly...until it didn't.  One day I experienced a full 24-hour internet outage from my ISP. With my lone Pi offline, my blog completely disappeared from the web. This was unacceptable!  I needed a way to ensure my blog stayed accessible, even during outages.

**The Redundancy Solution**

The fix involved a few key components:

1. **Pi #2 Steps In:** Thankfully, I had another Raspberry Pi sitting unused at my parents' house. I installed Nginx, cloned my blog repository, and spun up an identical instance.
2. **Cloudflare Tunnel Teamwork:** Crucially, instead of creating a separate tunnel, I configured the second Pi as a connector for the *same* Cloudflare Argo Tunnel.
3. **Smart Load Balancing:** Cloudflare then takes over, intelligently distributing traffic between the two servers based on factors like location and server health.
4. **Telling Headers:** Each Nginx server adds a special `X-Served-From` header to outgoing requests, letting me see which Pi handled each visit.

![Architecture Diagram](/tech-stack-architecture.svg)

**Benefits**

* **Redundancy:** If my home internet goes down, traffic is seamlessly diverted to my parents' Pi, and vice versa. No more extended downtime!
* **Load Balancing:** Cloudflare automatically optimizes traffic, ensuring visitors have a smooth experience no matter where they're connecting from. 
* **Affordability:** This was achieved without expensive hardware or complex infrastructure.

**Beyond the Basics**

I'm considering further optimization in the future. Maybe  I'll add a third Pi at a friend's house for even more redundancy. The possibilities are exciting!

**Want to try something similar?**  If you're looking to add robustness to your own self-hosted project, it's worth looking into Cloudflare Argo Tunnels and load balancing strategies. 

Let me know in the comments if you have any questions or have implemented similar setups yourself! 
