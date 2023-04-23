#!/usr/bin/env bash

(cd ./1.deploy && kubectl delete -f multiplier.yaml)

docker rmi --force "$(docker inspect --format="{{.Id}}" localhost:32000/dapr-go-calculator-multiplier:registry)"

docker build -f multiplier/Dockerfile multiplier/. -t localhost:32000/dapr-go-calculator-multiplier:registry

microk8s.ctr images rm localhost:32000/dapr-go-calculator-multiplier:registry
microk8s.ctr images rm --sync "$(microk8s.ctr images list -q | grep localhost:32000/dapr-go-calculator-multiplier@sha256)"

docker push localhost:32000/dapr-go-calculator-multiplier:registry

(cd ./1.deploy && kubectl apply -f multiplier.yaml)
