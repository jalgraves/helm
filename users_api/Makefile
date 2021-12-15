env ?= dev
name ?= users-api
image ?= users_api
tag ?= $(shell grep 'appVersion:' Chart.yaml | cut -f 2 -d' ')
port ?= 5045
log_level ?= INFO

ifeq ($(env),dev)
	namespace = ${DEV_NAMESPACE}
else
	namespace = ${PROD_NAMESPACE}
endif

package:
		helm package .

clean:
		rm *.tgz || true

dev_install:
		kubectl config use-context docker-desktop
		helm upgrade --install $(name) . \
			--namespace $(namespace) \
			--set global.env=dev \
			--set image.name=$(image) \
			--set image.tag=$(tag) \
			--set logLevel=$(log_level) \
			--debug

prod_install:
		kubectl config use-context new-beantown
		helm upgrade --install $(name) . \
			--namespace $(namespace) \
			--set global.env=prod \
			--set image.tag=$(tag) \
			--set image.pullPolicy=Always \
			--set logLevel=INFO \
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
		../scripts/stop_port_forward.sh $(namespace) $(name)

logs:
		../scripts/get_pod_logs.sh $(namespace) $(name)

describe:
		../scripts/describe_pod.sh $(namespace) $(name)

kill_pod:
		../scripts/kill_pod.sh $(namespace) $(name)
