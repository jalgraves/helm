.PHONY: all test clean

SHELL := /bin/bash

ifeq ($(env),dev)
	context = ${DEV_CONTEXT}
	namespace = ${DEV_NAMESPACE}
else ifeq ($(env),prod)
	context = ${PROD_CONTEXT}
	namespace = ${PROD_NAMESPACE}
endif

add_repos:
	helm repo add istio https://istio-release.storage.googleapis.com/charts && \
	helm repo update

context:
	kubectl config use-context $(context)

cilium: update context
	helm upgrade cilium cilium/cilium --install \
		--version 1.10.5 \
		--namespace kube-system --reuse-values \
		--set hubble.relay.enabled=true \
		--set hubble.ui.enabled=true \
		--set ipam.operator.clusterPoolIPv4PodCIDR="10.7.0.0/16"\
		--debug

istio_base: update context
	helm upgrade istio-base istio/base --install \
		--namespace istio-system \
		--version 1.12.1 \
        --create-namespace

istiod: update context
	helm upgrade istiod istio/istiod --install \
		--version 1.12.1 \
        --namespace istio-system

gateway_ns: context
	kubectl create namespace istio-ingress && \
		kubectl label namespace istio-ingress istio-injection=enabled

istio_gateway:
	helm upgrade istio-ingress istio/gateway --install \
		--version 1.12.1 \
        --namespace istio-ingress \
        --set service.type=None && \
		kubectl apply -n istio-ingress istio-ingress/templates

install_istio: istio_base istiod gateway_ns istio_gateway

namespaces:
	kubectl create ns prod && \
		kubectl create ns database && \
		kubectl label namespace prod istio-injection=enabled

update:
	helm repo update

app_secret: context
	kubectl create secret generic app-creds \
		--namespace $(namespace) \
		--from-literal=api_user="${API_USER}" \
		--from-literal=api_pass="${API_PASS}" \
		--from-literal=db_host="${DB_HOST}" \
		--from-literal=db_pass="${DB_PASS}" \
		--from-literal=db_port="${DB_PORT}" \
		--from-literal=db_user="${DB_USER}"

db_secret: context
	kubectl create secret generic db-creds \
		--namespace "${DB_NAMESPACE}" \
		--from-literal=db_admin_user="${DB_ADMIN_USER}" \
		--from-literal=db_admin_pass="${DB_ADMIN_PASS}" \
		--from-literal=db_user="${DB_USER}" \
		--from-literal=db_pass="${DB_PASS}" \
		--from-literal=menu_db_name="${MENU_DB_NAME}" \
		--from-literal=merch_db_name="${MERCH_DB_NAME}" \
		--from-literal=users_db_name="${USERS_DB_NAME}"

menu_api_secret: context
	kubectl create secret generic users-api-creds \
		--namespace $(namespace) \
		--from-literal=db_name="${MENU_DB_NAME}"

merch_api_secret: context
	kubectl create secret generic merch-api-creds \
		--namespace $(namespace) \
		--from-literal=db_name="${MERCH_DB_NAME}"

users_api_secret: context
	kubectl create secret generic users-api-creds \
		--namespace $(namespace) \
		--from-literal=default_admin_user="${DEFAULT_ADMIN_USER}" \
		--from-literal=default_admin_pass="${DEFAULT_ADMIN_PASS}" \
		--from-literal=db_name="${USERS_DB_NAME}"

services_secret: context
	kubectl create secret generic services \
		--namespace $(namespace) \
		--from-literal=contact_api_host="${CONTACT_API_HOST}" \
		--from-literal=contact_api_protocol="${CONTACT_API_PROTOCOL}" \
		--from-literal=menu_api_host="${MENU_API_HOST}" \
		--from-literal=menu_api_protocol="${MENU_API_PROTOCOL}" \
		--from-literal=merch_api_host="${MERCH_API_HOST}" \
		--from-literal=merch_api_protocol="${MERCH_API_PROTOCOL}" \
		--from-literal=users_api_host="${USERS_API_HOST}" \
		--from-literal=users_api_protocol="${USERS_API_PROTOCOL}"

secrets: db_secret menu_api_secret merch_api_secret users_api_secret
