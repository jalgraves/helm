
name ?= postgres
port ?= ${DB_PORT}
namespace ?= ${DB_NAMESPACE}
tag ?= latest

install:
	kubectl config use-context docker-desktop
	helm upgrade --install $(name) . \
		--namespace $(namespace) \
		--set image.tag=$(tag) \
		--debug

prod_install:
	kubectl config use-context new-beantown
	helm upgrade --install $(name) . \
		--namespace $(namespace) \
		--set image.tag=$(tag) \
		--set dbUserPass=$(db_user_pass) \
		--debug

template:
	helm template . \
		--namespace $(namespace) \
		--name-template=$(name) \
		--set image.tag=$(tag) \
		--set dbUserPass=$(db_user_pass) \
		--debug

port_forward:
		kubectl port-forward --namespace $(namespace) svc/$(name) $(port):$(port)

stop_pf:
		../scripts/stop_port_forward.sh $(port)
