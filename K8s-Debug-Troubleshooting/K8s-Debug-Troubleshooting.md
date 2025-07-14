# Kubernetes Troubleshooting Guide

A step-by-step guide for understanding and troubleshooting Kubernetes deployments. This README is based on a transcription of a video tutorial, revised and enriched with correct commands, structure, and best practices.

---

## Table of Contents

* [Introduction](#introduction)
* [Connecting Deployment & Service](#connecting-deployment--service)
* [Connecting Service & Ingress](#connecting-service--ingress)
* [Recap on Ports](#recap-on-ports)
* [3 Steps to Debug Kubernetes](#3-steps-to-debug-kubernetes)
* [How to Debug Pods](#how-to-debug-pods)
* [Common Pod Errors](#common-pod-errors)

  * [ImagePullBackOff](#imagepullbackoff)
  * [CrashLoopBackOff](#crashloopbackoff)
  * [RunContainerError](#runcontainererror)
  * [Pending Pods](#pending-pods)
  * [Pods Not Ready](#pods-not-ready)
* [How to Debug Services](#how-to-debug-services)
* [How to Debug Ingress](#how-to-debug-ingress)
* [Summary](#summary)

---

## Introduction

Kubernetes applications typically involve three components:

* **Deployment** â€“ Blueprint for Pods and replicas
* **Service** â€“ Internal load balancer
* **Ingress** â€“ External access to services

In Kubernetes, traffic flows in layers:

1. **Ingress** (external load balancer)
2. **Service** (internal load balancer)
3. **Pods** (actual workloads)

---

## Connecting Deployment & Service

### Key Points:

* Services do **not** connect to Deployments directly â€” they target **Pods**.
* Match labels are crucial:

  ```bash
  kubectl get pods --show-labels
  kubectl get pods --selector app=my-app --show-labels
  ```
* Verify endpoints:

  ```bash
  kubectl get endpoints <service-name>
  ```
* Test service with port-forwarding:

  ```bash
  kubectl port-forward service/my-service 3000:7070
  curl localhost:3000/api/devices
  ```

---

## Connecting Service & Ingress

### Steps:

1. Ingress must reference correct **service name** and **service port**.
2. Named ports in services **cannot** be referenced in Ingress definitions.

### Test Ingress:

Using Minikube:

```bash
minikube start
minikube addons enable ingress
kubectl apply -f 7-example
kubectl get pods -n ingress-nginx
kubectl port-forward <nginx-ingress-pod> 3000:80 -n ingress-nginx
curl localhost:3000/api/devices
```

### With Host Header:

```bash
kubectl apply -f 9-example
curl --header 'Host: api.example.pvt' localhost:3000/api/devices
```

---

## Recap on Ports

* `service.selector` â†’ matches pod labels
* `service.targetPort` â†’ matches container port
* `service.port` â†’ can be any number
* `ingress.service.name` and `ingress.service.port` must match corresponding service

---

## 3 Steps to Debug Kubernetes

1. **Pods** â€“ Ensure they are running and ready
2. **Service** â€“ Ensure it correctly routes to pods
3. **Ingress** â€“ Ensure external traffic is properly forwarded

---

## How to Debug Pods

### Commands:

```bash
kubectl get pods
kubectl logs -f <pod-name>
kubectl describe pod <pod-name>
kubectl get pod <pod-name> -o yaml
kubectl exec -it <pod-name> -- bash
```

---

## Common Pod Errors

### ImagePullBackOff

* Causes:

  * Invalid image name
  * Incorrect tag
  * Private image without credentials
* Fix:

  * Check spelling/tag
  * Add imagePullSecrets or IAM roles

### CrashLoopBackOff

* Causes:

  * Application crash
  * Background-only commands
  * Failed liveness probes
* Fix:

  ```bash
  kubectl logs <pod>
  kubectl logs <pod> -f
  kubectl logs <pod> -p
  ```

### RunContainerError

* Cause: Misconfigured volume mount or other init error
* Fix:

  ```bash
  kubectl describe pod <pod-name>
  ```

### Pending Pods

* Causes:

  * Resource quota exceeded
  * Insufficient resources
  * Affinity/tolerations mismatch
  * Pending volume claims
* Fix:

  ```bash
  kubectl describe pod <pod-name>
  ```

### Pods Not Ready

* Cause: Failing readiness probe
* Fix:

  ```bash
  kubectl describe pod <pod-name>
  kubectl logs -f <pod-name>
  kubectl logs -f <pod-name> -c <container-name>
  ```

---

## How to Debug Services

### Checklist:

* Pods are running and ready
* Labels match selector
* Target port is correct

### Commands:

```bash
kubectl get pods -o wide
kubectl get endpoints <service-name>
kubectl port-forward service/<service-name> 3000:7070
curl localhost:3000/api/devices
```

---

## How to Debug Ingress

### Checklist:

* `service.name` and `service.port` match
* Check `kubectl describe ing <ingress-name>` â†’ Backend column
* Port-forward ingress pod if needed

### Commands:

```bash
kubectl get ing
kubectl describe ing <ingress-name>
kubectl get pods -n ingress-nginx
kubectl describe pod <nginx-ingress-pod> -n ingress-nginx | grep Ports
kubectl port-forward <nginx-ingress-pod> 3000:80 -n ingress-nginx
curl localhost:3000/api/devices
```

### Note:

If forwarding to the pod works but external access doesn't â€” it's likely an infrastructure/load balancer issue.

---

## Summary

* Debug bottom-up: **Pods â†’ Service â†’ Ingress**
* Validate label and port matching
* Use `kubectl port-forward` to test individual components
* Use `describe`, `logs`, and `exec` commands to inspect issues

You can apply these same debugging principles to:

* **Jobs**
* **CronJobs**
* **StatefulSets**
* **DaemonSets**

Happy Debugging! ðŸš€