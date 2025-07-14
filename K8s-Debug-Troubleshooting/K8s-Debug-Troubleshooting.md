# Kubernetes Troubleshooting Guide

## Introduction
When deploying an application to Kubernetes, you typically work with three core components:
- **Deployment**: A blueprint that specifies how to run your application, including the number of replicas.
- **Service**: An internal load balancer that routes traffic to the pods.
- **Ingress**: A resource that manages how to route external traffic into the cluster.

In Kubernetes, applications are exposed via two layers of load balancers: **internal (Service)** and **external (Ingress)**. Pods are not deployed directly; they are managed by a higher-level abstraction, which is the **Deployment**.

---

## 1. Connecting Deployment & Service
Kubernetes Services and Deployments are not directly connected. The Service routes traffic to pods, while the Deployment manages the pods.

### Key Points to Remember:
- The **service selector** must match the labels of at least one pod.
- The **targetPort** of the service should match the container's port.
- The **service port** can be any number, as long as it doesn't conflict with other services' ports.

### How to Verify Deployment and Service Configuration:
- Check pod labels:
  ```bash
  kubectl get pods --show-labels
  ```
  Or filter by selector:
  ```bash
  kubectl get pods --selector app=my-app1 --show-labels
  ```
- Check the endpoints of the service:
  ```bash
  kubectl get endpoints ClusterIP-service-name
  ```
- Port forward to the service and verify the connection:
  ```bash
  # First terminal
  kubectl port-forward service/my-service 3000:7070

  # Second terminal
  curl localhost:3000/api/devices
  ```

---

## 2. Connecting Service & Ingress
To make your application accessible from outside the Kubernetes cluster, you need to configure **Ingress**.

### Steps:
1. Ensure the **service.name** on the ingress matches the service name.
2. Ensure the **service.port** on the ingress matches the exposed service port.
3. **Test the Ingress** using port forwarding:
   ```bash
   minikube start
   minikube addons enable ingress
   kubectl apply -f 7-example
   kubectl get pods -n ingress-nginx
   kubectl port-forward nginx-ingress-controller-name 3000:80 -n ingress-nginx
   curl localhost:3000/api/devices
   ```

### Routing via Domain:
For advanced setups with multiple applications sharing the same load balancer:
```bash
kubectl apply -f 9-example
curl --header 'Host: api.example.pvt' localhost:3000/api/devices
```

---

## 3. Recap on Ports
### Matching Criteria:
- **Service selector** should match pod labels.
- **Service targetPort** should match the containerPort in the pod.
- **Service port** can be any number, as services are isolated by their IP addresses.
- **Ingress service.port** should match the exposed service port.
- **Ingress service.name** should match the service name.

---

## 4. 3 Steps to Debug Kubernetes
1. **Check the Pod**: Ensure that the pod is running and ready.
2. **Check the Service**: Verify if the service can distribute traffic to the pods.
3. **Check the Ingress**: Investigate the connection between the service and the ingress.

---

## 5. How to Debug Pods
To debug a pod, check if it's running and ready, then investigate logs and events.

### Commands to Debug Pods:
- Get pod status:
  ```bash
  kubectl get pods
  ```
- View pod logs:
  ```bash
  kubectl logs -f pod-name
  ```
- Describe the pod to view events:
  ```bash
  kubectl describe pod pod-name
  ```
- Extract YAML definition:
  ```bash
  kubectl get pod pod-name -o yaml
  ```
- Access the pod interactively:
  ```bash
  kubectl exec -it pod-name -- bash
  ```

---

## 6. Common Pod Errors

### ImagePullBackOff
Occurs when Kubernetes can't pull the image. Causes:
- Incorrect image name or tag
- Private image with missing credentials

Fix:
```bash
kubectl describe pod pod-name
```

### CrashLoopBackOff
Occurs when containers repeatedly crash. Causes:
- App errors at startup
- Background-only processes
- Liveness probe failures

Fix:
```bash
kubectl logs pod-name
kubectl logs pod-name -f
kubectl logs pod-name -p
```

### RunContainerError
Occurs when the container can't start. Causes:
- Mounting non-existent ConfigMap/Secret
- Volume mode mismatch

Fix:
```bash
kubectl describe pod pod-name
```

### Pending Pod
Causes:
- Insufficient resources
- Namespace quota exceeded
- PVCs not bound
- Node selectors/tolerations/affinity issues

Fix:
```bash
kubectl describe pod pod-name
```

### Not Ready Pod
Readiness probe fails â†’ no traffic routed by Service

Fix:
```bash
kubectl describe pod pod-name
kubectl logs -f pod-name
kubectl logs -f pod-name -c container-name
```

---

## 7. How to Debug Services
When pods are ready but the service is not working:

### Checklist:
- Verify that endpoints exist for the service:
  ```bash
  kubectl get pods -o wide
  kubectl get endpoints my-service
  ```

- Port forward to test traffic flow:
  ```bash
  # First terminal
  kubectl port-forward service/my-service 3000:7070

  # Second terminal
  curl localhost:3000/api/devices
  ```

---

## 8. How to Debug Ingress
When pods and services are fine, but you can't access the app:

### Basic Ingress Debug:
- Check ingress config:
  ```bash
  kubectl get ing
  kubectl describe ing my-ingress
  ```

- Port forward to Ingress controller:
  ```bash
  kubectl get pods -n ingress-nginx
  kubectl describe pod nginx-ingress-controller-pod-name -n ingress-nginx | grep Ports

  # First terminal
  kubectl port-forward nginx-ingress-controller-pod-name 3000:80 -n ingress-nginx

  # Second terminal
  curl localhost:3000/api/devices
  ```

If this works â†’ infrastructure issue (e.g., LB exposure)

If not â†’ misconfigured Ingress

Each ingress controller (e.g., NGINX, HAProxy, Traefik) has its own debugging docs. Refer to them as needed.

---

## 9. Summary

You should always debug **bottom-up**:
1. Start with **Pods**
2. Then move to **Service**
3. Finally debug the **Ingress**

> These techniques also apply to other Kubernetes resources like:
> - Jobs
> - CronJobs
> - StatefulSets
> - DaemonSets

Stay tuned for more advanced guides like Ingress + TLS with cert-manager.

---

## Additional Resources
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Prometheus Monitoring Guide](https://prometheus.io/docs/introduction/overview/)