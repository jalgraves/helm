.PHONY: all test clean

env ?= dev
name ?= menu-api
image ?= menu_api
tag ?= $(shell grep 'appVersion:' Chart.yaml | cut -f 2 -d' ')
port ?= 5004
db_port ?= ${DB_PORT}
db_host ?= ${DB_HOST}
db_name ?= ${DB_NAME}
db_user ?= ${DB_USER}

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
			--set db.host=$(db_host) \
			--set db.port=$(db_port) \
			--set db.name=$(db_name) \
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
			--set db.host=$(db_host) \
			--set db.port=$(db_port) \
			--set db.name=$(db_name) \
			--debug


port_forward:
		kubectl port-forward --namespace default svc/$(name) $(port):$(port) &
