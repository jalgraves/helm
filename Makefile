# -include postgres/Makefile
.PHONY: all test clean
export MAKE_PATH ?= $(shell pwd)
export SELF ?= $(MAKE)
SHELL := /bin/bash

MAKE_FILES = ${MAKE_PATH}/**/Makefile ${MAKE_PATH}/Makefile

ifeq ($(env),dev)
	context = ${DEV_CONTEXT}
	namespace = ${DEV_NAMESPACE}
else ifeq ($(env),prod)
	context = ${PROD_CONTEXT}
	namespace = ${PROD_NAMESPACE}
else
	env := dev
endif

## Add Helm repos
helm/repos/add:
	helm repo add istio https://istio-release.storage.googleapis.com/charts && \
		helm repo add jetstack https://charts.jetstack.io && \
		helm repo update

context:
	kubectl config use-context $(context)

## Install Cilium CNI
cilium/instaall: update context
	helm upgrade cilium cilium/cilium --install \
		--version 1.10.5 \
		--namespace kube-system --reuse-values \
		--set hubble.relay.enabled=true \
		--set hubble.ui.enabled=true \
		--set ipam.operator.clusterPoolIPv4PodCIDR="10.7.0.0/16"\
		--debug

istio/base/install: update context
	helm upgrade istio-base istio/base --install \
		--namespace istio-system \
		--version 1.12.1 \
        --create-namespace

istio/istiod/install: update context
	helm upgrade istiod istio/istiod --install \
		--version 1.12.1 \
        --namespace istio-system

gateway_ns: context
	kubectl create namespace istio-ingress && \
		kubectl label namespace istio-ingress istio-injection=enabled

istio/gateway/install:
	helm upgrade istio-ingress istio/gateway --install \
		--version 1.12.1 \
        --namespace istio-ingress \
        --set service.type=None && \
		kubectl apply -n istio-ingress -f istio-ingress/templates

## Install Istio
istio/install: istio/base/install istio/istiod/install gateway_ns istio/gateway/install

namespaces: context
	kubectl create ns prod && \
		kubectl create ns database && \
		kubectl label namespace prod istio-injection=enabled

app/creds/secret: context
	kubectl create secret generic app-creds \
		--namespace $(namespace) \
		--from-literal=api_user="${API_USER}" \
		--from-literal=api_pass="${API_PASS}" \
		--from-literal=db_host="${DB_HOST}" \
		--from-literal=db_pass="${DB_PASS}" \
		--from-literal=db_port="${DB_PORT}" \
		--from-literal=db_user="${DB_USER}"

## Create Contact API secret
contact/secret: context
	cd contact_api && make secret env=$(env)

## Create database secret
db/secret: context
	cd postgres && make secret env=$(env)

## Create Menu API secret
menu/secret: context
	cd menu_api && make secret env=$(env)

## Create Merch API secret
merch/secret: context
	cd merch_api && make secret env=$(env)

## Create Users API secret
users/secret: context
	cd users_api && make secret env=$(env)

## Create common apps secret
app/services/secret: context
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

cert_manager/install:
	helm install \
		cert-manager jetstack/cert-manager \
		--namespace cert-manager \
		--create-namespace \
		--version v1.6.1 \
		--set prometheus.enabled=false

## Show available commands
help:
	@printf "Available targets:\n\n"
	@$(SELF) -s help/generate | grep -E "\w($(HELP_FILTER))"

help/generate:
	@awk '/^[a-zA-Z\_0-9%:\\\/-]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = $$1; \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			gsub("\\\\", "", helpCommand); \
			gsub(":+$$", "", helpCommand); \
			printf "  \x1b[32;01m%-35s\x1b[0m %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKE_FILES) | sort -u
	@printf "\n\n"

## Install Contact API
contact/install:
	cd contact_api && make install env=$(env) context=$(context)

## Install database
db/install:
	cd postgres && make install env=$(env) context=$(context)

## Install Users API
users/install:
	cd users_api && make install env=$(env) context=$(context)

## Install Menu API
menu/install:
	cd menu_api && make install env=$(env) context=$(context)

## Install Admin frontend
admin/install:
	cd admin && make install env=$(env) context=$(context)

## Uninstall Admin frontend
admin/delete:
	cd admin && make delete env=$(env) context=$(context)

## Install Beantownpub frontend
beantown/install:
	cd beantown && make install env=$(env) context=$(context)

## Install Thehubpub frontend
thehubpub/install: context
	cd thehubpub && make install env=$(env) context=$(context)

## Install Wavelengths frontend
wavelengths/install: context
	cd wavelengths && make install env=$(env) context=$(context)

## Install DrDavisIceCream frontend
drdavisicecream/install: context
	cd drdavisicecream && make install env=$(env) context=$(context)

## Forward port for Cilium Hubble UI
hubble/port_forward:
	kubectl port-forward --namespace kube-system svc/hubble-ui 80:8080
