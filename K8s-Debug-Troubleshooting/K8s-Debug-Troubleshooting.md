
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
  kubectl get pods --selector app=my-app1 --show-labels -o wide
  ```
- Port forward to the service and verify the connection:
  ```bash
  # First terminal
  kubectl port-forward service/my-service 3000:7070

  # Second terminal
  curl localhost:3000/api/devices
  /*
  Explaination:
	If you can connect, the setup is correct. If you cannot, you most likely misplaced a
	label or the port doesn't match.
  */
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
  cat /etc/hosts
  Ctrl+C
  ```

---




## 6. Common Pod Errors

### ImagePullBackOff
Occurs when Kubernetes can't pull the image. Causes:
- Incorrect image name or tag
- Missing IAM permission for private images (like ECR)
	- Attach IAM policy `AmazonEC2ContainerRegistryReadOnly` to the node group's IAM role.

Fix:
```bash
kubectl describe pod pod-name
```


### CrashLoopBackOff
Occurs when containers repeatedly crash. Causes:
- App errors at startup
- Background-only processes
	- Misconfigured container, e.g., runs in background and exits immediately
- Liveness probe failures

Fix:
```bash
kubectl logs pod-name
kubectl logs -f pod-name	# live logs
kubectl logs -p pod-name	# previous crash
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


### Pods in NotReady state
Readiness probe is failing, so pod will not receive traffic via Service.

Fix:
```bash
# Describe pod to check events
kubectl describe pod pod-name

# Check container logs for app-specific errors
kubectl logs -f pod-name
kubectl logs -f pod-name -c container-name
```

---




## 7. How to Debug Services
Pods are running and ready, but the app is not accessible.

### Checklist:
- Check service endpoints (should show pod IPs):
  ```bash
  kubectl get pods -o wide
  kubectl get endpoints my-service
  ```

-  If no endpoints:
	- Pods might not have correct labels Or there's a typo in the Service's selector

- If endpoints exist but app still not reachable:
	- Likely issue with targetPort mismatch

- Port forward to test traffic flow:
  ```bash
  # First terminal
  kubectl port-forward service/my-service 3000:7070

  # Second terminal
  curl localhost:3000/api/devices
  ```

---




## 8. How to Debug Ingress
When pods and services are working, but you can't access the app:

### Ingress Debug:
- Check ingress config:
  ```bash
  kubectl get ing
  kubectl describe ing my-ingress
  /*
    -If the Backend is empty, it means the service.name or service.port is incorrect.
    -If the Backend is present but the app is still not reachable, then it could be an
	 infrastructure or load balancer issue.
  */
  ```

- Infra Connectivity Check via Ingress Controller:
  ```bash
  # get nginx-ingress-controller-pod
  kubectl get pods -n ingress-nginx
  
  # describe nginx-ingress-controller-pod to find exposed ports
  kubectl describe pod nginx-ingress-controller-pod-name -n ingress-nginx | grep Ports

  # First terminal
  kubectl port-forward nginx-ingress-controller-pod-name 3000:80 -n ingress-nginx

  # Second terminal
  curl localhost:3000/api/devices
  /*
    If app is accessible then issue is in external infrastructure/load balancer.
    If app is not accessible then issue is with Ingress config or controller.
  */
  ```

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

---