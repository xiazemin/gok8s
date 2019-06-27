#!/bin/bash
kubectl create namespace kube-apps
#Error from server (NotFound): error when creating "k8s.yaml": namespaces "kube-apps" not found
#Error from server (NotFound): error when creating "k8s.yaml": namespaces "kube-apps" not found
#Error from server (NotFound): error when creating "k8s.yaml": namespaces "kube-apps" not found
#namespace "kube-apps" created

kubectl apply -f k8s.yaml

#deployment.extensions "goapp-deploy" created
#service "goapp-svc" created
#ingress.extensions "goapp-ingress" created

kubectl get deployments -n kube-apps |grep goapp
#goapp-deploy   2         2         2            0           1m

kubectl get svc -n kube-apps |grep goapp
#goapp-svc   ClusterIP   10.100.253.241   <none>        8085/TCP   1m

kubectl get ingress -n kube-apps |grep goapp
#goapp-ingress   goappk8s.local             80        2m

kubectl get pods -n kube-apps |grep goapp
#goapp-deploy-5d86bf57b4-67ftg   0/1       ErrImagePull   0          2m
#goapp-deploy-5d86bf57b4-wh8dl   0/1       ErrImagePull   0          2m

kubectl describe pod goapp-deploy-5d86bf57b4-67ftg
#Error from server (NotFound): pods "goapp-deploy-5d86bf57b4-67ftg" not found

kubectl get pods -n kube-apps |grep goapp
#goapp-deploy-5d86bf57b4-67ftg   0/1       ImagePullBackOff   0          4m
#goapp-deploy-5d86bf57b4-wh8dl   0/1       ImagePullBackOff   0          4m

#docker stop a8b2144426e7

#镜像在本地,所以拉不到
#Failed to pull image "xiazemin/docker-multi-stage-demo:old": rpc error: code = Unknown desc = Error response from daemon: pull access denied for xiazemin/docker-multi-stage-demo, repository does not exist or may require 'docker login'
#imagePullPolicy: Always
#imagePullPolicy: Never   --从不拉取

kubectl get pods -n kube-apps |grep goapp
#goapp-deploy-5d86bf57b4-wh8dl   0/1       ImagePullBackOff   0          13m
#goapp-deploy-6cf69874d9-5vlgj   0/1       Running            0          11s
#goapp-deploy-6cf69874d9-whmxq   0/1       Running            0          10s

kubectl get pods -n kube-apps |grep goapp
#goapp-deploy-6cf69874d9-5vlgj   0/1       Running            6          4m
#goapp-deploy-6cf69874d9-whmxq   0/1       CrashLoopBackOff   5          4m

 kubectl describe pods

#Liveness probe failed: dial tcp 10.1.0.19:8080: getsockopt: connection refused
#Back-off restarting failed container

kubectl get deployments
#NAME       DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
#db         1         1         1            1           3h
#my-nginx   2         2         2            2           8h
#web        1         1         1            0           3h
#words      5         5         5            3           3h


kubectl get services
#NAME            TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
#db              ClusterIP      None             <none>        55555/TCP        3h
#kubernetes      ClusterIP      10.96.0.1        <none>        443/TCP          9h
#web             ClusterIP      None             <none>        55555/TCP        3h
#web-published   LoadBalancer   10.101.193.124   localhost     8087:31732/TCP   3h
#words           ClusterIP      None             <none>        55555/TCP        3h


#docker stack remove demo
#kubectl delete deployment kubernetes-dashboard --namespace kube-system

docker ps |grep goapp
#cda6f5aedfdd        0c1836a4886c                             "app-server"             14 minutes ago      Up 14 minutes                                                      k8s_goappk8s_goapp-deploy-767986448b-8t5d8_kube-apps_6580f55e-9813-11e9-8405-025000000001_0
#005219ab9f72        0c1836a4886c                             "app-server"             14 minutes ago      Up 14 minutes                                                      k8s_goappk8s_goapp-deploy-767986448b-dfn5d_kube-apps_6509494f-9813-11e9-8405-025000000001_0
#012276194de3        k8s.gcr.io/pause-amd64:3.1               "/pause"                 15 minutes ago      Up 14 minutes                                                      k8s_POD_goapp-deploy-767986448b-8t5d8_kube-apps_6580f55e-9813-11e9-8405-025000000001_0
#69850bbf272b        k8s.gcr.io/pause-amd64:3.1               "/pause"                 15 minutes ago      Up 15 minutes                                                      k8s_POD_goapp-deploy-767986448b-dfn5d_kube-apps_6509494f-9813-11e9-8405-025000000001_0

kubectl cluster-info
#Kubernetes master is running at https://localhost:6443
#KubeDNS is running at https://localhost:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

#To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

kubectl run goxiazemin --image=xiazemin/docker-multi-stage-demo:latest --port=8085 --image-pull-policy=Never
#deployment.apps "goxiazemin" created

kubectl get deployments
#NAME         DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
#db           1         1         1            1           3h
#goxiazemin   1         1         1            1           29s

kubectl get events |grep xiazemin
#1m          1m           1         goxiazemin-5d89ffc6dd-2c6bx.15abc2c7ba461724   Pod                                        Normal    Scheduled               default-scheduler             Successfully assigned goxiazemin-5d89ffc6dd-2c6bx to docker-for-desktop

kubectl expose deployment goxiazemin --type=LoadBalancer
#service "goxiazemin" exposed

kubectl get svc
#NAME            TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
#db              ClusterIP      None             <none>        55555/TCP        3h
#goxiazemin      LoadBalancer   10.109.145.90    localhost     8085:32112/TCP   18s

http://localhost:8085/ping
#pong

#kind: Service
#原配置文件加上：type: LoadBalancer
