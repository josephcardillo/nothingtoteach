---
title: "LPIC 1 Study Booting a Linux System - BIOS vs. UEFI"
date: 2022-01-07T13:18:18-05:00
author: JC
draft: false
---

This chapter is all about the boot process.

* The kernel is loaded by the bootloader
* The bootloader is loaded by pre-installed firmware such as BIOS or UEFI
* The bootloader can be customized to pass certain parameters to the kernel such as
    * which partition contains the root FS
    * in which mode the OS should execute
* Once the kernel is loaded, it continues the boot process by identifying and configuring the hardware
* Lastly, the kernel calls the utility responsible for starting and managing the system's services

## BIOS or UEFI

### BIOS
* The procedures for running a bootloader differ whether BIOS or UEFI is used
* BIOS stands for Basic Input/Output System
    * Stored in non-volatile memory chip attached to motherboard
    * executed every time the computer is powered on
    * BIOS is known as _firmware_
    * Its storage location is different from other storage devices the system may have
    * BIOS assumes the first 440 bytes in the first storage device are the first stage of the bootloader (which is also called _bootstrap_)
    * The first 512 bytes of a storage device are named the MBR (Master Boot Record)
    * The MBR contains the partition table

### Steps to boot a system equipped with BIOS
1) POST (_power-on self-test_) process. Used to identify simple hardware failures as soon as the machine is powered on
2) BIOS activates basic components to load the system, such as video output, keyboard and storage media
3) The BIOS loads the first stage of the bootloader from the MBR (the first 440 bytes of the first device)
4) The first stage of the bootloader calls the second stage of the bootloader, which is responsible for presenting boot options and loading the kernel

### UEFI
* Stands for _Unified Extensible Firmware Interface_
* Differs from BIOS as follows:
    * UEFI is also a firmware, though it can identify partitions and read many filesystems found in them
    * UEFI does not rely on the MBR
    * Instead, it only takes into account the settings stored in its non-volatile memory (_NVRAM_) attached to the motherboard
    * The info stored in NVRAM  indicate the location of the UEFI compatible programs, which are called _EFI applications_. EFI applications will be executed automatically or called from a boot menu.
    * What are EFI applications? They can be bootloaders, operating system selectors, tool for system diagnostics and repair, etc.
    * EFI applications need to be in a conventional storage device partition and in a compatible filesystem
    * Standard compatible filesystems are FAT12, FAT16 and FAT32 for block devices and ISO-9660 for optical media
    * The benefits of this approach are that it allows for the implementation of much more sophisticated tools than those possible with BIOS
* The partition containing the EFI applications is called the _EFI System Partition_, or just ESP.
* The ESP must not be shared with other system filesystems, like the root filesystem or user data filesystems
* The EFI directory in the ESP partition contains the applications pointed to by the entries saved in the NVRAM

### Steps to boot a system equipped with UEFI
1) POST (_power-on self-test_) process. Used to identify simple hardware failures as soon as the machine is powered on.
2) Similar to BIOS, the UEFI activates the basic components to load the system, like video output, keyboard and storage media
3) UEFI's firmware reads the definitions stored in NVRAM to execute the pre-defined EFI application stored in the ESP partition's filesystem. Usually, the pre-defined EFI application is a bootloader.
4) If the pre-defined EFI application is a bootloader, it will load the kernel to start the OS.

### Secure Boot
A feature of UEFI is that it supports a feature called _Secure Boot_. Secure Boot allows only signed EFI applications to be executed. A signed EFI application is one that's been authorized by the hardware manufacturer. This helps protect against malicious software, though it can make it difficult to install operating systems not covered by the manufacturer's warranty.


