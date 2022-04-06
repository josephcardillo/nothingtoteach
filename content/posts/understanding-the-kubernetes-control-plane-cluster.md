---
title: "Understanding the Kubernetes Control Plane Cluster"
date: 2022-01-29T08:08:41-05:00
author: Joe Cardillo
draft: false
---

Even though I've been working with Kubernetes for the better part of a year, I've only recently come across a helpful analogy for understanding the control plane cluster in a way that makes sense in every day (layperson) terms.

It's the Shipping Analogy. Perhaps more pertinent today with all the shipping delays going on. Either way, let's dive in.

## Ship analogy

There are two main parts to a Kubernetes cluster. The master node and the worker nodes.

The master node is like the dock, which is responsible for all the management, logistics, communications and operations of everything. It's the control center. It's where the magic happens.

The worker nodes are like the "ships" that come into dock to receive and transport containers.

## Control Plane Components

There are various aspects to a dock's operations that allow it to run smoothly. Let's think of the dock as the master node.

* **Master node** - The dock hosts different offices and compartments responsible for loading the right containers onto the correct worker nodes. It oversees the logistics, communication and monitoring of the whole operation. It's comprised of the following components (referred to as the control plane components, or **CPC**).

    * **etcd** - The dock needs to store information (on paper or digitally) about the ships currently docked, or waiting to dock, what containers are on which ship, what time the containers were loaded, etc. 
    
        * On a Kubernetes master node, this info is stored in etcd, which is a "highly available key-value store". A key-value store is simply a way of storing information. For example, a key might be the name of the ship ("The Destroyer") and the associated value might be the containers currently on-board. What's most important to understand is simply that etcd is where data about the cluster is stored.

    * **kube scheduler** - A dock is full of cranes. The crane operators identify the containers that need to be placed on each ship, they identify the right ship for each container based on its size, capacity, the number of containers already on the ship, where it's going, and what kind of containers each ship is allowed to carry.

        * On the master node, the kube scheduler identifies the right node to place a container on based on the container's resource requirements, the worker node's capacity, or any other policies or constraints -- such as taints, tolerations, affinities -- that might help guide decision making regarding container placement.

    * **(Kube & Cloud) Controller Manager** - These are like offices on the "dock" assigned to certain tasks. For example:

        * _Operations Team_ - Oversees traffic control, ship handling, issues related to damages, and the routes each ship takes.

        * _Cargo Team_ - Oversees container damages. If a container is damaged, destroyed or lost, they make sure new containers are made available.

        * _Services Office_ - Oversees IT and communications between ships.

        * Similarly, the master node has a _node controller_ and a _replication controller_.

        * **Node Controller** - Responsible for on-boarding new nodes to the cluster, handling situations where nodes become unavailable or get destroyed.

        * **Replication Controller** - Ensures the desired number of containers are running at all times, in each replication group.

    * **kube-apiserver** - On a dock, there is a central command office that oversees the entire operation, communicates with each department, and helps make sure everything is running smoothly and on schedule.

        * On a kubernetes master node, this is the equivalent of the kube-apiserver. (In some ways the central component of the cluster. The kube-apiserver exposes the kubernetes API. In other words, this is what gives you access to interact with and perform management operations on the cluster, using a command-line tool like kubectl.

## Nodes

Moving on from the master node, let's take a look at what runs on the worker nodes.

* **Container Runtime Engine** - Moving away from the shipping analogy for a moment, all of the applications that run on a cluster are run in containers. All of the control plane components (on the master node) can be run in containers, as well as the cluster's DNS and networking solutions. Therefore we need software to be able to run all these containers. This is what the container runtime engine is for.

    * A popular container runtime engine is Docker. (Other CREs are supported, as well - such as containerd or rkt.) This needs to be installed on all the nodes, including the master node (if the CPCs are being hosted as containers).

* **kubelet** - Each ship needs a captain. The captain is responsible for managing all activity on the ships, communicating with the dock, and letting them know they are waiting to enter or leave. They also receive communication about what containers are to be loaded on the ship, and report back to the dock about the status of their ship and containers.

    * Similarly, kubelet runs on each node in a cluster and listens for instructions from the kube-apiserver. kubelet deploys/destroys containers on each node as requested by the master node. The kube-apiserver periodically reaches out to each kubelet to gather information about the status of each node and its containers.

* **kube-proxy** - How can each node, and the containers on them, communicate with each other? For example, what if a web server is running in a container on node-1, and the needed database is running on a container in node-2? This is where the kube-proxy service comes in. kube-proxy makes sure the necessary rules exist on each node to allow them to communicate with each other.