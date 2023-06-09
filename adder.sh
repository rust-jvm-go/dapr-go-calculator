#!/usr/bin/env bash

(cd ./1.deploy && kubectl delete -f adder.yaml)

docker rmi --force "$(docker inspect --format="{{.Id}}" localhost:32000/dapr-go-calculator-adder)"

docker build -f adder/Dockerfile adder/. -t localhost:32000/dapr-go-calculator-adder

sudo microk8s.ctr images rm localhost:32000/dapr-go-calculator-adder
sudo microk8s.ctr images rm --sync "$(sudo microk8s.ctr images list -q | grep localhost:32000/dapr-go-calculator-adder@sha256)"

docker push localhost:32000/dapr-go-calculator-adder

(cd ./1.deploy && kubectl apply -f adder.yaml)
