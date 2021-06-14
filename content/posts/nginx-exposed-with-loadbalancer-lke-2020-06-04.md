---
title: "Kubernetes - Nginx Exposed With Loadbalancer"
date: 2021-06-04T11:57:32-04:00
author: Joe Cardillo
draft: false
---

The first thing I tried doing in my effort to learn more about Kubernetes (using LKE, specifically) was to create a default NGINX page and expose it via a LoadBalancer (NodeBalancer). I had no idea how to go about this, initially. I eventually figured out, though, how to accomplish this using YAML files I found on the kubernetes.io website, as well as from a random YouTube video, which was helpful. What I am only now just realizing is that this can literally be done in two steps (without YAML files):

```
kubectl create deployment web --image=nginx
kubectl expose deployment web --port=80 --type=LoadBalancer
```
