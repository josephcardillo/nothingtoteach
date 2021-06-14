---
title: "Traefik Ingress Issue With Port Binding"
date: 2021-06-14T04:39:53-04:00
draft: false
---

Working through the [Building a Continuous Deployment Pipeline Using LKE, Helm, and Gitlab](https://www.linode.com/docs/guides/lke-continuous-deployment-series/) guide from Linode, I ran into an interesting (and new) problem. In the section on installing Traefik, I couldn't get my NodeBalancer's external-IP to show after running:

```
helm upgrade --install traefik traefik/traefik \
    --create-namespace --namespace traefik \
    --set "ports.websecure.tls.enabled=true" \
    --set "providers.kubernetesIngress.publishedService.enabled=true"
```

It kept telling me my external-IP was `<pending>`.

```
kubectl get svc -n traefik traefik
NAME      TYPE           CLUSTER-IP       EXTERNAL-IP    PORT(S)                      AGE
traefik   LoadBalancer   10.128.36.252    <pending>      80:30560/TCP,443:30958/TCP   17m
```

After much banging of my head against the wall, I noticed the following in my Traefik pod logs:

```
kubectl -n traefik logs traefik-fd6c779b-gpx4c

time="2021-06-11T17:28:07Z" level=error msg="Cannot create service: subset not found" ingress=web namespace=default providerName=kubernetes serviceName=web servicePort=80
```

I wondered, "Could this just be a port binding thing? Is something already bound to that port?"

Earlier in the guide it had me create another service. Checking that, it was already referencing port 80:

```
kubectl get svc web
NAME      TYPE           CLUSTER-IP       EXTERNAL-IP      PORT(S)                    AGE
web       LoadBalancer   10.128.207.36    96.126.119.253   80:32659/TCP               7d1h
```

Aftert deleting my web service and re-running the above Helm command, my Traefik LoadBalancer finally had it's IP address:

```
kubectl get svc -n traefik traefik
NAME      TYPE           CLUSTER-IP       EXTERNAL-IP    PORT(S)                      AGE
traefik   LoadBalancer   10.128.184.157   45.79.240.68   80:30905/TCP,443:31831/TCP   55s
```

And it showed up in my ingress:

```
kubectl get ing
NAME   CLASS    HOSTS                    ADDRESS        PORTS   AGE
web    <none>   ingress.pianosin.space   45.79.240.68   80      2m50s
```

And finally, my external DNS logs also showed my DNS record being created, which wasn't the case before.

```
kubectl logs -n external-dns -l app.kubernetes.io/name=external-dns | tail -2
time="2021-06-11T17:39:26Z" level=info msg="Creating record." action=Create record=ingress type=A zoneID=1440923 zoneName=pianosin.space
time="2021-06-11T17:39:26Z" level=info msg="Creating record." action=Create record=ingress type=TXT zoneID=1440923 zoneName=pianosin.space
```

While this solved the issue, I'm also realizing I definitely have some more learning to do around Ports, NodePorts and TargetPorts. I've set up multiple LoadBalancers on the same cluster before, all referencing port 80 as well, so something tells me I'm not fully grasping this concept yet. Either way, whatever it was, that previously created service was definitely preventing Traefik from doing it's thing.
