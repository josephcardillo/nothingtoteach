---
title: "Introduction to Etcd - What is a key-value store?"
date: 2022-01-30T08:03:36-05:00
author: Joe Cardillo
draft: false
---

# Introduction to ETCD

## What is ETCD?

The technical definition is: "ETCD is a distributed, reliable key-value store that is simple, secure & fast." What does that mean, though?

## What is a key-value store?

We most often see databases in tabular format. Which, in other words, is just data stored in rows and columns. For example, you might have a column for "Name", and second for "Age", a third for "Favorite food", and so on.

A key-value store is a bit different in that you cannot have duplicate keys. In other words, there can only be one key called "Name". Each key has an associated value.

**Key:** Name

**Value:** John

**Key:** Age

**Value:** 34

**Key:** Favorite-food

**Value:** Ice cream

This is useful for storing small chunks of data that require fast read/write.

## Installing and running etcd

To test out using etcd as a key-value store, install it locally. At the time of writing, v3.5.1 is [the latest](https://github.com/etcd-io/etcd/releases).

I used these commands to install it on a vanilla Debian server.

```
curl -L  https://github.com/coreos/etcd/releases/download/v3.5.1/etcd-v3.5.1-linux-amd64.tar.gz -o etcd-v3.5.1-linux-amd64.tar.gz
tar xzvf etcd-v3.5.1-linux-amd64.tar.gz
rm etcd-v3.5.1-linux-amd64.tar.gz
```

Export `etcd-v3.5.1-linux-amd64` to your PATH.

`export PATH=$PATH:/path/to/etcd-v3.5.1-linux-amd64`

Run `etcd` to start it. This will run a service that listens or port 2379.

```
$ ss -plunt | grep :2379
tcp    LISTEN     0      128    127.0.0.1:2379                  *:*                   users:(("etcd",pid=2394,fd=8))
```

In a new screen session (or with tmux), you can create a key-value store using etcdctl. (Note: You'll need to export your PATH again in the new terminal window/screen/pane, unless you added it permanently to your PATH in your bash profile.)

Now you can create a key-value store using etcdctl.

```
$ etcdctl put name joe
OK
```

To view the value associated with this key (name), run:
```
$ etcdctl get name
name
joe
```
