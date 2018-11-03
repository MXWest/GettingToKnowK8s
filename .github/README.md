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

`brew cask install minikube`

### 2. Install `kubectl`

If you're a GCP user, you may wish to install using the Google Cloud SDK: `gcloud components install kubectl`

If you're not, you can use homebrew: `brew cask install kubectl`

### 3. Start `minikube`

`minikube start`

This will take a little time as it spins up the VM. You should
expect to see output that looks something like this:

```
Starting local Kubernetes v1.10.0 cluster...
Starting VM...
Getting VM IP address...
```

After it's finished its startup, check status:

`minikube status`


You should see something like this:
```
minikube status
minikube: Running
cluster: Running
kubectl: Correctly Configured: pointing to minikube-vm at 192.168.99.100
```

### 4. Set `kubectl` context

`kubectl config use-context minikube`

After which you can verify:

`kubectl cluster-info`

You should see something like this:
```
Kubernetes master is running at https://192.168.99.100:8443
KubeDNS is running at https://192.168.99.100:8443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

### 5. Open your `kubernetes` dashboard

`minikube dashboard`


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

`kubectl run hello-node --image=hello-node:v1 --port=8080`

**View the Deployment**

`kubectl get deployments`

**View the Pod**

`kubectl get pods`

### 4. Create a Service
> By default, the Pod is only accessible by its internal IP address
> within the Kubernetes cluster. To make the hello-node Container accessible
> from outside the Kubernetes virtual network, you have to expose the
> Pod as a Kubernetes [Service](https://kubernetes.io/docs/concepts/services-networking/service/).

`kubectl expose deployment hello-node --type=LoadBalancer`

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
