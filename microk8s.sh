#!/usr/bin/env bash

(cd ./1.deploy && kubectl delete -f .)

docker rmi --force "$(docker inspect --format="{{.Id}}" localhost:32000/dapr-go-calculator-adder)"
docker rmi --force "$(docker inspect --format="{{.Id}}" localhost:32000/dapr-go-calculator-multiplier)"
docker rmi --force "$(docker inspect --format="{{.Id}}" localhost:32000/dapr-go-calculator-react-frontend)"

docker build -f adder/Dockerfile adder/. -t localhost:32000/dapr-go-calculator-adder
docker build -f multiplier/Dockerfile multiplier/. -t localhost:32000/dapr-go-calculator-multiplier
docker build -f react-calculator/Dockerfile react-calculator/. -t localhost:32000/dapr-go-calculator-react-frontend

sudo microk8s.ctr images rm localhost:32000/dapr-go-calculator-adder
sudo microk8s.ctr images rm localhost:32000/dapr-go-calculator-multiplier
sudo microk8s.ctr images rm localhost:32000/dapr-go-calculator-react-frontend
sudo microk8s.ctr images rm --sync "$(sudo microk8s.ctr images list -q | grep localhost:32000/dapr-go-calculator-adder@sha256)"
sudo microk8s.ctr images rm --sync "$(sudo microk8s.ctr images list -q | grep localhost:32000/dapr-go-calculator-multiplier@sha256)"
sudo microk8s.ctr images rm --sync "$(sudo microk8s.ctr images list -q | grep localhost:32000/dapr-go-calculator-react-frontend@sha256)"

docker push localhost:32000/dapr-go-calculator-adder
docker push localhost:32000/dapr-go-calculator-multiplier
docker push localhost:32000/dapr-go-calculator-react-frontend

(cd ./1.deploy && kubectl apply -f .)
