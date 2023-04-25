#!/usr/bin/env bash

(cd ./1.deploy && kubectl delete -f react-calculator.yaml)

docker rmi --force "$(docker inspect --format="{{.Id}}" localhost:32000/dapr-go-calculator-react-frontend)"

docker build -f react-calculator/Dockerfile react-calculator/. -t localhost:32000/dapr-go-calculator-react-frontend

sudo microk8s.ctr images rm localhost:32000/dapr-go-calculator-react-frontend
sudo microk8s.ctr images rm --sync "$(sudo microk8s.ctr images list -q | grep localhost:32000/dapr-go-calculator-react-frontend@sha256)"

docker push localhost:32000/dapr-go-calculator-react-frontend

(cd ./1.deploy && kubectl apply -f react-calculator.yaml)
