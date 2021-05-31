---
title: "Getting more familiar with Kubernetes and LKE (Linode Kubernetes Engine)"
date: 2021-05-31T05:53:53-04:00
author: Joe Cardillo
draft: false
---

A few weeks ago I started studying Kubernetes using the Certified Kubernetes Administrator course in O'Reilly (by Sander Van Vugt). We started offering LKE (Linode Kubernetes Engine) at Linode in Spring of 2020, and it's been a thorn in my side not understanding it well enough, being in Customer Support. It's true that the only portion of LKE that's "Managed" is the Control Plane. However, I didn't feel I knew enough about Kubernetes to understand the difference between what we manage and what was the customer's responsibility.

The course has been really helpful, though there's still a bit of content left. Part of the reason it's taking me some time to get through it is because I'm trying to apply the primary concepts I'm learning. I'm almost embarrassed to say I didn't understand some of the most basic things about it before this. Like needing a LoadBalancer to make the cluster accessible to the public internet. Or what the purpose of manifests are. Or the difference between PVCs and PVs. In the words of a co-worker, (paraphrased), "The more I learned about Kubernetes, the more I realized how much I didn't know about Kubernetes."

To challenge myself further, I built this site using it. Perhaps it's a bit overkill, but I'm learning a lot as I break stuff. Yesterday I banged my head against the keyboard for a good bit just trying to get TLS installed.

I'd like to write a post soon about the experience, and flesh it out a bit, since I also learn more by writing about what I'm learning. In the meantime, I'm going to try and get a Persistent Volume added so I can add pics on here from time to time.
