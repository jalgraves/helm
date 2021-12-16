.PHONY: all test clean

name ?= ${MERCH_NAME}
tag ?= $(shell grep 'appVersion:' Chart.yaml | cut -f 2 -d' ')
port ?= ${MERCH_API_PORT}
log_level ?= DEBUG

ifeq ($(env),dev)
	context = ${DEV_CONTEXT}
	namespace = ${DEV_NAMESPACE}
else ($(env),prod)
	context = ${PROD_CONTEXT}
	namespace = ${PROD_NAMESPACE}
endif

package:
		helm package .

clean:
		rm *.tgz || true

context:
	kubectl config use-context $(context)

dev_install:
		kubectl config use-context $(context)
		helm upgrade --install $(name) . \
			--set global.env=$(env) \
			--set image.name=$(name) \
			--set image.tag=$(tag) \
			--set logLevel=$(log_level) \
			--debug

prod_install:
		kubectl config use-context $(context)
		helm upgrade --install $(name) . \
			--set global.env=$(env) \
			--set image.tag=$(tag) \
			--set image.pullPolicy=Always \
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

secret: context
	kubectl create secret generic merch-api-creds \
		--namespace $(namespace) \
		--from-literal=db_name="${MERCH_DB_NAME}"
