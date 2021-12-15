.PHONY: all test clean

name ?= ${APP_NAME}
image ?= ${IMAGE_NAME}
tag ?= $(shell grep 'appVersion:' Chart.yaml | cut -f 2 -d' ')

ifeq ($(env),dev)
	context = ${DEV_CONTEXT}
	namespace = ${DEV_NAMESPACE}
else ($(env),prod)
	context = ${PROD_CONTEXT}
	namespace = ${PROD_NAMESPACE}
endif

package:
		helm package .

context:
	kubectl config use-context $(context)

install: context
		helm upgrade --install $(name) . \
			--namespace $(namespace) \
			--set global.env=$(env) \
			--debug

template:
		helm template . \
			--name-template=$(name) \
			--namespace $(namespace) \
			--set global.env=$(env) \
			--debug

port_forward: context
		kubectl port-forward --namespace $(namespace) svc/$(name) $(port):$(port)
