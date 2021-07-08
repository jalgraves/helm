.PHONY: all test clean

name ?= users-api
image ?= users_api
tag ?= latest
port ?= 5045

package:
		helm package .

clean:
		rm *.tgz || true

dev_install:
		kubectl config use-context docker-desktop
		helm upgrade --install $(name) . \
			--set global.env=dev \
			--set image.name=$(image) \
			--set image.tag=$(tag) \
			--set image.pullPolicy=Never \
			--set db.host=${POSTGRES_IP} \
			--set db.port=32432 \
			--debug

install:
		kubectl config use-context beantown
		helm upgrade --install $(name) . \
			--set image.tag=$(tag) \
			--set ingressHost=${USERS_INGRESS_HOST} \
			--debug

port_forward:
		kubectl port-forward --namespace default svc/$(name) $(port):$(port) &
