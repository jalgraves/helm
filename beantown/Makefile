.PHONY: all test clean

env ?= dev
name ?= menu-api
image ?= menu_api
tag ?= latest
port ?= 5004

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
			--set db.host=52.15.231.18 \
			--set db.port=32432 \
			--debug

prod_install:
		kubectl config use-context beantown
		helm upgrade --install $(name) . \
			--set global.env=prod \
			--set image.tag=$(tag) \
			--set image.pullPolicy=Always \
			--debug

template:
		helm template . \
			--name-template=$(name) \
			--set global.env=$(env) \
			--set image.name=$(image) \
			--set image.tag=$(tag) \
			--set image.pullPolicy=Never \
			--set db.host=52.15.231.18 \
			--set db.port=32432 \
			--debug


port_forward:
		kubectl port-forward --namespace default svc/$(name) $(port):$(port) &
