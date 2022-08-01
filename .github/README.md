# Getting to know `kubernetes`
Getting to know `kubernetes` by way of `minikube`
> Minikube is a tool that makes it easy to run
> Kubernetes locally. Minikube runs a single-node
> Kubernetes cluster inside a VM on your laptop for users looking
> to try out Kubernetes or develop with it day-to-day.

This `README` will walk you through getting `minikube` and `kubectl` installed. After
that, you can follow the [Hello minikube tutorial](#hello-minikube-tutorial) section to deploy to your
kubernetes cluster.

We are running ...
* macOS Monterey
* on M1 Max chip.
* with Docker Desktop 4.10.1

## Getting Started with [`k8s`](https://kubernetes.io/) and [`minikube`](https://github.com/kubernetes/minikube#minikube)

Let's get you up and running.

### 1. Install `minikube`

`brew install minikube`

### 2. Install `kubectl`

If you're a GCP user, you may wish to install using the Google Cloud SDK: `gcloud components install kubectl`

If you're not, you can use homebrew: `brew install kubectl`

### 3. Start `minikube`

`minikube start`

You'll see something like this:
```
😄  minikube v1.26.0 on Darwin 12.5 (arm64)
✨  Automatically selected the docker driver
📌  Using Docker Desktop driver with root privileges
👍  Starting control plane node minikube in cluster minikube
🚜  Pulling base image ...
💾  Downloading Kubernetes v1.24.1 preload ...
    > preloaded-images-k8s-v18-v1...: 342.86 MiB / 342.86 MiB  100.00% 3.68 MiB
    > gcr.io/k8s-minikube/kicbase: 347.17 MiB / 347.17 MiB  100.00% 2.94 MiB p/
    > gcr.io/k8s-minikube/kicbase: 0 B [_________________________] ?% ? p/s 49s
🔥  Creating docker container (CPUs=2, Memory=15939MB) ...
🐳  Preparing Kubernetes v1.24.1 on Docker 20.10.17 ...
    ▪ Generating certificates and keys ...
    ▪ Booting up control plane ...
    ▪ Configuring RBAC rules ...
🔎  Verifying Kubernetes components...
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
🌟  Enabled addons: storage-provisioner, default-storageclass
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
```

##### If you have trouble starting

Try running the [delete instructions](7-optional-delete-and-purge-configurations) and then
re-try the start command.

#### Post Startup
After it's finished its startup, check status:

`minikube status`


You'll see something like this:
```
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured
```

### 4. Set `kubectl` context

`kubectl config use-context minikube`

You'll see something like this:

`Switched to context "minikube".`

You can verify:

`kubectl cluster-info`

You'll see something like this:

```
Kubernetes control plane is running at https://127.0.0.1:61870
CoreDNS is running at https://127.0.0.1:61870/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

### 5. Open your `kubernetes` dashboard

`minikube dashboard`

You'll see something like this:

```
🔌  Enabling dashboard ...
    ▪ Using image kubernetesui/dashboard:v2.6.0
    ▪ Using image kubernetesui/metrics-scraper:v1.0.8
🤔  Verifying dashboard health ...
🚀  Launching proxy ...
🤔  Verifying proxy health ...
🎉  Opening http://127.0.0.1:62094/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/ in your default browser...
```

And voila! Your browser will open that URL.


# Hello minikube tutorial
This repo is adapted from [kubernetes' hello minikube tutorial](https://kubernetes.io/docs/tutorials/hello-minikube/).

In this tutorial, we will build a docker image and deploy it using `kubernetes`.


### 1. Reuse the Docker daemon
Let's point our SHELL to minikube's docker-daemon to do our building.

`eval $(minikube -p minikube docker-env)`

If you want to be sure it worked, try running `docker ps`. You'll see all the `k8s` containers running in minikube.

To unset the environment: `eval $(minikube docker-env -u)`

### 2. Build the image

`docker build . -t hello-node:v1`


### 3. Create a Deployment
> A Kubernetes [Pod](https://kubernetes.io/docs/concepts/workloads/pods/pod/) is a group of one or more Containers, tied together for the purposes of
> administration and networking. The Pod in this tutorial has only one Container.
>
> A Kubernetes [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) checks on the health of your Pod and restarts the Pod’s Container
> if it terminates. Deployments are the recommended way to manage the creation and scaling
> of Pods.

**Create the Deployment**

`kubectl create deployment hello-node --image=hello-node:v1`

**View the Deployment**

`kubectl get deployments`

**View the Pod**

`kubectl get pods`

### 4. Create a Service
> By default, the Pod is only accessible by its internal IP address
> within the Kubernetes cluster. To make the hello-node Container accessible
> from outside the Kubernetes virtual network, you have to expose the
> Pod as a Kubernetes [Service](https://kubernetes.io/docs/concepts/services-networking/service/).

`kubectl expose deployment hello-node --type=LoadBalancer --port 8080`

### 5. Expose your App
> The `--type=LoadBalancer` flag indicates that you want to expose your
> Service outside of the cluster. In GCP's Kubernetes Engine, an external
> IP address would be provisioned to access the Service.
> In Minikube, the LoadBalancer type makes the Service accessible
> through the minikube service command:

`minikube service hello-node`

This will open a browser window to your app. Open your `minikube dashboard` to
have a look around!

### 6. Shut it down

`minikube stop`

You'll see something like this:

```
✋  Stopping node "minikube"  ...
🛑  Powering off "minikube" via SSH ...
🛑  1 node stopped.
```

#### 7. (Optional) Delete and purge configurations

`minikube delete --all --purge`

You'll see something like this:

```
🔥  Deleting "minikube" in docker ...
🔥  Removing /Users/User_Name/.minikube/machines/minikube ...
💀  Removed all traces of the "minikube" cluster.
🔥  Successfully deleted all profiles
💀  Successfully purged minikube directory located at - [/Users/User_Name/.minikube]
📌  Kicbase images have not been deleted. To delete images run:
    ▪ docker rmi gcr.io/k8s-minikube/kicbase:v0.0.32
```

## Resources
* [Kubernetes 101](https://kubernetes.io/docs/tutorials/k8s101/)
* [Kubernetes 201](https://kubernetes.io/docs/tutorials/k8s201/)

### Playgrounds
* [Katacoda](https://www.katacoda.com/courses/kubernetes/playground)
* [Play with Kubernetes](https://labs.play-with-k8s.com/)
