#!/usr/bin/env bash

docker build -t tomotoyinbo/multi-client:latest -t tomotoyinbo/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t tomotoyinbo/multi-server:latest -t tomotoyinbo/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t tomotoyinbo/multi-worker:latest -t tomotoyinbo/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push tomotoyinbo/multi-client:latest
docker push tomotoyinbo/multi-server:latest
docker push tomotoyinbo/multi-worker:latest

docker push tomotoyinbo/multi-client:$SHA
docker push tomotoyinbo/multi-server:$SHA
docker push tomotoyinbo/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=tomotoyinbo/multi-server:$SHA
kubectl set image deployments/client-deployment client=tomotoyinbo/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=tomotoyinbo/multi-worker:$SHA