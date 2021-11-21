
name ?= test-db
env ?= dev
tag ?= latest

install:
		kubectl config use-context docker-desktop
		helm upgrade --install $(name) . \
			--set image.tag=$(tag) \
			--set dbUserPass=$(db_user_pass) \
			--debug

prod_install:
		kubectl config use-context beantown
		helm upgrade --install $(name) . \
			--set image.tag=$(tag) \
			--set dbUserPass=$(db_user_pass) \
			--debug

template:
		helm template . \
			--name-template=$(name) \
			--set image.tag=$(tag) \
			--set dbUserPass=$(db_user_pass) \
			--debug
