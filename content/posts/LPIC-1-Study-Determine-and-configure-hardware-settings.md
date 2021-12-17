---
title: "LPIC 1 Study - Determine and Configure Hardware Settings"
date: 2021-12-13T08:32:17-05:00
author: Joe Cardillo
draft: false 
---

It's been a long time since I've needed to study for anything formal. Recently, though, my work made some positive changes regarding helping us gain more technical proficiency. As a result, I was prompted to start looking at the [learning material](https://learning.lpi.org/en/learning-materials/101-500/101/101.1/101.1_01/) for the LIPC 1. To be truthful, my eyes started glazing over when I realized it was about detecting PCI and USB devices. (It's a weird place to start, in my opinion. But what do I know?) Boring stuff, but necessary to get through. For now, I trust it will get more interesting as I get through it.

Part of it is: I have a hard time with book learning. I do best with hands on experience. Writing about it in my own words helps, too. Which is why I'm doing this. So let's get started.

[Section 101](https://learning.lpi.org/en/learning-materials/101-500/101/101.1/101.1_01/) is about device inspection. This is not something I need to deal with, or interact with, on a daily basis in my job. The basic concept, though, is that when a certain piece of hardware isn't detected by your operating system, you have to know how to troubleshoot it. Either the part, or where it's connected, are defective. Alternatively, if the particular piece of hardware is detected by the OS, but still doesn't work, there may be a problem on the OS side.

I don't deal in hardware at the moment, which is maybe why this section probably felt abstract to me the first time through. But it's starting to make more sense. (It's still troubleshooting at the heart.)


## lspci and lsusb

Two commands that can be used to identify connected devices in Linux are `lspci` and `lsusb`.

`lspci` - Shows all devices connected to the PCI (Peripheral Component Interconnect) bus.

`lsusb` - Lists USB (Universal Serial Bus) devices connected. Mostly used to connect input devices like keyboards, mouses, and removeable storage.

There are two components to PCI and USB devices: software and hardware. The sotware component is called the kernel module.

When I run `lspci` on one of my Debian machines I get this.

![lspci1](/files/lspci1.png)

The hexadecimal numbers at the beginning of each line are the unique addresses of each PCI device. If you use the `-s` option with `-v`, it gives more details about that specific device.

![lspci2](/files/lspci2.png)

This tells us the following information:

* Internal name - `Ethernet controller: Red Hat, Inc Virtio network device`
* Device's brand and model - `Subsystem: Red Hat, Inc Virtio network device`
* Kernel module - `Kernel driver in use: virtio-pci`

