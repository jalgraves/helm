.PHONY: all test clean

name ?= beantown
image ?= beantown
env ?= dev
tag ?= $(shell grep 'appVersion:' Chart.yaml | cut -f 2 -d' ')
port ?= ${BEANTOWN_PORT}

ifeq ($(env),dev)
	context = ${DEV_CONTEXT}
	namespace = ${DEV_NAMESPACE}
else
	context = ${PROD_CONTEXT}
	namespace = ${PROD_NAMESPACE}
endif

install:
	kubectl config use-context $(context)
	helm upgrade --install beantown . \
		--namespace $(namespace) \
		--set global.env=$(env) \
		--debug

delete:
	kubectl config use-context $(context)
	helm uninstall $(name) -n $(namespace)

template:
	helm template . \
		--namespace $(namespace) \
		--name-template=$(name) \
		--set global.env=$(env) \
		--debug

.ONESHELL: port_forward


port_forward:
	kubectl port-forward --namespace $(namespace) svc/$(name) $(port):$(port)


stop_pf:
	../scripts/stop_port_forward.sh $(port)

logs:
	../scripts/get_pod_logs.sh $(namespace) $(name)
