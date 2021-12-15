.PHONY: all test clean

env ?= dev
name ?= menu-api
image ?= menu_api
tag ?= $(shell grep 'appVersion:' Chart.yaml | cut -f 2 -d' ')
port ?= ${MENU_API_PORT}
log_level ?=${API_LOG_LEVEL}

ifeq ($(env),dev)
	context = ${DEV_CONTEXT}
	namespace = ${DEV_NAMESPACE}
else
	context = ${PROD_CONTEXT}
	namespace = ${PROD_NAMESPACE}
endif

package:
		helm package .

clean:
		rm *.tgz || true

dev_install:
		kubectl config use-context $(context)
		helm upgrade --install $(name) . \
			--namespace $(namespace) \
			--set global.env=dev \
			--set image.name=$(image) \
			--set image.tag=$(tag) \
			--set logLevel=$(log_level) \
			--debug

prod_install:
		kubectl config use-context $(context)
		helm upgrade --install $(name) . \
			--namespace $(namespace) \
			--set global.env=prod \
			--set image.tag=$(tag) \
			--set image.pullPolicy=Always \
			--set logLevel=$(log_level) \
			--debug

template:
		helm template . \
			--name-template=$(name) \
			--set global.env=$(env) \
			--set image.name=$(image) \
			--set image.tag=$(tag) \
			--debug


port_forward:
		kubectl port-forward --namespace $(namespace) svc/$(name) $(port):$(port)

stop_pf:
		../scripts/stop_port_forward.sh $(port)

logs:
		../scripts/get_pod_logs.sh $(namespace) $(name)

describe:
		../scripts/describe_pod.sh $(namespace) $(name)

kill_pod:
		../scripts/kill_pod.sh $(namespace) $(name)
