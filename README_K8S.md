# Kubernetes 🧊

## Podman desktop setup

After installing from `Brewfile`:

- Create VM in Podman desktop by completing the setup wizard.
- Install Minikube extension in Podman desktop (see [here](https://podman-desktop.io/docs/minikube)) by installing `ghcr.io/containers/podman-desktop-extension-minikube` from OCI image.

## Minikube setup

Using Podman desktop:

- In Podman desktop -> Settings -> Resources, create new minikube cluster by clicking "create".

Using `minikube`:

- Start minikube with `minikube start --driver=podman --container-runtime=cri-o` (the options are taken from the defaults in Podman Desktop).

## Verify Minikube setup

- `minikube status`
- `kubectl config current-context`
- `cat ~/.minikube/machines/minikube/config.json`
- `cat ~/.kube/config`

## Minikube usage

Run `cd templates/minikube` for the below commands to work.

### Build and push image with Podman

- Build image with `podman build -t gohello:latest .`
- Tag image for dockerhub: `podman tag gohello:latest docker.io/fredrikaverpil/gohello:0.0.1`.
- Log into docker.io: `podman login docker.io`.
- Push image to dockerhub: `podman push docker.io/fredrikaverpil/gohello:0.0.1`.

### Deploy

Using `helm`:

- Install chart with `helm install gohello ./chart`.

Using `kubectl`:

- Create pod with `kubectl apply -f ./\*.yaml`.
- Verify pod with `kubectl get pods -n gohello`

Using `terraform`:

- Review deployment plan with `terraform plan`.
- Create pod with `terraform apply`.
- Verify pod with `kubectl get pods -n gohello`

### Port-forward

Using `helm`:

- Not needed, as the chart already has a service configured. Access in browser by executing `minikube service gohello-svc -n gohello`.

Using `k9s`:

- Run by providing namespace `k9s -n gohello` or by switching namespace in k9s by hiting `:` followed by `namespaces`.
- Find the gohello-container, hit `shift-f` and make it forward to `localhost` on port `8080`.
- Access in browser: `http://localhost:8080/`
- Remove the port-forward by hitting `f`. This will show all active port-forwards. Hit `ctrl+d` to remove the entry from the list.

Using `kubectl`:

- Port-forward to pod with `kubectl port-forward pod/gohello-pod -n gohello 8080:9090`.
- Access in browser: `http://localhost:8080/`

### Logs

Using `k9s`:

- Run by providing namespace `k9s -n gohello` or by switching namespace in k9s by hiting `:` followed by `namespaces`.
- Find the gohello-container, hit `shift-l` to view logs.

Using `kubectl`:

- View logs with `kubectl logs -n gohello gohello-pod`.

Using `stern`:

- View logs with `stern -n gohello gohello-pod`.

### Debugging

Using `helm`:

- Debug the helm chart with `helm template ./chart --debug`.
- Lint the helm chart with `helm lint ./chart`

Using `k9s`:

- Run by providing namespace `k9s -n gohello` or by switching namespace in k9s by hiting `:` followed by `namespaces`.
- Find the gohello-container, hit `shift-d` to debug.

Using `kubectl`:

- Debug with `kubectl debug -n gohello gohello-pod`.

### Teardown

Using `helm`:

- Delete chart with `helm uninstall gohello`.

Using `kubectl`:

- Delete pod with `kubectl delete -f ./\*.yaml`.

Using `terraform`:

- Tear down everything: `terraform destroy`.

## Problem solving

- Reset minikube cluster: `minikube stop && minikube delete && minikube start --driver=podman --container-runtime=cri-o`
- Get minikube IP: `minikube ip`
- Get minikube dashboard: `minikube dashboard`
- Something is already running on port XXXX; `lsof -i :XXXX` and `kill -9 <PID>`.
- Remove cache of downloaded images from minikube:
  - `minikube cache delete <image-name>`
  - `minikube cache delete --all`
- Validate helm chart with `helm template ./chart --debug`.