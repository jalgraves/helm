.PHONY: all test clean

name ?= beantown
image ?= beantown
env ?= prod
tag ?= $(shell grep 'appVersion:' Chart.yaml | cut -f 2 -d' ')
contact_api_protocol ?= ${CONTACT_API_PROTOCOL}
contact_api_host ?= ${CONTACT_API_HOST}
menu_api_protocol ?= ${MENU_API_PROTOCOL}
menu_api_host ?= ${MENU_API_HOST}
merch_api_protocol ?= ${MENU_API_PROTOCOL}
merch_api_host ?= ${MENU_API_HOST}
ingress_enabled ?= ${BEANTOWN_INGRESS_ENABLED}
ingress_host ?= ${BEANTOWN_INGRESS_HOST}


package:
		helm package .

dev_install:
		kubectl config use-context docker-desktop
		helm upgrade --install beantown . \
			--set global.env=dev \
			--set contactApiHost=$(contact_api_host) \
			--set contactApiProtocol=$(contact_api_protocol) \
			--set menuApiHost=$(menu_api_host) \
			--set menuApiProtocol=$(menu_api_protocol) \
			--set merchApiHost=$(merch_api_host) \
			--set merchApiProtocol=$(merch_api_protocol) \
			--set ingress.enabled=false \
			--debug

install:
		kubectl config use-context beantown
		helm upgrade --install beantown . \
			--set global.env=prod \
			--set contactApiHost=$(contact_api_host) \
			--set contactApiProtocol=$(contact_api_protocol) \
			--set menuApiHost=$(menu_api_host) \
			--set menuApiProtocol=$(menu_api_protocol) \
			--set merchApiHost=$(merch_api_host) \
			--set merchApiProtocol=$(merch_api_protocol) \
			--set ingress.enabled=true \
			--set ingressHost=$(ingress_host) \
			--debug

template:
		helm template . \
			--name-template=$(name) \
			--set global.env=$(env) \
			--set ingressHost=$(ingress_host) \
			--set contactApiHost=$(contact_api_host) \
			--set contactApiProtocol=$(contact_api_protocol) \
			--set menuApiHost=$(menu_api_host) \
			--set menuApiProtocol=$(menu_api_protocol) \
			--set merchApiHost=$(merch_api_host) \
			--set merchApiProtocol=$(merch_api_protocol) \
			--set ingress.enabled=true \
			--debug

port_forward:
		kubectl port-forward --namespace default svc/beantown 3000:3000 &
