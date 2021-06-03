---
title: "Adding a Persistent Volume to My Kubernetes Cluster"
date: 2021-06-01T07:09:00-04:00
author: Joe Cardillo
draft: false
---

I added a PVC, then updated my deployment file to add the mount point and volume info.

```
        volumeMounts:
          - mountPath: "/mnt/data/images"
            name: nothing-volume
      volumes:
        - name: nothing-volume
          persistentVolumeClaim:
            claimName: nothing-pvc
```

However, that didn't work. According to my pod logs, the volume couldn't attach because it was already attached to a different pod. I think that's because I have 3 replicas.

When I rolled out the new deployment, one of the pods just hung out in ContainerCreating:

```
nothing % kubectl get pods
NAME                                        READY   STATUS              RESTARTS   AGE
ingress-nginx-controller-57cb5bf694-hzkpq   1/1     Running             0          3d14h
nothing-deployment-5ff6f58b49-bkl8r         1/1     Running             0          11s
nothing-deployment-5ff6f58b49-fhppx         0/1     ContainerCreating   0          9s
nothing-deployment-5ff6f58b49-r4sfg         1/1     Running             0          35m
nothing-deployment-747bbbc67b-wvlsr         1/1     Running             0          34m
```

Checking it with `kubectl describe`, I was being told that there was a multi-attach error, which makes sense. Since Volumes can only mount to one pod at a time.

I then ran:

`kubectl get deployment nothing-deployment -o yaml`

The output below seems to be saying there was 1 `unavailableReplicas`, which made me think I should adjust my `maxSurge` and `maxUnavailable` values.

```
status:
  availableReplicas: 3
  conditions:
  - lastTransitionTime: "2021-06-03T10:08:00Z"
    lastUpdateTime: "2021-06-03T10:08:00Z"
    message: Deployment has minimum availability.
    reason: MinimumReplicasAvailable
    status: "True"
    type: Available
  - lastTransitionTime: "2021-06-03T10:21:26Z"
    lastUpdateTime: "2021-06-03T10:21:29Z"
    message: ReplicaSet "nothing-deployment-747bbbc67b" is progressing.
    reason: ReplicaSetUpdated
    status: "True"
    type: Progressing
  observedGeneration: 8
  readyReplicas: 3
  replicas: 4
  unavailableReplicas: 1
  updatedReplicas: 3
```

My PVC is being used by all four of my pods right now. Is that the problem?

Even after making those changes, though, it didn't work.

I ended up just undoing the deployment:

`kubectl rollout undo deployment nothing-deployment`

I scrapped all that and just attached the Volume to a separate pod instead. Same namespace. Same label. Created the pod with the mount path matching my site root at `/usr/share/nginx/html/files`. The file is there when I check with `kubectl exec` on the pod. So let me try to include it in this post with markdown.

I tried rolling my deployment out, but no luck. Still a hanging chad of a pod.

```
docker build -t jcardillo/nothingtoteach:latest .
docker push jcardillo/nothingtoteach:latest
docker rollout restart deployment nothing-deployment
```

Looks like my PVC is still being used by all four of my pods. I wonder if it's because I tried mounting my volume in my deployment file?

```
configs % kubectl describe pvc nothing-pvc
Name:          nothing-pvc
Namespace:     default
StorageClass:  linode-block-storage-retain
Status:        Bound
Volume:        pvc-43ca85cbd4dd4dc3
Labels:        <none>
Annotations:   pv.kubernetes.io/bind-completed: yes
               pv.kubernetes.io/bound-by-controller: yes
               volume.beta.kubernetes.io/storage-provisioner: linodebs.csi.linode.com
Finalizers:    [kubernetes.io/pvc-protection]
Capacity:      10Gi
Access Modes:  RWO
VolumeMode:    Filesystem
Used By:       nginx-volume
               nothing-deployment-7d46fb9f5b-9k7vt
               nothing-deployment-7d46fb9f5b-9wnh9
               nothing-deployment-7d46fb9f5b-gtw84
```

I deleted my PVC. Then reapplied it:

`kubectl apply -f nothing-pvc.yaml`

I also redeployed the NGINX pod I was attaching the volume to. But are up and running now.

After mixing myself up by using the wrong claimName, changing it, deleting the pod I was trying to attach it to, then redeploying the pod, I finally got the volume to attach.

I also copied a file to the volume for testing, and confirmed it's there with `kubectl exec`.
```
kubectl describe pod nginx-volume
...
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  6s    default-scheduler  Successfully assigned default/nginx-volume to lke27824-41419-60b3e46492d0
  Normal  Pulling    5s    kubelet            Pulling image "nginx"
nothing % kubectl exec -it nginx-volume -- /bin/sh -c "ls /usr/share/nginx/html/files"
lost+found
nothing % kubectl cp ~/Desktop/plant_thing.JPG nginx-volume:/usr/share/nginx/html/files
nothing % kubectl exec -it nginx-volume -- /bin/sh -c "ls /usr/share/nginx/html/files"
lost+found  plant_thing.JPG
```

![It's a plant.](/plant_thing.JPG)
