# Getting to know `kubernetes`
Getting to know `kubernetes` by way of `minikube`
> Minikube is a tool that makes it easy to run
> Kubernetes locally. Minikube runs a single-node
> Kubernetes cluster inside a VM on your laptop for users looking
> to try out Kubernetes or develop with it day-to-day.

This `README` will walk you through getting `minikube` and `kubectl` installed. After
that, you can follow the [Hello minikube tutorial](#hello-minikube-tutorial) section to deploy to your
kubernetes cluster.

We assume that you're running on macOS, and that you have already installed
[VirtualBox](http://www.virtualbox.org) (`minikube` runs kubernetes components in a VM).


## Getting Started with [`k8s`](https://kubernetes.io/) and [`minikube`](https://github.com/kubernetes/minikube#minikube)

Let's get you up and running.

### 1. Install `minikube`

`brew install minikube`

### 2. Install `kubectl`

If you're a GCP user, you may wish to install using the Google Cloud SDK: `gcloud components install kubectl`

If you're not, you can use homebrew: `brew install kubectl`

### 3. Start `minikube`

`minikube start --driver=virtualbox`

This will take a little time as it spins up the VM.  Expect to see output that looks something like this:

```
😄  minikube v1.18.1 on Darwin 10.15.7
✨  Using the virtualbox driver based on user configuration
💿  Downloading VM boot image ...
    > minikube-v1.18.0.iso.sha256: 65 B / 65 B [-------------] 100.00% ? p/s 0s
    > minikube-v1.18.0.iso: 212.99 MiB / 212.99 MiB [] 100.00% 8.68 MiB p/s 24s
👍  Starting control plane node minikube in cluster minikube
💾  Downloading Kubernetes v1.20.2 preload ...
    > preloaded-images-k8s-v9-v1....: 491.22 MiB / 491.22 MiB  100.00% 8.51 MiB
🔥  Creating virtualbox VM (CPUs=2, Memory=6000MB, Disk=20000MB) ...
🐳  Preparing Kubernetes v1.20.2 on Docker 20.10.3 ...
    ▪ Generating certificates and keys ...
    ▪ Booting up control plane ...
    ▪ Configuring RBAC rules ...
🔎  Verifying Kubernetes components...
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v4
🌟  Enabled addons: storage-provisioner, default-storageclass

❗  /Users/westm1/Google/google-cloud-sdk/bin/kubectl is version 1.17.17-dispatcher, which may have incompatibilites with Kubernetes 1.20.2.
    ▪ Want kubectl v1.20.2? Try 'minikube kubectl -- get pods -A'
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default

```

#### In case of trouble
If you have trouble starting minikube in this fashion (e.g. `⛔  Exiting due to RSRC_INSUFFICIENT_REQ_MEMORY`), try purging any pre-existing configs
and re-try the start command.

`minikube delete --all --purge`

```
🔥  Deleting "minikube" in virtualbox ...
💀  Removed all traces of the "minikube" cluster.
🔥  Successfully deleted all profiles
💀  Successfully purged minikube directory located at - [/Users/xxx/.minikube]
```

Now, try to start again.

#### Post Startup
After it's finished its startup, check status:

`minikube status`


You should see something like this:
```
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured
timeToStop: Nonexistent
```

### 4. Set `kubectl` context

`kubectl config use-context minikube`

After which you can verify:

`kubectl cluster-info`

You should see something like this:
```
Kubernetes master is running at https://192.168.99.108:8443
KubeDNS is running at https://192.168.99.108:8443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

### 5. Open your `kubernetes` dashboard

`minikube dashboard`

You'll see something like this:

```
🔌  Enabling dashboard ...
    ▪ Using image kubernetesui/dashboard:v2.1.0
    ▪ Using image kubernetesui/metrics-scraper:v1.0.4
🤔  Verifying dashboard health ...
🚀  Launching proxy ...
🤔  Verifying proxy health ...
🎉  Opening http://127.0.0.1:58673/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/ in your default browser...
```

And voila! Your browser will open that URL.


# Hello minikube tutorial
This repo is adapted from [kubernetes' hello minikube tutorial](https://kubernetes.io/docs/tutorials/hello-minikube/).

In this tutorial, we will build a docker image and deploy it using `kubernetes`.


### 1. Reuse the Docker daemon
To speed things up locally, we'll use the Docker daemon in `minikube`
to do our building.

`eval $(minikube docker-env)`

If you want to be sure it worked, try running `docker ps`. You'll see all
the `k8s` containers running.

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

## Resources
* [Kubernetes 101](https://kubernetes.io/docs/tutorials/k8s101/)
* [Kubernetes 201](https://kubernetes.io/docs/tutorials/k8s201/)

### Playgrounds
* [Katacoda](https://www.katacoda.com/courses/kubernetes/playground)
* [Play with Kubernetes](https://labs.play-with-k8s.com/)
