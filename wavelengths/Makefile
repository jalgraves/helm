.PHONY: all test clean

image ?= wavelengths
tag ?= latest

package:
		helm package .

dev_install:
		kubectl config use-context docker-desktop
		helm upgrade --install wavelengths . \
			--set image.name=$(image) \
			--set image.tag=$(tag) \
			--set image.pullPolicy=Never \
			--debug

install:
		kubectl config use-context beantown
		helm upgrade --install wavelengths . \
			--set image.tag=$(tag) \
			--debug

port_forward:
		kubectl port-forward --namespace default svc/wavelengths 3077:3077 &
