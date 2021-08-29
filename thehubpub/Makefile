.PHONY: all test clean

name ?= hubpub
image ?= hubpub
env ?= prod
tag ?= $(shell grep 'appVersion:' Chart.yaml | cut -f 2 -d' ')
contact_api_protocol ?= https
contact_api_host ?= ${CONTACT_API_INGRESS_HOST}
ingress_enabled ?= false
ingress_host ?= ${HUBPUB_INGRESS_HOST}


package:
		helm package .

dev_install:
		kubectl config use-context docker-desktop
		helm upgrade --install hubpub . \
			--set global.env=dev \
			--set ingressHost=$(ingress_host) \
			--set contactApiHost=$(contact_api_host) \
			--set contactApiProtocol=$(contact_api_protocol) \
			--set ingress.enabled=false \
			--debug

install:
		kubectl config use-context beantown
		helm upgrade --install hubpub . \
			--set global.env=prod \
			--set ingressHost=$(ingress_host) \
			--set contactApiHost=$(contact_api_host) \
			--set contactApiProtocol=$(contact_api_protocol) \
			--set ingress.enabled=true \
			--debug

template:
		helm template . \
			--name-template=$(name) \
			--set global.env=$(env) \
			--set ingressHost=$(ingress_host) \
			--set contactApiHost=$(contact_api_host) \
			--set contactApiProtocol=$(contact_api_protocol) \
			--set ingress.enabled=true \
			--debug

port_forward:
		kubectl port-forward --namespace default svc/hubpub 3037:3037 &
